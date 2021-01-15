class Api::V1::Dictionary::RepresentativeTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    representative_types = FeatureType.only_representative_type.order(:name)

    # render json: representative_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: representative_types.count}, status: :ok
    # render json: representative_types, meta: {total_count: representative_types.count}, status: :ok
    render json: representative_types, each_serializer: FeatureTypeSerializer, root: 'representative_types', meta: {total_count: representative_types.count}, status: :ok
  end

  def show
    representative_type = FeatureType.find_by(id: params[:id])

    if representative_type.present?
      # render json: representative_type
      render json: representative_type, serializer: FeatureTypeSerializer, root: 'representative_type' #, meta: {total_count: 1}
      # render json: representative_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found representative_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found representative_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
