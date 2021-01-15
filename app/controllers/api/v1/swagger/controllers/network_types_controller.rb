# frozen_string_literal: true

class Api::V1::Swagger::Controllers::NetworkTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/network_types/{id}' do
    operation :get do
      key :summary, 'Find NetworkType by ID as UUID'
      key :description, 'Returns a single network_type'
      key :operationId, 'findNetworkTypeById'
      key :tags, [
        'NetworkType'
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
        key :description, 'network_type response'
        schema do
          key :'$ref', :NetworkType
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


  swagger_path '/dictionary/network_types' do
    operation :get do
      key :summary, 'All NetworkTypes'
      key :description, 'Returns all network_types'
      key :operationId, 'findNetworkTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'NetworkType'
      ]
      response 200 do
        key :description, 'network_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :NetworkType
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