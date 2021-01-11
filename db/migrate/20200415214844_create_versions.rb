class CreateVersions < ActiveRecord::Migration[5.2]

  def change
    create_table :versions do |t|
      t.string   :item_type, null: false
      t.uuid     :item_id,   null: false
      t.string   :event,     null: false
      # t.string   :whodunnit
      t.uuid   :whodunnit
      t.jsonb    :object

      # This migration adds the optional `object_changes` column, in which PaperTrail
      # will store the `changes` diff for each update event. See the readme for
      # details.
      t.jsonb    :object_changes
      t.string   :item_subtype


      # add extra info in meta: {}
      # t.uuid     :author_id
      # t.string   :url

      # This migration and CreateVersionAssociations provide the necessary
      # schema for tracking associations.
      t.bigint   :transaction_id


      t.datetime :created_at
    end
    add_index :versions, %i(item_type item_id)
    add_index :versions, [:transaction_id]
  end
end
