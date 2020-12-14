class CreateProposalTTraits < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_t_traits, id: :uuid do |t|
      t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid

      t.date :scheduled_start_date
      t.date :scheduled_end_date

    end
    add_index :proposal_t_traits, [:proposal_id], name: "idx_proposal_t_traits_proposal_id_uniqueness", unique: true
  end
end
