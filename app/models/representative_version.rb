class RepresentativeVersion < PaperTrail::Version

  # self.table_name = :representative_versions
  self.table_name = :versions
  default_scope { where(item_type: "Representative") }

end
