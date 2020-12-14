class RegisterStatus < ActiveRecord::Base

  REGISTER_STATUS_CURRENT = 1
  REGISTER_STATUS_PENDING_CHANGES = 2
  REGISTER_STATUS_PENDING_DELETION = 3
  REGISTER_STATUS_OLD_ENTRY = 4
  REGISTER_STATUS_ANNULLED = 5

  REGISTER_STATUSES = [ REGISTER_STATUS_CURRENT, 
                        REGISTER_STATUS_PENDING_CHANGES, 
                        REGISTER_STATUS_PENDING_DELETION, 
                        REGISTER_STATUS_OLD_ENTRY, 
                        REGISTER_STATUS_ANNULLED ]

  REGISTER_STATUSES_VALID_UNIQUENESS = [ REGISTER_STATUS_CURRENT,
                                         REGISTER_STATUS_PENDING_CHANGES,
                                         REGISTER_STATUS_PENDING_DELETION ]

  REGISTER_STATUSES_WITH_COMMENT = [ REGISTER_STATUS_ANNULLED ]


  REGISTER_IMPORTANT_STATUSES = [ REGISTER_STATUS_CURRENT,
                                  REGISTER_STATUS_PENDING_CHANGES, 
                                  REGISTER_STATUS_PENDING_DELETION ]

  # relations
  has_many :registers, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

  # scope
#  scope :status_can_change, -> { where(id: [REGISTER_STATUS_CREATED, REGISTER_STATUS_APPROVED, REGISTER_STATUS_REJECTED]) }

end
