module VersionsHelper

  ICON = "history"

  def version_icon_legend
    fa_icon(ICON)
  end

  def version_index_legend
    fa_icon(ICON, text: t("versions.index.title"))
  end

end