class CreateProposalStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_statuses do |t|
      t.string :name
      t.date :state_on

      t.timestamps null: false
    end
    add_index :proposal_statuses, [:name], unique: true
  end
end
