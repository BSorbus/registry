class CreateProposalServiceCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_service_candidates, id: :uuid do |t|
      t.references :proposal_candidate, foreign_key: { to_table: :proposal_candidates }, index: true, type: :uuid
      t.references :service_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      t.text :description, default: ""
      t.boolean :only_wholesale, default: false
      t.boolean :only_resale, default: false

      t.timestamps
    end
    add_index :proposal_service_candidates, [:proposal_candidate_id, :service_type_id], name: "idx_proposal_service_cs_proposal_service_type_uniqueness", unique: true
  end
end
