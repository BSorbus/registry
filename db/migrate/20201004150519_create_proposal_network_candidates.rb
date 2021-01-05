class CreateProposalNetworkCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_network_candidates, id: :uuid do |t|
      t.references :proposal_candidate, foreign_key: { to_table: :proposal_candidates }, index: true, type: :uuid
      t.references :network_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      t.text :description, default: ""

      t.timestamps
    end
    add_index :proposal_network_candidates, [:proposal_candidate_id, :network_type_id], name: "idx_proposal_network_cs_proposal_id_network_type_uniqueness", unique: true
  end
end
