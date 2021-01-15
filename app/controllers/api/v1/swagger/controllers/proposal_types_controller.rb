# frozen_string_literal: true

class Api::V1::Swagger::Controllers::ProposalTypesController
  include Swagger::Blocks

  swagger_path '/dictionary/proposal_types/{id}' do
    operation :get do
      key :summary, 'Find ProposalType by ID'
      key :description, 'Returns a single proposal_type'
      key :operationId, 'findProposalTypeById'
      key :tags, [
        'ProposalType'
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
        key :description, 'proposal_type response'
        schema do
          key :'$ref', :ProposalType
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


  swagger_path '/dictionary/proposal_types' do
    operation :get do
      key :summary, 'All ProposalTypes'
      key :description, 'Returns all proposal_types'
      key :operationId, 'findProposalTypes'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'ProposalType'
      ]
      response 200 do
        key :description, 'proposal_type response'
        schema do
          key :type, :array
          items do
            key :'$ref', :ProposalType
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