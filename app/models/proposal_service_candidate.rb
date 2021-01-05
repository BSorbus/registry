class ProposalServiceCandidate < ApplicationRecord
 
  # relations
  belongs_to :proposal_candidate, class_name: "ProposalCandidate", inverse_of: :proposal_services
  belongs_to :service_type, class_name: "FeatureType", inverse_of: :proposal_service_candidate_type_services

  # validates
  validates :service_type, presence: true
  validates :proposal_candidate, presence: true

  # callbacks


  private

end
