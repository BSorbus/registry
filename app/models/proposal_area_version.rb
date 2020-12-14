class ProposalAreaVersion < PaperTrail::Version

  # self.table_name = :organization_versions
  self.table_name = :versions
  default_scope { where(item_type: "ProposalArea") }

end
