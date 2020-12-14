class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations, id: :uuid do |t|
      t.references :author, foreign_key: { to_table: :users }, index: true, type: :uuid

      t.string :name, index: true,          default: ""
      t.string :tax_no, index: true,        default: ""
      t.references :legal_form_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid
      t.references :jst_legal_form_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      t.string :jointly_identifiers,        default: ""
      t.text :jointly_addresses,            default: ""
      t.string :jointly_addresses_ext,      default: ""

      # adres siedziby
      # t.string :parent_city_code,         limit: 20, default: ""
      # t.string :parent_city_name,         limit: 50, default: ""

      t.text :note, default: ""

      t.timestamps
    end
  end
end
