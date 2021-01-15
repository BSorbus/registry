class ProposalServiceSerializer < ActiveModel::Serializer
  attributes :id, :description, :only_wholesale, :only_resale

  belongs_to :service_type, class_name: "FeatureType", serializer: SimpleFeatureTypeSerializer
end

      # t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      # t.references :service_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      # t.text :description, default: ""
      # t.boolean :only_wholesale, default: false
      # t.boolean :only_resale, default: false
