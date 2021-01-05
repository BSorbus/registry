class CreateProposals < ActiveRecord::Migration[5.2]
  def change
    create_table :proposals, id: :uuid do |t|
      t.references :author, foreign_key: { to_table: :users }, index: true, type: :uuid

      t.string :service_type,                   limit: 1, null: false, default: "", index: true
      t.date :insertion_date
      t.date :approved_date
      t.date :rejected_date
      t.date :annuled_date
      t.references :proposal_type, foreign_key: { to_table: :proposal_types }, index: true
      t.references :proposal_status, foreign_key: { to_table: :proposal_statuses }, index: true
      t.references :organization, foreign_key: { to_table: :organizations }, index: true, type: :uuid
      t.references :register, index: true, type: :uuid

      t.boolean :activity_area_whole_poland, default: true
      t.date :scheduled_start_date
      t.date :scheduled_end_date

      t.boolean :jst_providing_networks, default: false
      t.boolean :jst_provision_telecom_services, default: false
      t.boolean :jst_provision_related_services, default: false
      t.boolean :jst_other_telecom_activities, default: false
      t.date :jst_date_of_adopting_the_resolution_date
      t.string :jst_resolution_number, default: ""

      t.text :status_comment, default: ""
      t.text :note, default: ""

      t.timestamps

      #t.index [:author_id, :category, :proposal_status_id], name: "idx_proposal_author_category_proposal_status_uniqueness", unique: true
    end

  end
end
