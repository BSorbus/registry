module Api::V1::Swagger::Models::LegalFormType
# class Api::V1::Swagger::Models::LegalFormType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :LegalFormType do
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