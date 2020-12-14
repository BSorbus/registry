class ProposalService < ApplicationRecord
 
  # relations
  belongs_to :proposal
  belongs_to :service_type, class_name: "FeatureType", inverse_of: :proposal_service_type_service

  has_paper_trail versions: {
    class_name: 'ProposalServiceVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :service_type, presence: true
  validates :proposal, presence: true

  # callbacks


  private

end
