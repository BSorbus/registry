class FeatureVersion < PaperTrail::Version

  # self.table_name = :feature_versions
  self.table_name = :versions
  default_scope { where(item_type: "Feature") }

end
