class Api::V1::Dictionary::LegalFormTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    legal_form_types = FeatureType.only_legal_form_type.order(:name)

    # render json: legal_form_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: legal_form_types.count}, status: :ok
    # render json: legal_form_types, meta: {total_count: legal_form_types.count}, status: :ok
    render json: legal_form_types, each_serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'legal_form_types', meta: {total_count: legal_form_types.count}, status: :ok
  end

  def show
    legal_form_type = FeatureType.find_by(id: params[:id])

    if legal_form_type.present?
      # render json: legal_form_type
      render json: legal_form_type, serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'legal_form_type' #, meta: {total_count: 1}
      # render json: legal_form_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found legal_form_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found legal_for_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
