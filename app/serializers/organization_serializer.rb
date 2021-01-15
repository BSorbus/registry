class OrganizationSerializer < ActiveModel::Serializer
  # type "organization"
  attributes :id, :short_name, :name, :nip
end


    # create_table :organizations, id: :uuid do |t|
    #   t.references :author, foreign_key: { to_table: :users }, index: true, type: :uuid

    #   t.string :short_name, index: true,    default: ""
    #   t.string :name, index: true,          default: ""
    #   t.string :nip, index: true,           default: ""
    #   t.string :regon, index: true,         default: ""

    #   t.references :legal_form_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

    #   t.string :jointly_identifiers,        default: ""
    #   t.text :jointly_addresses,            default: ""
    #   t.string :jointly_addresses_ext,      default: ""

    #   t.references :jst_legal_form_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid
    #   t.string :jst_teryt,                  default: ""

    #   t.text :note, default: ""

    #   t.timestamps
