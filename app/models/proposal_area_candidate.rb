class ProposalAreaCandidate < ApplicationRecord
 
  # relations
  belongs_to :proposal_candidate, class_name: "ProposalCandidate", inverse_of: :proposal_areas

  # validates
  validates :proposal_candidate, presence: true
  # validates :province_code, presence: true,
  #                   length: { in: 1..20 }
  # validates :province_name, presence: true,
  #                   length: { in: 1..50 }

  # callbacks


  private

end
