# frozen_string_literal: true

class Api::V1::ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'

    info do
      key :version, '1.0.0'
      key :title, 'UKE Register API'
      key :description, 'UKE Register API documentation'

      contact do
        key :name, 'http://www.uke.gov.pl'
      end
    end

    key :host, 'localhost:3000'
    # key :host, 'registry-test.uke.gov.pl'
    key :basePath, '/api/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    key :schemes,  ['http']
    # key :schemes,  ['https']

    security_definition :BasicAuth do
      key :type, :basic
      # key :scheme, :ProposalInput
    end

    # security_definition :basic_auth do
    #   key :type, :basic
    #   # key :scheme, :ProposalInput
    # end


  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::Swagger::Controllers::AddressExtTypesController,
    Api::V1::Swagger::Controllers::AddressTypesController,
    Api::V1::Swagger::Controllers::IdentifierTypesController,
    Api::V1::Swagger::Controllers::JstLegalFormTypesController,
    Api::V1::Swagger::Controllers::LegalFormTypesController,
    Api::V1::Swagger::Controllers::NetworkTypesController,
    Api::V1::Swagger::Controllers::ProposalsController,
    Api::V1::Swagger::Controllers::ProposalStatusesController,
    Api::V1::Swagger::Controllers::ProposalTypesController,
    Api::V1::Swagger::Controllers::RegisterStatusesController,
    Api::V1::Swagger::Controllers::RegistersController,
    Api::V1::Swagger::Controllers::RepresentativeTypesController,
    Api::V1::Swagger::Controllers::ServiceTypesController,

    Api::V1::Swagger::Controllers::OrganizationsController,
    Api::V1::Swagger::Models::Cbo,
    Api::V1::Swagger::Models::CboInput,

    Api::V1::Swagger::Models::ErrorModel,
    # Api::V1::Swagger::Models::FeatureType,
    Api::V1::Swagger::Models::Area,
    Api::V1::Swagger::Models::AreaInput,
    Api::V1::Swagger::Models::AddressExtType,
    Api::V1::Swagger::Models::AddressType,
    Api::V1::Swagger::Models::IdentifierType,
    Api::V1::Swagger::Models::JstLegalFormType,
    Api::V1::Swagger::Models::LegalFormType,
    Api::V1::Swagger::Models::NetworkType,
    Api::V1::Swagger::Models::Proposal,
    Api::V1::Swagger::Models::ProposalInput,
    Api::V1::Swagger::Models::ProposalStatus,
    Api::V1::Swagger::Models::ProposalType,
    Api::V1::Swagger::Models::RegisterStatus,
    Api::V1::Swagger::Models::Register,
    Api::V1::Swagger::Models::ServiceType,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end