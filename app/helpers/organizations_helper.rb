module OrganizationsHelper

  ICON = "industry"

  def organization_icon_legend
    fa_icon(ICON)
  end

  def organization_legend
    fa_icon(ICON, text: t("organizations.show.title"))
  end

  def organization_show_legend
    fa_icon(ICON, text: t("organizations.show.title"))
  end

  def organization_index_legend
    fa_icon(ICON, text: t("organizations.index.title"))
  end

  def organization_edit_legend(data_obj=nil)
    data_obj.present? ? fa_icon(ICON, text: t("organizations.edit.title") + ": " + data_obj.fullname_was) : fa_icon(ICON, text: t("helpers.links.edit") )
  end

  def organization_new_legend(data_obj=nil)
    data_obj.present? ? fa_icon(ICON, text: t("organizations.new.title") + ": " + data_obj.fullname) : fa_icon(ICON, text: t("helpers.links.new") )
  end

  def organization_new_edit_legend(data_obj)
    data_obj.new_record? ? organization_new_legend(data_obj) :  organization_edit_legend(data_obj)
  end

  def organization_info_legend(data_obj)
    organization_show_legend + ": " + data_obj.fullname
  end

end
