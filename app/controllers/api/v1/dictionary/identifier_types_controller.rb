class Api::V1::Dictionary::IdentifierTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    identifier_types = FeatureType.only_identifier_type.order(:name)

    # render json: identifier_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: identifier_types.count}, status: :ok
    # render json: identifier_types, meta: {total_count: identifier_types.count}, status: :ok
    render json: identifier_types, each_serializer: FeatureTypeSerializer, root: 'identifier_types', meta: {total_count: identifier_types.count}, status: :ok
  end

  def show
    identifier_type = FeatureType.find_by(id: params[:id])

    if identifier_type.present?
      # render json: identifier_type
      render json: identifier_type, serializer: FeatureTypeSerializer, root: 'identifier_type' #, meta: {total_count: 1}
      # render json: identifier_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found identifier_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found identifier_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
