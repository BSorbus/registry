module Api::V1::Swagger::Models::AddressType
# class Api::V1::Swagger::Models::AddressType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :AddressType do
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