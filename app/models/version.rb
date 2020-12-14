class Version < PaperTrail::Version

  self.table_name = :versions
#  default_scope { where(item_type: "Representative") }

  belongs_to :author, class_name: "User", optional: true
  belongs_to :trackable, polymorphic: true, optional: true

  def pretty_parameters
    # JSON.pretty_generate(JSON.parse(self.parameters.gsub('":"', '": "')))
    ' --- pretty_parameters --- '
  end

  def pretty_object_changes
    # JSON.pretty_generate(self.object_changes)
    ' --- pretty_object_changes --- '
  end


  def flat_version_associations
#    self.proposals.order(insertion_date: :desc).flat_map {|row| "#{row.try(:title_as_link)} - [#{row.event_status.name}]" }.join('<br>').html_safe
#    self.proposals.order(:insertion_date).flat_map {|row| "#{row.insertion_date.strftime("%Y-%m-%d %H:%M:%S")} - #{row.try(:name)} - [#{row.proposal_type.name}][#{row.proposal_status.name}]" }.join('<br>').html_safe

#    self.proposals.order(:insertion_date).flat_map {|row| "#{row.organization.name}  #{row.insertion_date.strftime("%Y-%m-%d")} - #{row.try(:name)} - [#{row.proposal_type.name}][#{row.proposal_status.name}]" }.join('<br>').html_safe

    # self.version_associations.flat_map {|row| "<div class='col-sm-3'>#{row.version_id}</div>    <div class='col-sm-3'>#{row.foreign_key_name}</div>    <div class='col-sm-3'>#{row.foreign_key_id}</div> <div class='col-sm-3'>#{row.foreign_type}</div>" }.join('<br>').html_safe

    #self.version_associations.flat_map {|row| "#{row.attributes}" }.join('<br>')
    #self.associations_version_ids

    # ' --- flat_version_associations --- '

    str1 = self.version_associations.flat_map {|row| "#{row.attributes}" }.join('<br>')
    # str2 = PaperTrail::VersionAssociation.where(foreign_key_id: self.item_id, foreign_type: self.item_type).flat_map {|row| "#{row.attributes}" }.join('<br>').html_safe

    # return str1 + "<br><br>" + str2
  end


  def associations_version_ids(item_id=nil)
    if !item_id.nil?
#      ids = PaperTrail::VersionAssociation.where(foreign_key_id: item_id, foreign_key_name: 'item_id').select(:version_id)
      ids = PaperTrail::VersionAssociation.where(foreign_key_id: item_id).select(:version_id)

      return ids
    else
      ids = PaperTrail::VersionAssociation.where(foreign_key_name: 'item_id').select(:version_id)

      return ids
    end
  end



end
