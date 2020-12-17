class Organization < ApplicationRecord
  include ActionView::Helpers::TextHelper

  PL_NIP_REGEXP = /\d{10}/

  delegate :url_helpers, to: 'Rails.application.routes'

  # relations
  belongs_to :author, class_name: "User"
  belongs_to :legal_form_type, class_name: "FeatureType", inverse_of: :legal_form_type_organizations
  belongs_to :jst_legal_form_type, class_name: "FeatureType", inverse_of: :jst_legal_form_type_organizations, optional: true

  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :features, as: :featurable, dependent: :destroy
  has_many :representatives, dependent: :destroy

  # only for Work.log
  has_many :feature_identifiers, -> { self.feature_only_identifier_type }, class_name: "Feature", as: :featurable
  has_many :feature_address_exts, -> { self.feature_only_address_ext_type }, class_name: "Feature", as: :featurable


  has_many :proposals, dependent: :restrict_with_error
  # has_many :proposals_j_services, -> { where(service_type: 'j') }, class_name: "Proposal", dependent: :restrict_with_error
  # has_many :proposals_p_services, -> { where(service_type: 'p') }, class_name: "Proposal", dependent: :restrict_with_error
  # has_many :proposals_t_services, -> { where(service_type: 't') }, class_name: "Proposal", dependent: :restrict_with_error

  has_many :registers, dependent: :restrict_with_error
  # has_many :registers_j_services, -> { where(service_type: 'j') }, class_name: "Register", dependent: :restrict_with_error
  # has_many :registers_p_services, -> { where(service_type: 'p') }, class_name: "Register", dependent: :restrict_with_error
  # has_many :registers_t_services, -> { where(service_type: 't') }, class_name: "Register", dependent: :restrict_with_error

  has_many :works, as: :trackable

  has_one :cbo_organization


  has_paper_trail versions: {
    class_name: 'OrganizationVersion'
    # scope: -> { order("id desc") }
  }
  
  # validates
  validates :name, presence: true,
                    length: { in: 1..150 },
                    uniqueness: { case_sensitive: false }

  # validates :tax_no, presence: true,
  #                    length: { in: 1..50 },
  #                    uniqueness: { case_sensitive: false }

  validates :legal_form_type, presence: true
  #validates :jst_legal_form_type, presence: true
  validates :jst_teryt, presence: true, length: { in: 1..20 }, if: -> { jst_legal_form_type.present? }

  validates :nip, format: { with: PL_NIP_REGEXP }, if: -> { nip.present? } 

  validate :features_identifier_type_presence
  validate :addresses_address_type_office_presence
  validate :features_address_ext_type_email_presence
  validate :representatives_representative_type_presence

  validate_nested_uniqueness_of :addresses, uniq_key: :address_type_id, scope: [:addressable], case_sensitive: false, error_key: :addresses_address_type_nested_taken
  validate_nested_uniqueness_of :features, uniq_key: :feature_type_id, scope: [:featurable], case_sensitive: false, error_key: :nested_taken

  # is OK
  # validates_uniqueness :organization_features, { attribute: :worth_type_id, case_sensitive: false, message: "User's name should be unique per company" }
  # validates_uniqueness :organization_features, { attribute: :worth_type_id }
 


  # callbacks
  before_save :set_from_children
  # before_destroy :has_important_links, prepend: true

  # nested
  accepts_nested_attributes_for :representatives, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :features, reject_if: :all_blank, allow_destroy: true


  def log_work(action = '', action_user_id = nil)
    worker_id = action_user_id || self.author_id
    url = "<a href=#{url_helpers.organization_path(self.id, locale: :pl)}>#{self.fullname}</a>".html_safe


    # organization_str = self.to_json( except: [:author_id] )
    # organization_hash = JSON.parse(organization_str)

    # addresses_str = self.addresses.to_json( except: [:address_type_id],
    #                                         include: {address_type: {only: [:id, :name]} }, 
    #                                         root: 'addresses' )
    # addresses_hash = JSON.parse(addresses_str)


    # author_str = self.author.to_json( only: [:id, :user_name, :email], root: 'author' )
    # author_hash = JSON.parse(author_str)


    # organization_with_other_hash = organization_hash.merge(addresses_hash) zle Hash[* addresses_hash.map(&:values).flatten]
    # organization_with_other_json = organization_with_other_hash.to_json 


    Work.create!(trackable_type: 'Organization', trackable_id: self.id, action: "#{action}", author_id: worker_id, url: "#{url}", 
      # parameters: organization_with_other_json )
      parameters: self.to_json( except: [:author_id, :legal_form_type_id, :jointly_identifiers, :jointly_addresses_ext, :jointly_addresses], 
                                include: {
                                  legal_form_type: {
                                    only: [:id, :name]
                                  },
                                  feature_identifiers: {
                                    only: [:id, :feature_value, :created_at, :updated_at], 
                                    include: {feature_type: {only: [:id, :name]}}
                                  }, 
                                  feature_address_exts: {
                                    only: [:id, :feature_value, :created_at, :updated_at], 
                                    include: {feature_type: {only: [:id, :name]}}
                                  }, 
                                  addresses: {
                                    except: [:address_type_id, :addressable_type, :addressable_id], 
                                    include: {address_type: {only: [:id, :name]}} 
                                  }, 
                                  representatives: {
                                    only: [:id, :first_name, :last_name], 
                                    include: {
                                      representative_type: {only: [:id, :name]},  
                                      feature_address_exts: {
                                        only: [:id, :feature_value, :created_at, :updated_at], 
                                        include: {feature_type: {only: [:id, :name]}}
                                      },
                                      addresses: {
                                        except: [:address_type_id, :addressable_type, :addressable_id], 
                                        include: {address_type: {only: [:id, :name]}} 
                                      } 
                                    }
                                  }, 
                                  author: {
                                    only: [:id, :user_name, :email]
                                  }                 
                                }
                              )
                )
  end


  def fullname
    truncate(Loofah.fragment(self.name).text, length: 100)
  end

  def fullname_with_nip
    fullname + "  [ NIP: #{nip}]"
  end

  def short_name_truncate
    "#{truncate(self.name, length: 30)}"
  end

  def fullname_was
    "#{name_was}"
  end

  def name_as_link
    "<a href=#{url_helpers.organization_path(self)}>#{self.name}</a>".html_safe
  end

  def name_as_link_truncate
    "<a href=#{url_helpers.organization_path(self)}>#{truncate(self.name, length: 100)}</a>".html_safe
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end


  ##
  # Scope for select2: "organization_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +scope+ -> collection 
  #
  scope :finder_organization, ->(q) { where( create_sql_string("#{q}") ) }

  ##
  # Method create SQL query string for finder select2: "organization_select"
  # * parameters   :
  #   * +query_str+ -> string for search. 
  #   Eg.: "Jan ski@"
  # * result   :
  #   * +sql_string+ -> string for SQL WHERE... 
  #   Eg.: "((users.name ilike '%Jan%' OR users.email ilike '%Jan%') AND (organizations.name ilike '%ski@%' OR organizations.email ilike '%ski@%'))"
  #
  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  ##
  # Method for glue parameters in create_sql_string
  # * parameters   :
  #   * +one_query_word+ -> word for search. 
  #   Eg.: "Jan"
  # * result   :
  #   * +sql_string+ -> SQL string query for one word 
  #   Eg.: "(organizations.name ilike '%Jan%' OR organizations.email ilike '%Jan%')"
  #
  def self.one_param_sql(one_query_word)
    #escaped_query_str = sanitize("%#{query_str}%")
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + %w(organizations.name organizations.nip organizations.jointly_identifiers organizations.jointly_addresses organizations.jointly_addresses_ext).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end

  private

    def set_from_children
      set_jointly_identifiers
      set_jointly_addresses_ext      
      set_jointly_addresses
    end

    def set_jointly_identifiers
      self.jointly_identifiers = ""
      features.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_identifier_type.ids.include?(x.feature_type_id) }.each do |rec|
        self.jointly_identifiers += "<strong>#{rec.feature_type.name.upcase}</strong>:<br>#{rec.feature_value}<br>"
      end
      self.jointly_identifiers = self.jointly_identifiers[0...-4] # remove ", "
    end

    def set_jointly_addresses_ext
      self.jointly_addresses_ext = ""
      features.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_address_ext_type.ids.include?(x.feature_type_id) }.each do |rec|
        self.jointly_addresses_ext += "#{rec.feature_value}<br>"
      end
      self.jointly_addresses_ext = self.jointly_addresses_ext[0...-4] # remove ", "
    end

    def set_jointly_addresses
      self.jointly_addresses = ""
      addresses.reject(&:marked_for_destruction?).each do |rec|
        self.jointly_addresses += "<strong>#{rec.address_type.name.upcase}</strong>:<br>" + "#{rec.country_code}, " + 
                                  "#{rec.city_name}" + 
                                  "#{rec.street_name.blank? ? ", " : ", #{rec.street_name}, "}" + 
                                  "#{rec.address_house}" + 
                                  "#{rec.address_number.blank? ? ", " : ", #{rec.address_number}, "}" + 
                                  "#{rec.address_postal_code}, " 
        self.jointly_addresses = self.jointly_addresses[0...-2] + "<br>"
      end
      self.jointly_addresses = self.jointly_addresses[0...-4]
    end

    def features_identifier_type_presence
      if nip.present?
        return
      else
        if features.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_identifier_type.ids.include?(x.feature_type_id) }.empty?
          empty_key_names = FeatureType.only_identifier_type.pluck(:name).flatten
          # errors.add(:base, :features_identifier_type_blank)
          errors.add(:base, :features_identifier_type_blank, data: empty_key_names)
          # throw :abort 
        end
      end
    end

    def features_address_ext_type_email_presence
      if features.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_address_ext_type_email.ids.include?(x.feature_type_id) }.empty?
        empty_key_names = FeatureType.only_address_ext_type_email.pluck(:name).flatten
        errors.add(:base, :features_address_ext_type_email_blank, data: empty_key_names)
      end
    end

    def addresses_address_type_office_presence
      if addresses.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_address_type_office.ids.include?(x.address_type_id) }.empty?
        empty_key_names = FeatureType.only_address_type_office.pluck(:name).flatten
        errors.add(:base, :addresses_address_type_office_blank, data: empty_key_names)
      end
    end

    def representatives_representative_type_presence
      if representatives.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_representative_type.ids.include?(x.representative_type_id) }.empty?
        empty_key_names = FeatureType.only_representative_type.pluck(:name).flatten
        errors.add(:base, :representatives_representative_type_blank, data: empty_key_names)
      end
    end

end
