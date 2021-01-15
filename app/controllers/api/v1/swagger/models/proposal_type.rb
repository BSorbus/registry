module Api::V1::Swagger::Models::ProposalType
# class Api::V1::Swagger::Models::ProposalType < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :ProposalType do
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