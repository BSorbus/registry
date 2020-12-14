class UserOrganizationsDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :organization_path, :organization_user_path, :organization_users_path, :policy

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:                     { source: "Organization.id", cond: :eq, searchable: false, orderable: false },
      name:                   { source: "Organization.name", cond: :like, searchable: true, orderable: true },
      jointly_identifiers:    { source: "Organization.jointly_identifiers", cond: :like, searchable: true, orderable: true },
      jointly_addresses:      { source: "Organization.jointly_addresses", cond: :like, searchable: true, orderable: true },
      jointly_addresses_ext:  { source: "Organization.jointly_addresses_ext", cond: :like, searchable: true, orderable: true },
      note:                   { source: "Organization.note", cond: :like, searchable: true, orderable: true },
      has_organization:       { source: "Organization.id",  searchable: false, orderable: false },
      action:                 { source: "Organization.id", searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      user_has_organization = User.joins(:organizations).where(organizations: {id: record.id}, users: {id: options[:only_for_current_user_id]}).any?
      {
        id:                     record.id,
        name:                   link_to( record.fullname, organization_path(record.id) ),
        jointly_identifiers:    record.jointly_identifiers.html_safe,
        jointly_addresses:      record.jointly_addresses.html_safe,
        jointly_addresses_ext:  record.jointly_addresses_ext.html_safe,
        note:                   record.note_truncate,
        has_organization:       user_has_organization ? '<div style="text-align: center"><div class="glyphicon glyphicon-ok"></div></div>'.html_safe : '',
        action:                 link_add_remove(record, user_has_organization).html_safe
      }
    end
  end

  private

    def get_raw_records
      if options[:checked_only_filter].present?
        User.find(options[:only_for_current_user_id]).organizations
      else
        Organization.all
      end
    end

    def link_add_remove(rec, has_organization)
      if policy(rec).add_remove_organization_user?
        if has_organization
          "<div style='text-align: center'><button ajax-path='" + organization_user_path(organization_id: rec.id, id: options[:only_for_current_user_id]) + "' ajax-method='DELETE' toastr-message='" + rec.name + "<br>...usunięto' class='btn btn-xs btn-danger fa fa-minus'></button></div>"
        else
          "<div style='text-align: center'><button ajax-path='" + organization_users_path(organization_id: rec.id, id: options[:only_for_current_user_id]) + "' ajax-method='POST' toastr-message='" + rec.name + "<br>...dodano' class='btn btn-xs btn-success fa fa-plus'></button></div>"
        end
      else
        ""
      end
    end



  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
