module RegistersHelper

  ICON = "file-signature"

  def register_icon_legend
    fa_icon(ICON)
  end

  def register_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("registers_#{service_type}.show.title")) : fa_icon(ICON, text: t("registers.show.title"))
  end

  def register_show_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("registers_#{service_type}.show.title")) : fa_icon(ICON, text: t("registers.show.title"))
  end

  def register_index_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("registers_#{service_type}.index.title")) : fa_icon(ICON, text: t("registers.index.title"))
  end

  def register_edit_legend(data_obj=nil)
    data_obj.present? ? fa_icon(ICON, text: t("registers.edit.title") + ": " + data_obj.fullname_was) : fa_icon(ICON, text: t("helpers.links.edit") )
  end

  def register_new_legend(data_obj=nil)
    data_obj.present? ? fa_icon(ICON, text: t("registers.new.title") + ": " + data_obj.fullname) : fa_icon(ICON, text: t("helpers.links.new") )
  end

  def register_new_edit_legend(data_obj)
    data_obj.new_record? ? register_new_legend(data_obj) :  register_edit_legend(data_obj)
  end

  def register_info_legend(data_obj)
    register_show_legend(data_obj.service_type) + ": " + data_obj.fullname
  end

  def register_policy_check(register, action, service_type)
    unless ['j', 'p', 't'].include?(service_type)
       raise "Ruby injection register type"
    end
    unless ['index_in_role', 'index', 'show', 'new', 'create', 'edit', 'update', 'destroy', 'print', 'work', 'version'].include?(action)
       raise "Ruby injection action type"
    end
    return policy(register).send("#{action}_#{service_type}?")
  end

end
