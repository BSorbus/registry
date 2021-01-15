module Api::V1::Swagger::Models::NetworkType
# class Api::V1::Swagger::Models::NetworkType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :NetworkType do
    key :required, [:id, :name]
    property :id do
      key :type, :string
      key :format, :uuid
    end
    property :name do
      key :type, :string
    end
  end

  # ...
end