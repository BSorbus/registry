class CreateProposalNetworks < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_networks, id: :uuid do |t|
      t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      t.references :network_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      t.text :description, default: ""

      t.timestamps
    end
    add_index :proposal_networks, [:proposal_id, :network_type_id], name: "idx_proposal_networks_proposal_id_network_type_uniqueness", unique: true
  end
end
