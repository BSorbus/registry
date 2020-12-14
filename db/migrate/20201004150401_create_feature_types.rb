class CreateFeatureTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :feature_types, id: :uuid do |t|
      t.string :name
      t.string :destiny
      t.string :regexp_format_required
      t.date :state_on

      t.timestamps
    end
    add_index :feature_types, [:name, :destiny], unique: true
  end
end
