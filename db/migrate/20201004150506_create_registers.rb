class CreateRegisters < ActiveRecord::Migration[5.2]
  def change
    create_table :registers, id: :uuid do |t|
      t.references :author, foreign_key: { to_table: :users }, index: true, type: :uuid

      t.string :service_type,                   limit: 1, null: false, default: "", index: true
      t.references :register_status, foreign_key: { to_table: :register_statuses }, index: true
      t.references :organization, foreign_key: { to_table: :organizations }, index: true, type: :uuid

#      t.date :insertion_date
      t.integer :register_no, index: true
      t.uuid :proposal_registration_approved_id
      t.uuid :proposal_current_approved_id
      t.uuid :proposal_deletion_approved_id


      t.text :note, default: ""

      t.timestamps


      #t.index [:author_id, :category, :register_status_id], name: "idx_register_author_category_register_status_uniqueness", unique: true
    end
    #add_index :registers, [:register_no, :service_type], unique: true
  end
end
