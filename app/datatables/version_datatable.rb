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
      id:             { source: "PaperTrail::Version.id", cond: :eq, searchable: true, orderable: true },
      created_at:     { source: "PaperTrail::Version.created_at", cond: :like, searchable: true, orderable: true },
      transaction_id: { source: "PaperTrail::Version.transaction_id",  cond: :like, searchable: true, orderable: true },
      created_by:     { source: "User.user_name",  cond: :like, searchable: true, orderable: true },
      event:          { source: "PaperTrail::Version.event",  cond: :like, searchable: true, orderable: true },
      trackable_type: { source: "PaperTrail::Version.item_type",  cond: :like, searchable: true, orderable: true },
      trackable_id:   { source: "PaperTrail::Version.item_id",  cond: :like, searchable: true, orderable: true },
      # item_subtype:   { source: "PaperTrail::Version.item_subtype",  cond: :like, searchable: true, orderable: true },
      object_changes: { source: "PaperTrail::Version.object_changes",  cond: :like, searchable: true, orderable: false },
      parameters:     { source: "PaperTrail::Version.parameters",  cond: :like, searchable: true, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        id:             record.id,
        created_at:     record.created_at.strftime("%Y-%m-%d %H:%M:%S:%6N"),
        transaction_id: record.transaction_id,
        created_by:     record.author ? link_to( record.author.fullname, user_path(record.author.id) ) : record.whodunnit,
        event:          record.event,
        trackable_type: record.item_type,
        trackable_id:   record.item_id, #link_to_polymorphic_trackable(record),
        # item_subtype:   record.item_subtype,
        # object_changes: "record.id: #{record.id},<br> item_type: #{record.item_type},<br> item_id: #{record.item_id},<br> event: #{record.event},<br> item_subtype: #{record.item_subtype},<br> transaction_id: #{record.transaction_id}".html_safe,
        # parameters:     record.pretty_parameters
        object_changes: pretty_object_changes(record),
        parameters:     flat_version_associations(record)
      }
    end
  end

  private

    def get_raw_records
      if (options[:trackable_id]).present? && (options[:trackable_type]).present?
        PaperTrail::Version.includes(:author).references(:author).where(item_id: options[:trackable_id], item_type: options[:trackable_type]).all
      elsif (options[:only_for_current_user_id]).present?
        PaperTrail::Version.includes(:author).references(:author).where(user_id: options[:only_for_current_user_id]).all
      else
        PaperTrail::Version.includes(:author).references(:author).all
      end
    end

    def link_to_polymorphic_trackable(rec)
      if rec.trackable
        rec.url.html_safe
      else
        rec.trackable_id
      end  
    end

    def pretty_object_changes(rec)
      JSON.pretty_generate(rec.object_changes)
    end

    def flat_version_associations(rec)
  #    self.proposals.order(insertion_date: :desc).flat_map {|row| "#{row.try(:title_as_link)} - [#{row.event_status.name}]" }.join('<br>').html_safe
  #    self.proposals.order(:insertion_date).flat_map {|row| "#{row.insertion_date.strftime("%Y-%m-%d %H:%M:%S")} - #{row.try(:name)} - [#{row.proposal_type.name}][#{row.proposal_status.name}]" }.join('<br>').html_safe

  #    self.proposals.order(:insertion_date).flat_map {|row| "#{row.organization.name}  #{row.insertion_date.strftime("%Y-%m-%d")} - #{row.try(:name)} - [#{row.proposal_type.name}][#{row.proposal_status.name}]" }.join('<br>').html_safe

      # self.version_associations.flat_map {|row| "<div class='col-sm-3'>#{row.version_id}</div>    <div class='col-sm-3'>#{row.foreign_key_name}</div>    <div class='col-sm-3'>#{row.foreign_key_id}</div> <div class='col-sm-3'>#{row.foreign_type}</div>" }.join('<br>').html_safe

      #self.version_associations.flat_map {|row| "#{row.attributes}" }.join('<br>')
      #self.associations_version_ids

      # ' --- flat_version_associations --- '

      str1 = rec.version_associations.flat_map {|row| "#{JSON.pretty_generate(row.attributes)}" }.join(', ')


      # str2 = PaperTrail::VersionAssociation.where(foreign_key_id: self.item_id, foreign_type: self.item_type).flat_map {|row| "#{row.attributes}" }.join('<br>').html_safe

      # return str1 + "<br><br>" + str2
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
