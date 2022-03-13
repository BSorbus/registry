class Api::V1::FeatureTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :valid_regex, :format_example
end
