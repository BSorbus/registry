class VersionDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  include ActionView::Helpers::UrlHelper # for link_to
  include ActionView::Helpers::TextHelper

  def_delegators :@view, :link_to, :user_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id:             { source: "Version.id", cond: :eq, searchable: false, orderable: false },
      created_at:     { source: "Version.created_at", cond: :like, searchable: true, orderable: true },
      transaction_id: { source: "Version.transaction_id",  cond: :like, searchable: true, orderable: true },
      created_by:     { source: "User.user_name",  cond: :like, searchable: true, orderable: true },
      action:         { source: "Version.action",  cond: :like, searchable: true, orderable: true },
      trackable_type: { source: "Version.item_type",  cond: :like, searchable: true, orderable: true },
      trackable_id:   { source: "Version.item_id",  cond: :like, searchable: true, orderable: true },
      object_changes: { source: "Version.object_changes",  cond: :like, searchable: true, orderable: false },
      parameters:     { source: "Version.parameters",  cond: :like, searchable: true, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        created_at:     record.created_at.strftime("%Y-%m-%d %H:%M:%S:%6N"),
        transaction_id: record.transaction_id,
        created_by:     '', #record.author ? link_to( record.author.fullname, user_path(record.author_id) ) : record.author_id,
        action:         record.event,
        trackable_type: record.item_type,
        trackable_id:   record.item_id, #link_to_polymorphic_trackable(record),
#        parameters:     record.pretty_parameters
        object_changes: "record.id: #{record.id},<br> item_type: #{record.item_type},<br> item_id: #{record.item_id},<br> event: #{record.event},<br> item_subtype: #{record.item_subtype},<br> transaction_id: #{record.transaction_id}".html_safe,
        parameters:     record.flat_version_associations.html_safe
      }
    end
  end

  private

    def get_raw_records
      if (options[:trackable_id]).present? && (options[:trackable_type]).present?
        Version.where(item_id: options[:trackable_id], trackable_type: options[:item_type]).includes(:author).references(:author).all
      elsif (options[:only_for_current_user_id]).present?
        Version.where(user_id: options[:only_for_current_user_id]).includes(:author).references(:author).all
      else
        Version.includes(:author).references(:author).all
      end
    end

    def link_to_polymorphic_trackable(rec)
      if rec.trackable
        rec.url.html_safe
      else
        rec.trackable_id
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
