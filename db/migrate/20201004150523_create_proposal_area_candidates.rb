class CreateProposalAreaCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_area_candidates, id: :uuid do |t|
      t.references :proposal_candidate, foreign_key: { to_table: :proposal_candidates }, index: true, type: :uuid
      t.string :province_code,              default: ""               #, limit: 20
      t.string :province_name,              default: "", index: true  #, limit: 50 
      t.string :district_code,              default: ""               #, limit: 20
      t.string :district_name,              default: "", index: true  #, limit: 50
      t.string :commune_code,               default: ""               #, limit: 20
      t.string :commune_name,               default: "", index: true  #, limit: 50

      t.timestamps
    end
    add_index :proposal_area_candidates, [:proposal_candidate_id, :province_code, :district_code, :commune_code], name: "idx_proposal_area_cs_xxx_code_uniqueness", unique: true
  end
end
