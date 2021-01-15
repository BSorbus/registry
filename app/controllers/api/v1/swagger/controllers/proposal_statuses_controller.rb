# frozen_string_literal: true

class Api::V1::Swagger::Controllers::ProposalStatusesController
  include Swagger::Blocks

  swagger_path '/dictionary/proposal_statuses/{id}' do
    operation :get do
      key :summary, 'Find ProposalStatus by ID'
      key :description, 'Returns a single proposal_status'
      key :operationId, 'findProposalStatusById'
      key :tags, [
        'ProposalStatus'
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
        key :description, 'proposal_status response'
        schema do
          key :'$ref', :ProposalStatus
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


  swagger_path '/dictionary/proposal_statuses' do
    operation :get do
      key :summary, 'All ProposalStatuses'
      key :description, 'Returns all proposal_statuses'
      key :operationId, 'findProposalStatuses'
      # key :produces, [
      #   'application/json',
      #   'text/html',
      # ]
      key :tags, [
        'ProposalStatus'
      ]
      response 200 do
        key :description, 'proposal_status response'
        schema do
          key :type, :array
          items do
            key :'$ref', :ProposalStatus
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