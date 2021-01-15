# frozen_string_literal: true

class Api::V1::Swagger::Controllers::AddressExtTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/address_ext_types/{id}' do
    operation :get do
      key :summary, 'Find AddressExtType by ID as UUID'
      key :description, 'Returns a single address_ext_type'
      key :operationId, 'findAddressExtTypeById'
      key :tags, [
        'AddressExtType'
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
        key :description, 'address_ext_type response'
        schema do
          key :'$ref', :AddressExtType
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


  swagger_path '/dictionary/address_ext_types' do
    operation :get do
      key :summary, 'All AddressExtTypes'
      key :description, 'Returns all address_ext_types'
      key :operationId, 'findAddressExtTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'AddressExtType'
      ]
      response 200 do
        key :description, 'address_ext_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :AddressExtType
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