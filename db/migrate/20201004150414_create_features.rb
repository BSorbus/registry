class CreateFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :features, id: :uuid do |t|

      t.references :featurable, polymorphic: true, index: true, type: :uuid
      t.references :feature_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid
      t.string :feature_value, index: true

      t.timestamps
    end
    add_index :features, [:featurable_type, :featurable_id, :feature_type_id], name: "idx_features_featurable_type_id_feature_type_uniqueness", unique: true
  end
end
