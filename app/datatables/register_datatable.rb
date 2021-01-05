class RegisterDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :register_path, :proposal_path, :organization_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:                                   { source: "Register.id", cond: :eq, searchable: false, orderable: false },
      register_no:                          { source: "Register.register_no", cond: :like, searchable: true, orderable: true },
      register_status:                      { source: "RegisterStatus.name", cond: :like, searchable: true, orderable: true },
      registration_approved_insertion_date: { source: "Proposal.insertion_date", cond: :like, searchable: true, orderable: true },
      current_approved_insertion_date:      { source: "t4_r3", cond: filter_current_approved_insertion_date, searchable: true, orderable: true },
      deletion_approved_insertion_date:     { source: "t5_r3", cond: filter_deletion_approved_insertion_date, searchable: true, orderable: true },
      organization:                         { source: "Organization.name", cond: :like, searchable: true, orderable: true },
      nip:                                  { source: "Organization.nip", cond: :like, searchable: true, orderable: true },
      jointly_identifiers:                  { source: "Organization.jointly_identifiers", cond: :like, searchable: true, orderable: true },
      jointly_addresses:                    { source: "Organization.jointly_addresses", cond: :like, searchable: true, orderable: true }
#      flat:                 { source: "Register.id", cond: filter_custom_column_condition }
    }
  end

  def data
    records.map do |record|
      {
        id:                                   record.id,
        register_no:                          link_to( record.fullname, register_path(record.service_type, record) ),
        register_status:                      record.register_status.name,
        registration_approved_insertion_date: link_registration_approved(record),
        current_approved_insertion_date:      link_current_approved(record),
        deletion_approved_insertion_date:     link_deletion_approved(record),
        organization:                         link_to( record.organization.fullname, organization_path(record.organization) ),
        nip:                                  record.organization.nip, 
        jointly_identifiers:                  record.organization.jointly_identifiers.html_safe, 
        jointly_addresses:                    record.organization.jointly_addresses.html_safe
#        flat:                    record.flat_proposals_with_type_and_status
      }
    end
  end

  private

    def get_raw_records
      Register.includes(:organization, :register_status, :proposal_registration_approved, :proposal_current_approved, :proposal_deletion_approved)
        .references(:organization, :register_status, :proposal_registration_approved, :proposal_current_approved, :proposal_deletion_approved)
        .where(service_type: params[:service_type])
        .distinct
    end

    def link_registration_approved(rec)
      rec.proposal_registration_approved.present? ? link_to( rec.proposal_registration_approved.fullname, proposal_path( rec.proposal_registration_approved.service_type, rec.proposal_registration_approved) ) : ""
      # link_to(' ', @view.edit_attachment_path(rec.id), class: 'fa fa-edit', remote: true, title: "Edycja", rel: 'tooltip')
    end

    def link_current_approved(rec)
      rec.proposal_current_approved.present? ? link_to( rec.proposal_current_approved.fullname, proposal_path( rec.proposal_current_approved.service_type, rec.proposal_current_approved) ) : ""
    end

    def link_deletion_approved(rec)
      rec.proposal_deletion_approved.present? ? link_to( rec.proposal_deletion_approved.fullname, proposal_path( rec.proposal_deletion_approved.service_type, rec.proposal_deletion_approved) ) : ""
    end

    def filter_current_approved_insertion_date
      ->(column, value) { 
        # ::Arel::Nodes::SqlLiteral.new("CAST('#{column.field}' AS VARCHAR)").matches("#{ column.search.value }%") 
        ::Arel::Nodes::SqlLiteral.new('CAST("proposal_current_approveds_registers"."insertion_date" AS VARCHAR)').matches("%#{ column.search.value }%") 
      }
    end

    def filter_deletion_approved_insertion_date
      ->(column, value) { 
        # ::Arel::Nodes::SqlLiteral.new("CAST('#{column.field}' AS VARCHAR)").matches("#{ column.search.value }%") 
        ::Arel::Nodes::SqlLiteral.new('CAST("proposal_deletion_approveds_registers"."insertion_date" AS VARCHAR)').matches("%#{ column.search.value }%") 
      }
    end



    def filter_custom_column_condition
      #->(column) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
      ->(column, value) {
          sql_sub = value.present? ? create_sql_string(value) : '(0 = 0)'
          sql_str = "(registers.id IN (" +
            "SELECT proposals.register_id FROM proposals, proposal_types, proposal_statuses WHERE " + 
            "(proposal_types.id = proposals.proposal_type_id AND proposal_statuses.id = proposals.proposal_status_id) AND " +
            sql_sub +
            "))";
          ::Arel::Nodes::SqlLiteral.new("#{sql_str}") 
          }
    end

    def create_sql_string(query_str)
      query_str.split.map { |par| one_param_sql(par) }.join(" AND ")
    end

    def one_param_sql(one_query_word)
      escaped_query_str = Loofah.fragment("'%#{one_query_word}%'").text
  #    "(" + %w(proposal_statuses.name to_char(proposals.insertion_date::timestamptz,'YYYY-MM-DD') proposal_types.name).map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
      "(" + ["proposal_statuses.name", "to_char(proposals.insertion_date::timestamptz,'YYYY-MM-DD TZ')", "proposal_types.name"].map { |column| "#{column} ilike #{escaped_query_str}" }.join(" OR ") + ")"
    end


end
