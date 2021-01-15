class ProposalNetworkSerializer < ActiveModel::Serializer
  attributes :id, :description

  belongs_to :network_type, class_name: "FeatureType", serializer: SimpleFeatureTypeSerializer

end

      # t.references :proposal, foreign_key: { to_table: :proposals }, index: true, type: :uuid
      # t.references :network_type, foreign_key: { to_table: :feature_types }, index: true, type: :uuid

      # t.text :description, default: ""
