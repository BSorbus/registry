module Api::V1::Swagger::Models::JstLegalFormType
# class Api::V1::Swagger::Models::JstLegalFormType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :JstLegalFormType do
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