class RegisterVersion < PaperTrail::Version

  # self.table_name = :register_versions
  self.table_name = :versions
  default_scope { where(item_type: "Register") }

end
