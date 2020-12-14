class ProposalVersion < PaperTrail::Version

  # self.table_name = :proposal_versions
  self.table_name = :versions
  default_scope { where(item_type: "Proposal") }

end
