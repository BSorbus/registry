# frozen_string_literal: true

class Api::V1::Swagger::Controllers::ServiceTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/service_types/{id}' do
    operation :get do
      key :summary, 'Find ServiceType by ID as UUID'
      key :description, 'Returns a single service_type'
      key :operationId, 'findServiceTypeById'
      key :tags, [
        'ServiceType'
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
        key :description, 'service_type response'
        schema do
          key :'$ref', :ServiceType
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


  swagger_path '/dictionary/service_types' do
    operation :get do
      key :summary, 'All ServiceTypes'
      key :description, 'Returns all service_types'
      key :operationId, 'findServiceTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'ServiceType'
      ]
      response 200 do
        key :description, 'service_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :ServiceType
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