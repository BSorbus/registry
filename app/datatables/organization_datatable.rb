class OrganizationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :organization_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:                     { source: "Organization.id", cond: :eq, searchable: false, orderable: false },
      name:                   { source: "Organization.name", cond: :like, searchable: true, orderable: true },
      nip:                    { source: "Organization.nip", cond: :like, searchable: true, orderable: true },
      jointly_identifiers:    { source: "Organization.jointly_identifiers", cond: :like, searchable: true, orderable: true },
      jointly_addresses:      { source: "Organization.jointly_addresses", cond: :like, searchable: true, orderable: true },
      jointly_addresses_ext:  { source: "Organization.jointly_addresses_ext", cond: :like, searchable: true, orderable: true },
      note:                   { source: "Organization.note", cond: :like, searchable: true, orderable: true },
      # author:         { source: "User.user_name",  cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id:                     record.id,
        name:                   link_to( record.fullname, organization_path(record) ),
        nip:                    record.nip,
        jointly_identifiers:    record.jointly_identifiers.html_safe,
        jointly_addresses:      record.jointly_addresses.html_safe,
        jointly_addresses_ext:  record.jointly_addresses_ext.html_safe,
        note:                   record.note_truncate,
        # author:         link_to( record.author.fullname, user_path(record.author_id) )
      }
    end
  end

  private

    def get_raw_records
      Organization.all
    end

end
