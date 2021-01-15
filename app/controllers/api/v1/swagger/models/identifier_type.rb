module Api::V1::Swagger::Models::IdentifierType
# class Api::V1::Swagger::Models::IdentifierType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :IdentifierType do
    key :required, [:id, :name]
    property :id do
      key :type, :string
      key :format, :uuid
    end
    property :name do
      key :type, :string
    end
    property :valid_regex do
      key :type, :string
      key :format, :regex
    end
    property :format_example do
      key :type, :string
    end
  end

  # ...
end