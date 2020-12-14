class AddressVersion < PaperTrail::Version

  # self.table_name = :address_versions
  self.table_name = :versions
  default_scope { where(item_type: "Address") }

end
