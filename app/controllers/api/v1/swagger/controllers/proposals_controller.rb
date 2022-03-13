# frozen_string_literal: true

class Api::V1::Swagger::Controllers::ProposalsController
  include Swagger::Blocks

  swagger_path '/j/proposals' do
    operation :post do
      key :description, 'Creates a new JST proposal'
      key :tags, [
        'Proposal'
      ]

      security do
        key :BasicAuth, []
      end

      parameter do
        key :name, :j_proposal
        key :in, :body
        key :description, 'data of the new JST proposal'
        key :required, true
        schema do
          key :'$ref', :JProposalInput
        end
      end

      response 201 do
        key :description, 'Proposal JST created'
        schema do
          property :data do
            key :'$ref', :JProposal
          end

          # property :meta do
          #   key :'$ref', :Meta
          # end
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

  #--------------------------------------

  swagger_path '/t/proposals' do
    operation :post do
      key :description, 'Creates a new PT proposal'
      key :tags, [
        'Proposal'
      ]

      security do
        key :BasicAuth, []
      end

      parameter do
        key :name, :t_proposal
        key :in, :body
        key :description, 'data of the new PT proposal'
        key :required, true
        schema do
          key :'$ref', :TProposalInput
        end
      end

      response 201 do
        key :description, 'Proposal PT created'
        schema do
          property :data do
            key :'$ref', :TProposal
          end

          # property :meta do
          #   key :'$ref', :Meta
          # end
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
