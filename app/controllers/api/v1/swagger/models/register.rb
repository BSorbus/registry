module Api::V1::Swagger::Models::Register
# class Api::V1::Swagger::Models::Register < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Register do
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