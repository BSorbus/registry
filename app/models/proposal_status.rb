class ProposalStatus < ActiveRecord::Base

  PROPOSAL_STATUS_CREATED = 1
  PROPOSAL_STATUS_APPROVED = 2
  PROPOSAL_STATUS_REJECTED = 3
  PROPOSAL_STATUS_CLOSED = 4
  PROPOSAL_STATUS_ANNULLED = 5

  PROPOSAL_STATUSES = [ PROPOSAL_STATUS_CREATED, 
                        PROPOSAL_STATUS_APPROVED, 
                        PROPOSAL_STATUS_REJECTED, 
                        PROPOSAL_STATUS_CLOSED, 
                        PROPOSAL_STATUS_ANNULLED ]

  PROPOSAL_STATUSES_WITH_COMMENT = [ PROPOSAL_STATUS_REJECTED, 
                                     PROPOSAL_STATUS_CLOSED ]


  PROPOSAL_IMPORTANT_STATUSES = [ PROPOSAL_STATUS_CREATED, 
                                  PROPOSAL_STATUS_APPROVED ]

  # relations
  has_many :proposals, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

  # scope
  scope :status_can_change, -> { where(id: [PROPOSAL_STATUS_CREATED, PROPOSAL_STATUS_APPROVED, PROPOSAL_STATUS_REJECTED]) }

end
