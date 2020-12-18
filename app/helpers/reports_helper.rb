module ReportsHelper

  ICON = "file-invoice-dollar"

  def report_icon_legend
    fa_icon(ICON)
  end

  def report_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("reports_#{service_type}.show.title")) : fa_icon(ICON, text: t("reports.show.title"))
  end

  def report_show_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("reports_#{service_type}.show.title")) : fa_icon(ICON, text: t("reports.show.title"))
  end

  def report_index_legend(service_type=nil)
    service_type.present? ? fa_icon(ICON, text: t("reports_#{service_type}.index.title")) : fa_icon(ICON, text: t("reports.index.title"))
  end

end
