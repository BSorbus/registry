class CreateProposalAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_attachments, id: :uuid do |t|
      t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      t.references :attachment_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      t.timestamps
    end
    # add_index :proposal_areas, [:proposal_id, :province_code, :district_code, :commune_code], name: "idx_proposal_areas_xxx_code_uniqueness", unique: true
  end
end
