class ProposalNetwork < ApplicationRecord
 
  # relations
  belongs_to :proposal
  belongs_to :network_type, class_name: "FeatureType", inverse_of: :proposal_network_type_network

  has_many :proposal_services, dependent: :destroy

  has_paper_trail versions: {
    class_name: 'ProposalNetworkVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :network_type, presence: true
  validates :proposal, presence: true

  validate :proposal_services_service_type_presence
  validate_nested_uniqueness_of :proposal_services, uniq_key: :service_type_id, scope: [:proposal_network], case_sensitive: false, error_key: :proposal_services_service_type_nested_taken

  # nested
  accepts_nested_attributes_for :proposal_services, reject_if: :all_blank, allow_destroy: true

  # callbacks


  private

    def proposal_services_service_type_presence
      if proposal_services.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_service_type.ids.include?(x.service_type_id) }.empty?
        empty_key_names = FeatureType.only_service_type.pluck(:name).flatten
        errors.add(:base, :proposal_services_service_type_blank, data: empty_key_names)
      end
    end

end
