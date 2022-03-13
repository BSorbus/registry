class Api::V1::Dictionary::ServiceTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    service_types = FeatureType.only_service_type.order(:name)

    # render json: service_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: service_types.count}, status: :ok
    # render json: service_types, meta: {total_count: service_types.count}, status: :ok
    render json: service_types, each_serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'service_types', meta: {total_count: service_types.count}, status: :ok
  end

  def show
    service_type = FeatureType.find_by(id: params[:id])

    if service_type.present?
      # render json: service_type
      render json: service_type, serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'service_type' #, meta: {total_count: 1}
      # render json: service_type, serializer: RegisterSerializer, include: "**"
    else
      render json: { code: 404, message: "Not found service_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
