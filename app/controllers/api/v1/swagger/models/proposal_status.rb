module Api::V1::Swagger::Models::ProposalStatus
# class Api::V1::Swagger::Models::ProposalStatus < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :ProposalStatus do
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