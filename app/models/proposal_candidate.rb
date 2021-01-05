class ProposalCandidate < ApplicationRecord
  extend ActiveModel::Translation
  include ActionView::Helpers::TextHelper

  cattr_accessor :form_steps do
    %w(step1 step2 step3 step4 step5 step6)
  end

  attr_accessor :form_step

  # relations
  belongs_to :proposal, optional: true
  belongs_to :author, class_name: "User", foreign_key: :author_id
  belongs_to :proposal_type
  belongs_to :proposal_status
  belongs_to :organization, optional: true
  belongs_to :register, optional: true

  has_many :proposal_networks, dependent: :destroy, class_name: "ProposalNetworkCandidate", foreign_key: :proposal_candidate_id
  has_many :proposal_services, dependent: :destroy, class_name: "ProposalServiceCandidate", foreign_key: :proposal_candidate_id
  has_many :proposal_areas, dependent: :destroy, class_name: "ProposalAreaCandidate", foreign_key: :proposal_candidate_id
  has_many :proposal_attachments, dependent: :destroy, class_name: "ProposalAttachmentCandidate", foreign_key: :proposal_candidate_id

  # nested
  accepts_nested_attributes_for :proposal_networks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :proposal_services, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :proposal_areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :proposal_attachments, reject_if: :all_blank, allow_destroy: true

  # validates
  # proposal_type, proposal_status, author presence: true always because defined 'belongs_to'
  # always validate:
  validates :service_type, presence: true, inclusion: { in: ['j', 'p', 't'] }
  validates :insertion_date, presence: true
  # step2 - dotyczy:
  validates :organization, presence: true, 
    if: -> { required_for_step?(:step2) && (proposal_type_id == ProposalType::PROPOSAL_TYPE_REGISTRATION) }

  validates :register, presence: true, 
    if: -> { required_for_step?(:step2) && (proposal_type_id != ProposalType::PROPOSAL_TYPE_REGISTRATION) }

  validate :candidate_can_as_registration, 
    if: -> { required_for_step?(:step2) && (proposal_type_id == ProposalType::PROPOSAL_TYPE_REGISTRATION) && organization_id.present? }

  validate :candidate_can_as_change, 
    if: -> { required_for_step?(:step2) && (proposal_type_id == ProposalType::PROPOSAL_TYPE_CHANGE) && organization_id.present? && register_id.present? }

  validate :candidate_can_as_deletion, 
    if: -> { required_for_step?(:step2) && (proposal_type_id == ProposalType::PROPOSAL_TYPE_DELETION) && organization_id.present? && register_id.present? }

  # step3 - działalność:
  validate :insertion_date_after_resolution,
    if: -> { required_for_step?(:step3) && (service_type == 'j') }

  validates :jst_date_of_adopting_the_resolution_date, presence: true, 
    if: -> { required_for_step?(:step3) && (service_type == 'j') }

  validates :jst_resolution_number, presence: true, length: { in: 1..200 }, 
    if: -> { required_for_step?(:step3) && (service_type == 'j') }

  validate :network_type_or_service_type_presence, 
    if: -> { required_for_step?(:step3) && (service_type == 't') && ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }

  validate_nested_uniqueness_of :proposal_networks, uniq_key: :network_type_id, scope: [:proposal_candidate], 
                                  case_sensitive: false, error_key: :proposal_networks_network_type_nested_taken, 
    if: -> { required_for_step?(:step3) && (service_type == 't') && ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }

  validate_nested_uniqueness_of :proposal_services, uniq_key: :service_type_id, scope: [:proposal_candidate], 
                                  case_sensitive: false, error_key: :proposal_services_service_type_nested_taken,
    if: -> { required_for_step?(:step3) && (service_type == 't') && ProposalType::PROPOSAL_TYPES_PRESENCE_NETWORK_OR_SERVICE.include?(proposal_type_id) }

  # step4 - obszar
  validate :proposal_proposal_areas_presence, 
    if: -> { required_for_step?(:step4) && (activity_area_whole_poland == false) }

  validate_nested_uniqueness_of :proposal_areas, uniq_key: :proposal_candidate_id, scope: [:province_code, :district_code, :commune_code], 
                                  case_sensitive: false, error_key: :proposal_areas_proposal_codes_nested_taken, 
    if: -> { required_for_step?(:step4) && (activity_area_whole_poland == false) }

  # step5 - załączniki
  # step6 - podsumowanie
  validate :scheduled_date_end_after_start,
    if: -> { required_for_step?(:step6) }

  validates :scheduled_start_date, presence: true,
   if: -> { required_for_step?(:step6) }

  validates :scheduled_end_date, presence: true, 
    if: -> { required_for_step?(:step6) && (proposal_type_id == ProposalType::PROPOSAL_TYPE_DELETION) }



  def required_for_step?(step)
    return true if form_step.nil?
    return true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end

  def candidate_can_as_registration
    # always if proposal_type_id == ProposalType::PROPOSAL_TYPE_REGISTRATION 
    #        && proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
    # if self.organization.proposals.where.not(id: self.proposal_id).where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).reject(self.proposal).any?
    if self.organization.proposals.where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).reject{ |x| self.proposal_id == x.id }.any?
      errors.add(:base, I18n.t("activerecord.errors.messages.proposal_status_created_exists", status: "#{self.proposal_status.name}" ) )
    else
      registers = self.organization.registers.where(service_type: self.service_type)
      unless registers.empty?
        register = registers.order(:created_at).last unless registers.empty?
        if register.register_status_id == RegisterStatus::REGISTER_STATUS_CURRENT
          errors.add(:base, I18n.t("activerecord.errors.messages.register_current_exists"))
        end
      end
    end
  end

  def candidate_can_as_change
    # always if proposal_type_id == ProposalType::PROPOSAL_TYPE_CHANGE 
    #        && proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
    if self.organization.proposals.where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).any?
      errors.add(:base, I18n.t("activerecord.errors.messages.proposal_status_created_exists", status: "#{self.proposal_status.name}"))
    else
      if register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_DELETION, 
          proposal_status_id: [ProposalStatus::PROPOSAL_STATUS_CREATED, ProposalStatus::PROPOSAL_STATUS_APPROVED]).any?
        errors.add(:base, I18n.t("activerecord.errors.messages.proposal_deletion_created_or_approved_exists"))
      else
        unless register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_REGISTRATION, 
            proposal_status_id: ProposalStatus::PROPOSAL_STATUS_APPROVED).any?
          errors.add(:base, I18n.t("activerecord.errors.messages.proposal_registration_approved_not_exists"))
        end
      end
    end
  end

  def candidate_can_as_deletion
    # always if proposal_type_id == ProposalType::PROPOSAL_TYPE_DELETION 
    #        && proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED
    if self.organization.proposals.where(service_type: self.service_type, proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED).any?
      errors.add(:base, I18n.t("activerecord.errors.messages.proposal_status_created_exists", status: "#{self.proposal_status.name}" ) )
    else
      if register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_DELETION, 
          proposal_status_id: [ProposalStatus::PROPOSAL_STATUS_CREATED, ProposalStatus::PROPOSAL_STATUS_APPROVED]).any?
        errors.add(:base, I18n.t("activerecord.errors.messages.proposal_deletion_created_or_approved_exists"))
      else
        unless register.proposals.where(proposal_type_id: ProposalType::PROPOSAL_TYPE_REGISTRATION, 
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

  def set_last_step_and_create_proposal(last_step_params)
    ActiveRecord::Base.transaction do
        self.assign_attributes(last_step_params)
        if self.valid?


          proposal_hash = self.serializable_hash_with_nested
          proposal_hash = proposal_hash.deep_transform_keys{ |k| k.to_s == 'proposal_networks' ? 'proposal_networks_attributes' : k }
          proposal_hash = proposal_hash.deep_transform_keys{ |k| k.to_s == 'proposal_services' ? 'proposal_services_attributes' : k }
          proposal_hash = proposal_hash.deep_transform_keys{ |k| k.to_s == 'proposal_areas' ? 'proposal_areas_attributes' : k }

      Rails.logger.error('================================================================================')
      puts proposal_hash
      Rails.logger.error('================================================================================')


          proposal = Proposal.new( proposal_hash )
          self.proposal = proposal
          add_errors(proposal) unless proposal.valid?
          proposal.save!
        end
        self.save!
        true
      end
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.error('============== ProposalCandidate.set_last_step_and_create_proposal =============')
      exception.record.errors.full_messages.each do |e|
        # puts "#{exception.record.class}: #{e}"
        Rails.logger.error("#{exception.record.class}: #{e}")
      end
      Rails.logger.error('================================================================================')
      false
  end

  def serializable_hash_with_nested
    case self.service_type
    when 'j'
      # serializable_hash(  except: [ :id, :updated_at ],
      #                     include: {
      #                       proposal_attachments: {}
      #                     }
      #                   )
      serializable_hash(except: [ :id, :updated_at, :wizard_saved_step, :proposal_id ]
                        )
    when 'p'
      serializable_hash(  except: [ :id, :updated_at, :wizard_saved_step, :proposal_id ],
                          include: {
                            proposal_attachments: {}
                          }
                        )      
    when 't'
      networks_hash = serializable_hash(only: [], include: {proposal_networks: { except: [:id, :proposal_candidate_id, :created_at, :updated_at] } })
      services_hash = serializable_hash(only: [], include: {proposal_services: { except: [:id, :proposal_candidate_id, :created_at, :updated_at] } })
      areas_hash    = serializable_hash(only: [], include: {proposal_areas: { except: [:id, :proposal_candidate_id, :created_at, :updated_at] } })

      candidate_hash = serializable_hash(except: [ :id, :created_at, :updated_at, :wizard_saved_step, :proposal_id ]) 
      # serializable_hash(  except: [ :id, :updated_at, :wizard_saved_step, :proposal_id,
      #                               :jst_providing_networks, 
      #                               :jst_provision_telecom_services,
      #                               :jst_provision_related_services,
      #                               :jst_other_telecom_activities,
      #                               :jst_date_of_adopting_the_resolution_date,
      #                               :jst_resolution_number ],
      #                     include: {
      #                       proposal_networks: { except: [:id, :proposal_candidate_id] }, 
      #                       proposal_services: { except: [:id, :proposal_candidate_id] }, 
      #                       proposal_areas: { except: [:id, :proposal_candidate_id] } #,                             proposal_attachments: { except: [:id] }
      #                     }
      #                   )

      candidate_hash.merge(networks_hash).merge(services_hash).merge(areas_hash)
    end
  end


  private
    def insertion_date_after_resolution
      return if insertion_date.blank? || jst_date_of_adopting_the_resolution_date.blank?     
      if insertion_date < jst_date_of_adopting_the_resolution_date
        errors.add(:jst_date_of_adopting_the_resolution_date, I18n.t('errors.messages.less_than_or_equal_to', count: insertion_date.strftime('%Y-%m-%d')  ) ) 
      end 
    end

    def scheduled_date_end_after_start
      return if scheduled_end_date.blank? || scheduled_start_date.blank?     
      if scheduled_end_date < scheduled_start_date
        errors.add(:scheduled_end_date, I18n.t('errors.messages.greater_than_or_equal_to', count: scheduled_start_date.strftime('%Y-%m-%d')  ) ) 
        # errors.add(:scheduled_end_date, 'nie może być wcześniejsza "Początek"') 
        # throw :abort 
      end 
    end

    def network_type_or_service_type_presence
      network_is_empty = proposal_networks.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_network_type.ids.include?(x.network_type_id) }.empty?
      service_is_empty = proposal_services.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_service_type.ids.include?(x.service_type_id) }.empty?

      if network_is_empty && service_is_empty
        errors.add(:base, :network_type_and_network_service_blank)
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
