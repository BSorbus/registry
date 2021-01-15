# frozen_string_literal: true

class Api::V1::Swagger::Controllers::IdentifierTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/identifier_types/{id}' do
    operation :get do
      key :summary, 'Find IdentifierType by ID as UUID'
      key :description, 'Returns a single identifier_type'
      key :operationId, 'findIdentifierTypeById'
      key :tags, [
        'IdentifierType'
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
        key :description, 'identifier_type response'
        schema do
          key :'$ref', :IdentifierType
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


  swagger_path '/dictionary/identifier_types' do
    operation :get do
      key :summary, 'All IdentifierTypes'
      key :description, 'Returns all identifier_types'
      key :operationId, 'findIdentifierTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'IdentifierType'
      ]
      response 200 do
        key :description, 'identifier_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :IdentifierType
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