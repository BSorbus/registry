class Proposal < ApplicationRecord
  extend ActiveModel::Translation
  include ActionView::Helpers::TextHelper

  # relations
  belongs_to :author, class_name: "User", foreign_key: :author_id
  belongs_to :proposal_type
  belongs_to :proposal_status
  belongs_to :organization
  belongs_to :register, optional: true

  has_one :register_registration_approved, class_name: "Register", foreign_key: :proposal_registration_approved_id, inverse_of: :proposal_registration_approved
  has_one :register_current_approved, class_name: "Register", foreign_key: :proposal_current_approved_id, inverse_of: :proposal_current_approved
  has_one :register_deletion_approved, class_name: "Register", foreign_key: :proposal_deletion_approved_id, inverse_of: :proposal_deletion_approved

  has_one :proposal_candidate, dependent: :destroy

  has_many :proposal_networks, dependent: :destroy
  has_many :proposal_services, dependent: :destroy
  has_many :proposal_areas, dependent: :destroy
  has_many :proposal_attachments, dependent: :destroy


  has_paper_trail versions: {
    # class_name: 'ProposalVersion'
    # scope: -> { order("id desc") }
  } #, meta: {author_id: :author_id}

  # validates
  validates :service_type, presence: true, inclusion: { in: ['j', 'p', 't'] }
  validates :insertion_date, presence: true
  validates :author, presence: true
  validates :organization, presence: true
  validates :proposal_type_id, presence: true, inclusion: { in: ProposalType::PROPOSAL_TYPES }
  validates :proposal_type, presence: true
  validates :proposal_status_id, presence: true, inclusion: { in: ProposalStatus::PROPOSAL_STATUSES }
  validates :proposal_status, presence: true
  validates :register, presence: true, if: -> { ProposalType::PROPOSAL_TYPES_ENABLED_REGISTER_ID.include?(proposal_type_id) }


  validate :scheduled_date_end_after_start

#scheduled_date after insertion

  validates :scheduled_start_date, presence: true
  validates :scheduled_end_date, presence: true, if: -> { (proposal_type_id == ProposalType::PROPOSAL_TYPE_DELETION) }
  validates :scheduled_end_date, presence: {
    message: ->(object, data) do
      I18n.t("activerecord.errors.messages.proposal_end_date_presence_if_organization_not_pl", organization: "#{object.organization.fullname_with_nip}" )
    end }, if: -> { (service_type == 't') && (organization.addresses.reject{ |x| not FeatureType.only_address_type_office.ids.include?(x.address_type_id) }.reject{ |x| x.country_code == 'PL' }.any?) }

  validate :approved_date_after_insertion_date
  validates :approved_date, presence: true, if: -> { (proposal_status_id == ProposalStatus::PROPOSAL_STATUS_APPROVED) }

  validate :rejected_date_after_insertion_date
  validates :rejected_date, presence: true, if: -> { (proposal_status_id == ProposalStatus::PROPOSAL_STATUS_REJECTED) }

  validate :annuled_date_after_insertion_date
  validates :annuled_date, presence: true, if: -> { (proposal_status_id == ProposalStatus::PROPOSAL_STATUS_ANNULLED) }

  validate :loofah_status_comment_present, if: -> { ProposalStatus::PROPOSAL_STATUSES_ENABLED_STATUS_COMMENT.include?(proposal_status_id) }

  # # if create/update proposal only one rec can have the status ProposalStatus::PROPOSAL_STATUS_CREATED
  # validates :proposal_status_id, 
  #   uniqueness: { scope: [:service_type, :organization_id],
  #                 message: ->(object, data) do
  #                   I18n.t("activerecord.errors.messages.proposal_status_taken", proposal_status_name: "#{object.proposal_status.name}", proposal_type_name: "#{object.proposal_type.name}" )
  #                 end }, if: -> { proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED }
                  

#  validate :proposal_networks_network_type_presence, if: -> { ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }
  validate_nested_uniqueness_of :proposal_networks, uniq_key: :network_type_id, scope: [:proposal], 
                                  case_sensitive: false, error_key: :proposal_networks_network_type_nested_taken, 
                                if: -> { ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }


#  validate :proposal_services_service_type_presence, if: -> { ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }
  validate_nested_uniqueness_of :proposal_services, uniq_key: :service_type_id, scope: [:proposal], 
                                  case_sensitive: false, error_key: :proposal_services_service_type_nested_taken,
                                if: -> { ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }

  validates :jst_date_of_adopting_the_resolution_date, presence: true, if: -> { (service_type == 'j') }
  validates :jst_resolution_number, presence: true, length: { in: 1..200 }, if: -> { (service_type == 'j') }
  validate :network_type_or_service_type_presence, if: -> { (service_type == 't') && ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }


  validate :proposal_proposal_areas_presence, if: -> { activity_area_whole_poland == false }
  validate_nested_uniqueness_of :proposal_areas, uniq_key: :proposal_id, scope: [:province_code, :district_code, :commune_code], 
                                  case_sensitive: false, error_key: :proposal_areas_proposal_codes_nested_taken, 
                                if: -> { activity_area_whole_poland == false }


  # validation on create proposal any type - always new_record? == true 
  validate :can_as_registration, if: -> { (proposal_type_id == ProposalType::PROPOSAL_TYPE_REGISTRATION) && 
                                          (proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED) && new_record? && organization_id.present? }
  validate :can_as_change,  if: -> { (proposal_type_id == ProposalType::PROPOSAL_TYPE_CHANGE) && 
                                     (proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED) && new_record? && organization_id.present? && register_id.present? }
  validate :can_as_deletion,  if: -> { (proposal_type_id == ProposalType::PROPOSAL_TYPE_DELETION) && 
                                                    (proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED) && new_record? && organization_id.present? && register_id.present? }

  # nested
  accepts_nested_attributes_for :proposal_networks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :proposal_services, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :proposal_areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :proposal_attachments, reject_if: :all_blank, allow_destroy: true


  def can_as_registration
    # always if proposal_type_id == ProposalType::PROPOSAL_TYPE_REGISTRATION 
    #        && proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
    if self.organization.proposals.where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).any?
      errors.add(:base, I18n.t("activerecord.errors.messages.proposal_status_created_exists", status: "#{self.proposal_status.name}", organization: "#{self.organization.fullname_with_nip}" ) )
    else
      registers = self.organization.registers.where(service_type: self.service_type)
      unless registers.empty?
        register = registers.order(:created_at).last unless registers.empty?
        if register.register_status_id == RegisterStatus::REGISTER_STATUS_CURRENT
          errors.add(:base, I18n.t("activerecord.errors.messages.register_current_exists", register_no: "#{register.fullname}" , organization: "#{register.organization.fullname_with_nip}"))
        end
      end
    end
  end

  def can_as_change
    # always if proposal_type_id == ProposalType::PROPOSAL_TYPE_CHANGE 
    #        && proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
    if self.organization.proposals.where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).any?
      errors.add(:base, I18n.t("activerecord.errors.messages.proposal_status_created_exists", status: "#{self.proposal_status.name}", organization: "#{self.organization.fullname_with_nip}" ) )
    else
      if self.register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_DELETION, 
          proposal_status_id: [ProposalStatus::PROPOSAL_STATUS_CREATED, ProposalStatus::PROPOSAL_STATUS_APPROVED]).any?
        errors.add(:base, I18n.t("activerecord.errors.messages.proposal_deletion_created_or_approved_exists"))
      else
        unless self.register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_REGISTRATION, 
            proposal_status_id: ProposalStatus::PROPOSAL_STATUS_APPROVED).any?
          errors.add(:base, I18n.t("activerecord.errors.messages.proposal_registration_approved_not_exists"))
        end
      end
    end
  end

  def can_as_deletion
    # always if proposal_type_id == ProposalType::PROPOSAL_TYPE_DELETION 
    #        && proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
    if self.organization.proposals.where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).any?
      errors.add(:base, I18n.t("activerecord.errors.messages.proposal_status_created_exists", status: "#{self.proposal_status.name}", organization: "#{self.organization.fullname_with_nip}" ) )
    else
      if self.register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_DELETION, 
          proposal_status_id: [ProposalStatus::PROPOSAL_STATUS_CREATED, ProposalStatus::PROPOSAL_STATUS_APPROVED]).any?
        errors.add(:base, I18n.t("activerecord.errors.messages.proposal_deletion_created_or_approved_exists"))
      else
        unless self.register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_REGISTRATION, 
            proposal_status_id: ProposalStatus::PROPOSAL_STATUS_APPROVED).any?
          errors.add(:base, I18n.t("activerecord.errors.messages.proposal_registration_approved_not_exists"))
        end
      end
    end
  end


  def fullname
    # "#{insertion_date.strftime("%Y-%m-%d")}"
    insertion_date.present? ? insertion_date.strftime("%Y-%m-%d") : ""
  end

  def fullname_was
    # "#{insertion_date_was.strftime("%Y-%m-%d")}"
    insertion_date_was.present? ? insertion_date_was.strftime("%Y-%m-%d") : ""
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end



  # Scope for select2: "proposal_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +scope+ -> collection 
  #
  scope :finder_proposal, ->(q) { where( create_sql_string("#{q}") ) }

  # Method create SQL query string for finder select2: "proposal_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +sql_string+ -> string for SQL WHERE... 
  #   Eg.: "((proposals.name ilike '%Jan%' OR proposals.email ilike '%Jan%') AND (proposals.name ilike '%ski@%' OR proposals.email ilike '%ski@%'))"
  #
  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  # Method for glue parameters in create_sql_string
  # * parameters   :
  #   * +one_query_word+ -> word for search. 
  #   Eg.: "Jan"
  # * result   :
  #   * +sql_string+ -> SQL string query for one word 
  #   Eg.: "(proposals.name ilike '%Jan%' OR proposals.email ilike '%Jan%')"
  #
  def self.one_param_sql(one_query_word)
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(proposals.name).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end

  def can_update?
    true
  end

  def can_delete?
    true
  end

  def can_approve?
    proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
  end

  def can_reject?
    proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
  end

  def can_annul?
    [ProposalStatus::PROPOSAL_STATUS_APPROVED, ProposalStatus::PROPOSAL_STATUS_REJECTED].include?(proposal_status_id)
    # proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
  end

  # def can_create_proposal_type_registration?
  #   organization_id
  # end

  # def can_create_proposal_type_deletion?
  #   true
  # end

  # def can_create_proposal_type_change?
  #   true
  # end

  # def can_create_proposal_type_certificate?
  #   true
  # end

  def save_and_change_register_status
    ActiveRecord::Base.transaction do
        if self.valid?
          case self.proposal_type_id 
          when ProposalType::PROPOSAL_TYPE_REGISTRATION
            self.update_status_when_proposal_type_registration
          when ProposalType::PROPOSAL_TYPE_CHANGE
            register = self.register
            register.update_status_when_proposal_type_change(self)
            add_errors(register) unless register.valid?
            register.save!
          when ProposalType::PROPOSAL_TYPE_DELETION
            register = self.register
            register.update_status_when_proposal_type_deletion(self)
            add_errors(register) unless register.valid?
            register.save!
          # when ProposalStatus::PROPOSAL_TYPE_CERTIFICATE
          end
        end
        self.save!
        true
      end
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.error('============== Proposal.save_and_change_register_status ========================')
      exception.record.errors.full_messages.each do |e|
        # puts "#{exception.record.class}: #{e}"
        Rails.logger.error("#{exception.record.class}: #{e}")
      end
      Rails.logger.error('================================================================================')

      # exception.record.errors.each do |att, mess|
      #   puts att # service_type
      #   puts mess # nie znajduje się na liście dopuszczalnych wartości
      # end

      # errors.add(:base, exception.message)
      # # throw :abort 
      false
  end

  def update_status_when_proposal_type_registration
    # always PROPOSAL_TYPE_REGISTRATION
    case self.proposal_status_id
    when ProposalStatus::PROPOSAL_STATUS_CREATED
      nil #self.register is nil
    when ProposalStatus::PROPOSAL_STATUS_APPROVED
      new_register = self.build_register(self.attributes.slice(*Register.attribute_names)
                        .merge(register_status_id: RegisterStatus::REGISTER_STATUS_CURRENT, id: nil, proposal_registration_approved_id: self.id, proposal_current_approved_id: self.id) )
                        # .merge(register_status_id: RegisterStatus::REGISTER_STATUS_CURRENT, id: nil, proposal_registration_approved_id: self.id, proposal_current_approved_id: nil) )
      add_errors(new_register) if new_register.invalid?
      new_register.save!
      self.register = new_register
    when ProposalStatus::PROPOSAL_STATUS_REJECTED
      nil #self.register is nil
    when ProposalStatus::PROPOSAL_STATUS_ANNULLED
      nil #self.register is nil CAN_ANNULED only PROPOSAL_STATUS_CREATED
      # self.register_status = RegisterStatus::REGISTER_STATUS_CURRENT      
    end
    
  end

  private

    def scheduled_date_end_after_start
      return if scheduled_end_date.blank? || scheduled_start_date.blank?     
      if scheduled_end_date < scheduled_start_date
        errors.add(:scheduled_end_date, I18n.t('errors.messages.greater_than_or_equal_to', count: scheduled_start_date.strftime('%Y-%m-%d')  ) ) 
        # errors.add(:scheduled_end_date, 'nie może być wcześniejsza "Początek"') 
        # throw :abort 
      end 
    end

    def approved_date_after_insertion_date
      return if approved_date.blank? || insertion_date.blank?     
      if approved_date < insertion_date
        errors.add(:approved_date, I18n.t('errors.messages.greater_than_or_equal_to', count: insertion_date.strftime('%Y-%m-%d')  ) ) 
      end 
    end

    def rejected_date_after_insertion_date
      return if rejected_date.blank? || insertion_date.blank?     
      if rejected_date < insertion_date
        errors.add(:rejected_date, I18n.t('errors.messages.greater_than_or_equal_to', count: insertion_date.strftime('%Y-%m-%d')  ) ) 
      end 
    end

    def annuled_date_after_insertion_date
      return if annuled_date.blank? || insertion_date.blank?     
      if annuled_date < insertion_date
        errors.add(:annuled_date, I18n.t('errors.messages.greater_than_or_equal_to', count: insertion_date.strftime('%Y-%m-%d')  ) ) 
      end 
    end

    def loofah_status_comment_present
      unless Loofah.fragment(status_comment).text.present?
        errors.add(:status_comment, :blank ) 
      end 
    end

    def network_type_or_service_type_presence
      network_is_empty = proposal_networks.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_network_type.ids.include?(x.network_type_id) }.empty?
      service_is_empty = proposal_services.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_service_type.ids.include?(x.service_type_id) }.empty?

      if network_is_empty && service_is_empty
        errors.add(:base, :network_type_and_network_service_blank)
      end      
    end

    def proposal_networks_network_type_presence
      if proposal_networks.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_network_type.ids.include?(x.network_type_id) }.empty?
        empty_key_names = FeatureType.only_network_type.pluck(:name).flatten
        errors.add(:base, :proposal_networks_network_type_blank, data: empty_key_names)
      end
    end

    def proposal_services_service_type_presence
      if proposal_services.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_service_type.ids.include?(x.service_type_id) }.empty?
        empty_key_names = FeatureType.only_service_type.pluck(:name).flatten
        errors.add(:base, :proposal_services_service_type_blank, data: empty_key_names)
      end
    end

    def proposal_proposal_areas_presence
      if proposal_areas.reject(&:marked_for_destruction?).empty?
        errors.add(:base, :proposal_proposal_areas_blank)
      end
    end

    def add_errors(model_in_transaction)
      model_in_transaction.errors.each do |attribute, message|
        errors.add("#{model_in_transaction.model_name.human}: #{model_in_transaction.class.human_attribute_name(attribute)}", "#{message}")
      end
    end

end
