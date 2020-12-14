class CreateRepresentatives < ActiveRecord::Migration[5.2]
  def change
    create_table :representatives, id: :uuid do |t|
      t.references :organization, foreign_key: { to_table: :organizations }, index: true, type: :uuid
      t.references :representative_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid
      t.string :first_name,                 default: ""               #, limit: 20
      t.string :last_name,                  default: ""               #, limit: 20

      t.text :note, default: ""

      t.timestamps
    end
  end
end
