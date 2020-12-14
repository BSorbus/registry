module ProposalsHelper

  ICON = "file-contract"

  def proposal_icon_legend
    fa_icon(ICON)
  end

  def proposal_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("proposals_#{service_type}.show.title")) : fa_icon(ICON, text: t("proposals.show.title"))
  end

  def proposal_show_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("proposals_#{service_type}.show.title")) : fa_icon(ICON, text: t("proposals.show.title"))
  end

  def proposal_index_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("proposals_#{service_type}.index.title")) : fa_icon(ICON, text: t("proposals.index.title"))
  end

  def proposal_edit_legend(data_obj=nil)
    data_obj.present? ? fa_icon(ICON, text: t("proposals_#{data_obj.service_type}.edit.title") + ": " + data_obj.fullname_was) : fa_icon(ICON, text: t("helpers.links.edit") )
  end

  def proposal_new_legend(data_obj=nil)
    data_obj.present? ? fa_icon(ICON, text: t("proposals.new.title") + ": " + data_obj.fullname) : fa_icon(ICON, text: t("helpers.links.new") )
  end

  def proposal_new_edit_legend(data_obj)
    data_obj.new_record? ? proposal_new_legend(data_obj) :  proposal_edit_legend(data_obj)
  end

  def proposal_info_legend(data_obj)
    proposal_show_legend(data_obj.service_type) + ": " + data_obj.fullname
  end

  def proposal_policy_check(proposal, action, service_type)
    unless ['j', 'p', 't'].include?(service_type)
       raise "Ruby injection register type"
    end
    unless ['index_in_role', 'index', 'show', 'new', 'create', 'edit', 'update', 'destroy', 'print', 'work'].include?(action)
       raise "Ruby injection action type"
    end
    return policy(proposal).send("#{action}_#{service_type}?")
  end
end
