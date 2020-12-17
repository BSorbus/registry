class ProposalAttachment < ApplicationRecord
 
  # relations
  belongs_to :proposal
  belongs_to :attachment_type, class_name: "FeatureType", inverse_of: :proposal_attachment_type_attachment

  # has_paper_trail versions: {
  #   class_name: 'ProposalAttachmentVersion'
  #   # scope: -> { order("id desc") }
  # }

  has_one_attached :attached_pdf_file

  # validates
  validates :attachment_type, presence: true
  validates :proposal, presence: true

  # callbacks


  private

end
