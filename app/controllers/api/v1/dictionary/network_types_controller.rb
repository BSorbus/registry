class Api::V1::Dictionary::NetworkTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    network_types = FeatureType.only_network_type.order(:name)

    # render json: network_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: network_types.count}, status: :ok
    # render json: network_types, meta: {total_count: network_types.count}, status: :ok
    render json: network_types, each_serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'network_types', meta: {total_count: network_types.count}, status: :ok
  end

  def show
    network_type = FeatureType.find_by(id: params[:id])

    if network_type.present?
      # render json: network_type
      render json: network_type, serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'network_type' #, meta: {total_count: 1}
      # render json: network_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found network_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found network_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
