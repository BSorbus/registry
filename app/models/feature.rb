class Feature < ApplicationRecord

  # relations
  belongs_to :featurable, polymorphic: true
  belongs_to :feature_type, class_name: "FeatureType", inverse_of: :feature_type_features


  has_paper_trail versions: {
    # class_name: 'FeatureVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :feature_type, presence: true
  validates :feature_value, presence: true,
                    length: { in: 1..100 }
                    # uniqueness: { scope: [:feature_type], case_sensitive: false }
                    # uniqueness: { scope: [:featurable, :feature_type], case_sensitive: false }

  validates :feature_value, format: { with: Proc.new { |a| Regexp.new(a.feature_type.regexp_format_required) },
                                      message: ->(object, data) do
                                        I18n.t("errors.messages.invalid_regex_format", data: "#{object.feature_type.regexp_format_required}", example: "#{object.feature_type.format_example}" ) 
                                      end }, if: -> { feature_type.regexp_format_required.present? } 
  # same as:
  # validates_format_of :feature_value, with: EMAIL_REGEXP, if: -> { feature_type.name == "e-mail" }



  #                 message: ->(object, data) do
  #                   I18n.t("activerecord.errors.messages.proposal_status_taken", proposal_status_name: "#{object.proposal_status.name}", proposal_type_name: "#{object.proposal_type.name}" )
  #                 end }, if: -> { proposal_status_id == ProposalStatus::PROPOSAL_STATUS_CREATED }


  # validates :feature_value, presence: { message: ->(object, data) do
  #                                         "'#{object.class}', '#{object}' "
  #                                       end }

  # callbacks
  def self.feature_only_identifier_type
    # eager_load(:feature_type).where( feature_types: {destiny: "identifier_type"} )  
    eager_load(:feature_type).merge(FeatureType.only_identifier_type)
  end

  def self.feature_only_address_ext_type
    eager_load(:feature_type).merge(FeatureType.only_address_ext_type)
  end

  def self.feature_only_network_type
    eager_load(:feature_type).merge(FeatureType.only_network_type)
  end

end
