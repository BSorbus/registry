class CreateProposalServices < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_services, id: :uuid do |t|
      t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      t.references :service_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      t.text :description, default: ""
      t.boolean :only_wholesale, default: false
      t.boolean :only_resale, default: false

      t.timestamps
    end
    add_index :proposal_services, [:proposal_id, :service_type_id], name: "idx_proposal_services_proposal_service_type_uniqueness", unique: true
  end
end
