module Api::V1::Swagger::Models::ErrorModel
# class Api::V1::Swagger::Models::ErrorModel < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :ErrorModel do
    key :required, [:code, :message]
    property :code do
      key :type, :integer
      key :format, :int32
    end
    property :message do
      key :type, :string
    end
  end

end