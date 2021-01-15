# frozen_string_literal: true

class Api::V1::Swagger::Controllers::LegalFormTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/legal_form_types/{id}' do
    operation :get do
      key :summary, 'Find LegalFormType by ID as UUID'
      key :description, 'Returns a single legal_form_type'
      key :operationId, 'findLegalFormTypeById'
      key :tags, [
        'LegalFormType'
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
        key :description, 'legal_form_type response'
        schema do
          key :'$ref', :LegalFormType
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


  swagger_path '/dictionary/legal_form_types' do
    operation :get do
      key :summary, 'All LegalFormTypes'
      key :description, 'Returns all legal_form_types'
      key :operationId, 'findLegalFormTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'LegalFormType'
      ]
      response 200 do
        key :description, 'legal_form_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :LegalFormType
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