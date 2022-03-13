# frozen_string_literal: true

class Api::V1::Swagger::Controllers::OrganizationsController
  include Swagger::Blocks

  swagger_path '/organizations/cbo_new_data_service' do
    operation :post do
      key :description, 'Push info for new CBO data'
      key :tags, [
        'Organization'
      ]

      security do
        key :BasicAuth, []
      end

      parameter do
        key :name, :null
        key :in, :body
        key :description, 'CBO message data'
        key :required, true
        schema do
          key :'$ref', :CboInput
        end
      end

      response 200 do
        key :description, 'Message received'
        schema do
          property :data do
            key :'$ref', :Cbo
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
