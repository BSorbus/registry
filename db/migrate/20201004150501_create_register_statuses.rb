class CreateRegisterStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :register_statuses do |t|
      t.string :name
      t.date :state_on

      t.timestamps null: false
    end
    add_index :register_statuses, [:name], unique: true
  end
end
