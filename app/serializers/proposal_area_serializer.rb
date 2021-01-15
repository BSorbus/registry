class ProposalAreaSerializer < ActiveModel::Serializer
  attributes :id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name
end

      # t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      # t.string :province_code,              default: ""               #, limit: 20
      # t.string :province_name,              default: "", index: true  #, limit: 50 
      # t.string :district_code,              default: ""               #, limit: 20
      # t.string :district_name,              default: "", index: true  #, limit: 50
      # t.string :commune_code,               default: ""               #, limit: 20
      # t.string :commune_name,               default: "", index: true  #, limit: 50
