# frozen_string_literal: true

class Api::V1::Swagger::Controllers::JstLegalFormTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/jst_legal_form_types/{id}' do
    operation :get do
      key :summary, 'Find JstLegalFormType by ID as UUID'
      key :description, 'Returns a single jst_legal_form_type'
      key :operationId, 'findJstLegalFormTypeById'
      key :tags, [
        'JstLegalFormType'
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
        key :description, 'jst_legal_form_type response'
        schema do
          key :'$ref', :JstLegalFormType
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


  swagger_path '/dictionary/jst_legal_form_types' do
    operation :get do
      key :summary, 'All JstLegalFormTypes'
      key :description, 'Returns all jst_legal_form_types'
      key :operationId, 'findJstLegalFormTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'JstLegalFormType'
      ]
      response 200 do
        key :description, 'jst_legal_form_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :JstLegalFormType
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