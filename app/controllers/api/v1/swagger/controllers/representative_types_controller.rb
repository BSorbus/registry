# frozen_string_literal: true

class Api::V1::Swagger::Controllers::RepresentativeTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/representative_types/{id}' do
    operation :get do
      key :summary, 'Find RepresentativeType by ID as UUID'
      key :description, 'Returns a single representative_type'
      key :operationId, 'findRepresentativeTypeById'
      key :tags, [
        'RepresentativeType'
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
        key :description, 'representative_type response'
        schema do
          key :'$ref', :RepresentativeType
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


  swagger_path '/dictionary/representative_types' do
    operation :get do
      key :summary, 'All RepresentativeTypes'
      key :description, 'Returns all representative_types'
      key :operationId, 'findRepresentativeTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'RepresentativeType'
      ]
      response 200 do
        key :description, 'representative_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :RepresentativeType
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