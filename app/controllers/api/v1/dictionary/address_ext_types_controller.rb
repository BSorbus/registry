class Api::V1::Dictionary::AddressExtTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    address_ext_types = FeatureType.only_address_ext_type.order(:name)

    # render json: address_ext_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: address_ext_types.count}, status: :ok
    # render json: address_ext_types, meta: {total_count: address_ext_types.count}, status: :ok
    render json: address_ext_types, each_serializer: FeatureTypeSerializer, root: 'address_ext_types', meta: {total_count: address_ext_types.count}, status: :ok
  end

  def show
    address_ext_type = FeatureType.find_by(id: params[:id])

    if address_ext_type.present?
      # render json: address_ext_type
      render json: address_ext_type, serializer: FeatureTypeSerializer, root: 'address_ext_type' #, meta: {total_count: 1}
      # render json: address_ext_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found address_ext_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found address_ext_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
