# frozen_string_literal: true

class Api::V1::Swagger::Controllers::RegistersController
  include Swagger::Blocks

  swagger_path '/j/registers/{id}' do
    operation :get do
      key :summary, 'Find Register by NO or ID'
      key :description, 'Returns a single register'
      key :operationId, 'findJRegisterById'
      key :tags, [
        'Register'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID'
        key :required, true
        # key :type, :integer
        # key :format, :int64
        key :type, :string
      end
      response 200 do
        key :description, 'register response'
        schema do
          key :'$ref', :Register
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


  swagger_path '/j/registers' do
    operation :get do
      key :summary, 'All JST Registers'
      key :description, 'Returns all JST registers'
      key :operationId, 'findJRegisters'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'Register'
      ]
      response 200 do
        key :description, 'register response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Register
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

# ------------------------------------------------------------------------------

  swagger_path '/t/registers/{id}' do
    operation :get do
      key :summary, 'Find Register by NO or ID'
      key :description, 'Returns a single register'
      key :operationId, 'findTRegisterById'
      key :tags, [
        'Register'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID'
        key :required, true
        # key :type, :integer
        # key :format, :int64
        key :type, :string
      end
      response 200 do
        key :description, 'register response'
        schema do
          key :'$ref', :Register
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


  swagger_path '/t/registers' do
    operation :get do
      key :summary, 'All PT Registers'
      key :description, 'Returns all PT registers'
      key :operationId, 'findTRegisters'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'Register'
      ]
      response 200 do
        key :description, 'register response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Register
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