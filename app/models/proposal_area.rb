class ProposalArea < ApplicationRecord
 
  # relations
  belongs_to :proposal


  has_paper_trail versions: {
    # class_name: 'ProposalAreaVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :proposal, presence: true
  # validates :province_code, presence: true,
  #                   length: { in: 1..20 }
  # validates :province_name, presence: true,
  #                   length: { in: 1..50 }

  # callbacks


  private

end
