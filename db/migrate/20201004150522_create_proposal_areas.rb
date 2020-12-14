class CreateProposalAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_areas, id: :uuid do |t|
      t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      t.string :province_code,              default: ""               #, limit: 20
      t.string :province_name,              default: "", index: true  #, limit: 50 
      t.string :district_code,              default: ""               #, limit: 20
      t.string :district_name,              default: "", index: true  #, limit: 50
      t.string :commune_code,               default: ""               #, limit: 20
      t.string :commune_name,               default: "", index: true  #, limit: 50

      t.timestamps
    end
    add_index :proposal_areas, [:proposal_id, :province_code, :district_code, :commune_code], name: "idx_proposal_areas_xxx_code_uniqueness", unique: true
  end
end
