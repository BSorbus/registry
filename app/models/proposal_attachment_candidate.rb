class ProposalAttachmentCandidate < ApplicationRecord
 
  # relations
  belongs_to :proposal_candidate, class_name: "ProposalCandidate", inverse_of: :proposal_attachments
  belongs_to :attachment_type, class_name: "FeatureType", inverse_of: :proposal_attachment_candidate_type_attachments

  has_one_attached :attached_pdf_file, dependent: false

  # validates
  validates :attachment_type, presence: true
  validates :proposal_candidate, presence: true

  # callbacks


  private

end
