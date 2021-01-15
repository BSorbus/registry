# frozen_string_literal: true

class Api::V1::Swagger::Controllers::RegisterStatusesController
  include Swagger::Blocks

  swagger_path '/dictionary/register_statuses/{id}' do
    operation :get do
      key :summary, 'Find RegisterStatus by ID'
      key :description, 'Returns a single register_status'
      key :operationId, 'findRegisterStatusById'
      key :tags, [
        'RegisterStatus'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'register_status response'
        schema do
          key :'$ref', :RegisterStatus
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


  swagger_path '/dictionary/register_statuses' do
    operation :get do
      key :summary, 'All RegisterStatuses'
      key :description, 'Returns all register_statuses'
      key :operationId, 'findRegisterStatuses'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'RegisterStatus'
      ]
      response 200 do
        key :description, 'register_status response'
        schema do
          key :type, :array
          items do
            key :'$ref', :RegisterStatus
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