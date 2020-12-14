class ProposalNetwork < ApplicationRecord
 
  # relations
  belongs_to :proposal
  belongs_to :network_type, class_name: "FeatureType", inverse_of: :proposal_network_type_network

  has_paper_trail versions: {
    class_name: 'ProposalNetworkVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :network_type, presence: true
  validates :proposal, presence: true

  # callbacks


  private

end
