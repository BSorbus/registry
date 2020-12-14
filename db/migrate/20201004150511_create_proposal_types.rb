class CreateProposalTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_types do |t|
      t.string :name
      t.date :state_on

      t.timestamps null: false
    end
    add_index :proposal_types, [:name], unique: true
  end
end
