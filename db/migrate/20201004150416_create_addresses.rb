class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses, id: :uuid do |t|
      t.references :addressable, polymorphic: true, index: true, type: :uuid
      t.references :address_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid
      t.string :country_code,               default: "PL"
      t.string :address_combine_id,         default: ""               #, limit: 26 
      t.string :province_code,              default: ""               #, limit: 20
      t.string :province_name,              default: "", index: true  #, limit: 50 
      t.string :district_code,              default: ""               #, limit: 20
      t.string :district_name,              default: "", index: true  #, limit: 50
      t.string :commune_code,               default: ""               #, limit: 20
      t.string :commune_name,               default: "", index: true  #, limit: 50
      t.string :city_code,                  default: ""               #, limit: 20
      t.string :city_name,                  default: "", index: true  #, limit: 50
      t.string :parent_city_code,           default: ""               #, limit: 20
      t.string :parent_city_name,           default: ""               #, limit: 50
      t.string :street_code,                default: ""               #, limit: 20
      t.string :street_name,                default: "", index: true  #, limit: 50
      t.string :street_attribute,           default: ""               #, limit: 20
      t.string :address_house,              default: ""               #, limit: 10
      t.string :address_number,             default: ""               #, limit: 10
      t.string :address_postal_code,        default: "", index: true  #, limit: 10

      t.timestamps
    end
    add_index :addresses, [:addressable_type, :addressable_id, :address_type_id], name: "idx_addresses_addressable_type_id_address_type_uniqueness", unique: true
  end
end
