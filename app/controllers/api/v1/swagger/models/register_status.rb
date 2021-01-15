module Api::V1::Swagger::Models::RegisterStatus
# class Api::V1::Swagger::Models::RegisterStatus < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :RegisterStatus do
    key :required, [:id, :name]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
  end

  # ...
end