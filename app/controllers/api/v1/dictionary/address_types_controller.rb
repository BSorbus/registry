class Api::V1::Dictionary::AddressTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    address_types = FeatureType.only_address_type.order(:name)

    # render json: address_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: address_types.count}, status: :ok
    # render json: address_types, meta: {total_count: address_types.count}, status: :ok
    render json: address_types, each_serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'address_types', meta: {total_count: address_types.count}, status: :ok
  end

  def show
    address_type = FeatureType.find_by(id: params[:id])

    if address_type.present?
      # render json: address_type
      render json: address_type, serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'address_type' #, meta: {total_count: 1}
      # render json: address_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found address_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found address_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
