module Api::V1::Swagger::Models::ServiceType
# class Api::V1::Swagger::Models::ServiceType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :ServiceType do
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