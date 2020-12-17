class FeatureType < ApplicationRecord

  # relations
  # has_many :organizations
  # has_many :addresses
  # has_many :features
  # has_many :representatives
  has_many :legal_form_type_organizations, class_name: "Organization", foreign_key: "legal_form_type_id", inverse_of: :legal_form_type
  has_many :jst_legal_form_type_organizations, class_name: "Organization", foreign_key: "jst_legal_form_type_id", inverse_of: :jst_legal_form_type
  has_many :address_type_addresses, class_name: "Address", foreign_key: "address_type_id", inverse_of: :address_type
  has_many :feature_type_features, class_name: "Feature", foreign_key: "feature_type_id", inverse_of: :feature_type
  has_many :representative_type_representatives, class_name: "Representative", foreign_key: "representative_type_id", inverse_of: :representative_type
  has_many :proposal_network_type_network, class_name: "ProposalNetwork", foreign_key: "network_type_id", inverse_of: :network_type
  has_many :proposal_service_type_service, class_name: "ProposalService", foreign_key: "service_type_id", inverse_of: :service_type
  has_many :proposal_attachment_type_attachment, class_name: "ProposalAttachment", foreign_key: "attachment_type_id", inverse_of: :attachment_type



  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { scope: [:destiny], case_sensitive: false }

  validates :destiny, presence: true,
                    length: { in: 1..100 }

  validate :valid_regex, unless: -> { regexp_format_required.blank? }

  validates :format_example, format: { with: Proc.new { |a| Regexp.new(a.regexp_format_required) },
                                      message: ->(object, data) do
                                        I18n.t("errors.messages.invalid_regex_format", data: "#{object.regexp_format_required}", example: "#{object.format_example}" ) 
                                      end }, if: -> { regexp_format_required.present? && format_example.present? } 


  # scopes
  scope :only_legal_form_type,              -> { where(destiny: "legal_form_type") }
  scope :only_jst_legal_form_type,          -> { where(destiny: "jst_legal_form_type") }
  scope :only_identifier_type,              -> { where(destiny: "identifier_type") }
  scope :only_address_type,                 -> { where(destiny: "address_type") }
  scope :only_address_type_office,          -> { where(destiny: "address_type", name: "adres siedziby") }
  scope :only_address_type_correspondence,  -> { where(destiny: "address_type", name: "adres korespondencyjny") }
  scope :only_address_ext_type,             -> { where(destiny: "address_ext_type") }
  scope :only_address_ext_type_email,       -> { where(destiny: "address_ext_type", name: "e-mail") }
  scope :only_representative_type,          -> { where(destiny: "representative_type") }
  scope :only_network_type,                 -> { where(destiny: "network_type") }
  scope :only_service_type,                 -> { where(destiny: "service_type") }
  scope :only_attachment_type,              -> { where(destiny: "attachment_type") }

  private

    def valid_regex
      Regexp.new( "#{regexp_format_required}" )
    rescue RegexpError => e
      errors.add(:regexp_format_required, e.message)
    end

end
