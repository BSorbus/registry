class ProposalNetworkCandidate < ApplicationRecord
 
  # relations
  belongs_to :proposal_candidate, class_name: "ProposalCandidate", inverse_of: :proposal_networks
  belongs_to :network_type, class_name: "FeatureType", inverse_of: :proposal_network_candidate_type_networks

  # validates
  validates :network_type, presence: true
  validates :proposal_candidate, presence: true

  # callbacks


  private

end
