class RegisterSerializer < ActiveModel::Serializer
  # type "register"
  attributes :id, :service_type, :register_no


  # belongs_to :organization, serializer: OrganizationSerializer
  # belongs_to :register_status, serializer: RegisterStatusSerializer
  # or
  belongs_to :organization
  belongs_to :register_status

  # belongs_to :proposal_registration_approved
  belongs_to :proposal_current_approved

end

      # t.references :author, foreign_key: { to_table: :users }, index: true, type: :uuid

      # ,                   limit: 1, null: false, default: "", index: true
      # t.references :register_status, foreign_key: { to_table: :register_statuses }, index: true
      # t.references :organization, foreign_key: { to_table: :organizations }, index: true, type: :uuid

      # t.uuid :proposal_registration_approved_id
      # t.uuid :proposal_current_approved_id
      # t.uuid :proposal_deletion_approved_id

