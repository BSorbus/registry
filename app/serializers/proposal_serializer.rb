class ProposalSerializer < ActiveModel::Serializer
  attribute :id
  attribute :service_type
  attribute :insertion_date
  attribute :approved_date
  attribute :rejected_date
  # attribute :annuled_date
  attribute :activity_area_whole_poland

  attribute :jst_providing_networks, if: -> { object.service_type == 'j' }
  attribute :jst_provision_telecom_services, if: -> { object.service_type == 'j' }
  attribute :jst_provision_related_services, if: -> { object.service_type == 'j' }
  attribute :jst_other_telecom_activities, if: -> { object.service_type == 'j' }
  attribute :jst_date_of_adopting_the_resolution_date, if: -> { object.service_type == 'j' }
  attribute :jst_resolution_number, if: -> { object.service_type == 'j' }

  belongs_to :proposal_type
  belongs_to :proposal_status

  has_many :proposal_networks, dependent: :destroy, if: -> { object.service_type == 't' }
  has_many :proposal_services, dependent: :destroy, if: -> { object.service_type == 't' }
  has_many :proposal_areas, dependent: :destroy, unless: -> { object.activity_area_whole_poland == true }
  # has_many :proposal_attachments, dependent: :destroy

end


      # t.references :organization, foreign_key: { to_table: :organizations }, index: true, type: :uuid
      # t.references :register, index: true, type: :uuid

      # t.boolean :activity_area_whole_poland, default: true
      # t.date :scheduled_start_date
      # t.date :scheduled_end_date

      # t.boolean :jst_providing_networks, default: false
      # t.boolean :jst_provision_telecom_services, default: false
      # t.boolean :jst_provision_related_services, default: false
      # t.boolean :jst_other_telecom_activities, default: false
      # t.date :jst_date_of_adopting_the_resolution_date
      # t.string :jst_resolution_number, default: ""

      # t.text :status_comment, default: ""
      # t.text :note, default: ""