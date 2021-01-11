class Register < ApplicationRecord
  include ActionView::Helpers::TextHelper

  # relations
  belongs_to :author, class_name: "User", foreign_key: :author_id
  belongs_to :register_status
  belongs_to :organization
  has_many :proposals, dependent: :restrict_with_error

  belongs_to :proposal_registration_approved, class_name: "Proposal", foreign_key: :proposal_registration_approved_id, inverse_of: :register_registration_approved, optional: true
  belongs_to :proposal_current_approved, class_name: "Proposal", foreign_key: :proposal_current_approved_id, inverse_of: :register_current_approved, optional: true
  belongs_to :proposal_deletion_approved, class_name: "Proposal", foreign_key: :proposal_deletion_approved_id, inverse_of: :register_deletion_approved, optional: true


  has_paper_trail versions: {
    # class_name: 'RegisterVersion'
    # scope: -> { order("id desc") }
  } #, meta: {author_id: :author_id}

  # validates
  validates :service_type, presence: true, inclusion: { in: ['j', 'p', 't'] }
  validates :author, presence: true
  validates :organization, presence: true
  validates :register_status_id, presence: true, inclusion: { in: RegisterStatus::REGISTER_STATUSES }
  validates :register_status, presence: true
  validates :register_no, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :register_status_id,
    uniqueness: { scope: [:service_type, :organization_id], 
                  message: ->(object, data) do
                    I18n.t("activerecord.errors.messages.register_status_taken", register_status_name: "[RS] #{object.register_status.name}" )
                  end }, if: -> { RegisterStatus::REGISTER_STATUSES_VALID_UNIQUENESS.include?(register_status_id) }

  # callbacks
  before_validation :set_initial_data

  def fullname
    "#{register_no}"
  end

  def fullname_was
    "#{register_no_was}"
  end

  def note_truncate
    truncate(Loofah.fragment(self.note).text, length: 100)
  end

  # def flat_proposals_with_type_and_status
  #   self.proposals.order(:insertion_date).flat_map {|row| "<div class='col-sm-4'>#{row.insertion_date.strftime("%Y-%m-%d")}</div>  <div class='col-sm-4'>#{row.proposal_type.name}</div> <div class='col-sm-4'>#{row.proposal_status.name}</div>" }.join('').html_safe
  # end

  scope :finder_register, ->(q) { where( create_sql_string("#{q}") ) }

  def self.create_sql_string(query_str)
    query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
  end

  def self.one_param_sql(one_query_word)
    escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
    "(" + ["to_char(registers.register_no,'99999')", "to_char(proposals.approved_date::timestamptz,'YYYY-MM-DD TZ')", "organizations.name", "organizations.nip"].map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
  end





  def update_status_when_proposal_type_change(proposal)
    # always PROPOSAL_TYPE_CHANGE = 2

    case proposal.proposal_status_id
    when ProposalStatus::PROPOSAL_STATUS_CREATED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_PENDING_CHANGES
    when ProposalStatus::PROPOSAL_STATUS_APPROVED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_CURRENT
      self.proposal_current_approved_id = proposal.id
    when ProposalStatus::PROPOSAL_STATUS_REJECTED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_CURRENT
      # przywroc poprzedni self.proposal_current_approved_id
    when ProposalStatus::PROPOSAL_STATUS_ANNULLED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_CURRENT
      # przywroc poprzedni self.proposal_current_approved_id
    end
    self.author = proposal.author
  end

  def update_status_when_proposal_type_deletion(proposal)
    # always PROPOSAL_TYPE_DELETION = 3

    case proposal.proposal_status_id
    when ProposalStatus::PROPOSAL_STATUS_CREATED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_PENDING_DELETION
    when ProposalStatus::PROPOSAL_STATUS_APPROVED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_OLD_ENTRY
      self.proposal_deletion_approved_id = proposal.id
    when ProposalStatus::PROPOSAL_STATUS_REJECTED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_CURRENT
      self.proposal_deletion_approved_id = nil
    when ProposalStatus::PROPOSAL_STATUS_ANNULLED
      self.register_status_id = RegisterStatus::REGISTER_STATUS_CURRENT
      self.proposal_deletion_approved_id = nil
    end
    self.author = proposal.author
  end

  private
  
    def set_initial_data
      if new_record?
        max_val = Register.where(service_type: self.service_type)
                          .where.not(register_status: RegisterStatus::REGISTER_STATUS_ANNULLED)
                            .maximum(:register_no) || 0
        self.register_no = max_val + 1
      end
    end   

end
