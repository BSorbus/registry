class ProposalDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :proposal_path, :register_path, :organization_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:                   { source: "Proposal.id", cond: :eq, searchable: false, orderable: false },
      insertion_date:       { source: "Proposal.insertion_date", cond: :like, searchable: true, orderable: true },
      proposal_type:        { source: "ProposalType.name", cond: :like, searchable: true, orderable: true },
      proposal_status:      { source: "ProposalStatus.name", cond: :like, searchable: true, orderable: true },
      register:             { source: "Register.register_no", cond: :like, searchable: true, orderable: true },
      organization:         { source: "Organization.name", cond: :like, searchable: true, orderable: true },
      jointly_identifiers:  { source: "Organization.jointly_identifiers", cond: :like, searchable: true, orderable: true },
      jointly_addresses:    { source: "Organization.jointly_addresses", cond: :like, searchable: true, orderable: true },
      note:                 { source: "Proposal.note", cond: :like, searchable: true, orderable: true },
      # author:             { source: "User.user_name",  cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:                   record.id,
        insertion_date:       link_to( record.insertion_date.strftime("%Y-%m-%d"), proposal_path(record.service_type, record) ),
        proposal_type:        record.proposal_type.name,
        proposal_status:      record.proposal_status.name,
        register:             record.register_id.present? ? link_to( record.register.fullname, register_path(record.register.service_type, record.register) ) : '',
        organization:         link_to( record.organization.fullname, organization_path(record.organization) ),
        jointly_identifiers:  record.organization.jointly_identifiers.html_safe, 
        jointly_addresses:    record.organization.jointly_addresses.html_safe, 
        note:                 record.note_truncate,
        # author:         link_to( record.author.fullname, user_path(record.author_id) )
      }
    end
  end

  private

    def get_raw_records
      Proposal.joins(:proposal_type, :proposal_status, :organization).includes(:register)
        .references(:proposal_type, :proposal_status, :organization, :registr).where(service_type: params[:service_type]).all
    end

end
