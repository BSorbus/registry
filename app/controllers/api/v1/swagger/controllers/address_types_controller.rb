# frozen_string_literal: true

class Api::V1::Swagger::Controllers::AddressTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/address_types/{id}' do
    operation :get do
      key :summary, 'Find AddressType by ID as UUID'
      key :description, 'Returns a single address_type'
      key :operationId, 'findAddressTypeById'
      key :tags, [
        'AddressType'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID'
        key :required, true
        key :type, :string
        key :format, :uuid
      end
      response 200 do
        key :description, 'address_type response'
        schema do
          key :'$ref', :AddressType
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end


  swagger_path '/dictionary/address_types' do
    operation :get do
      key :summary, 'All AddressTypes'
      key :description, 'Returns all address_types'
      key :operationId, 'findAddressTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'AddressType'
      ]
      response 200 do
        key :description, 'address_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :AddressType
          end
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end

  end



end