class ProposalType < ActiveRecord::Base

  PROPOSAL_TYPE_REGISTRATION = 1
  PROPOSAL_TYPE_CHANGE = 2
  PROPOSAL_TYPE_DELETION = 3
  PROPOSAL_TYPE_CERTIFICATE = 4

  PROPOSAL_TYPES = [ PROPOSAL_TYPE_REGISTRATION,
                     PROPOSAL_TYPE_CHANGE,
                     PROPOSAL_TYPE_DELETION,
                     PROPOSAL_TYPE_CERTIFICATE ]

  PROPOSAL_TYPES_VALID_PROPOSAL_NETWORK = [ PROPOSAL_TYPE_REGISTRATION,
                                            PROPOSAL_TYPE_CHANGE ]

  PROPOSAL_TYPES_VALID_PROPOSAL_SERVICE = [ PROPOSAL_TYPE_REGISTRATION,
                                            PROPOSAL_TYPE_CHANGE ]

  PROPOSAL_TYPES_ENABLED_REGISTER_ID = [ PROPOSAL_TYPE_CHANGE,
                                                 PROPOSAL_TYPE_DELETION,
                                                 PROPOSAL_TYPE_CERTIFICATE ]

  # relations
  has_many :proposals, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

end
