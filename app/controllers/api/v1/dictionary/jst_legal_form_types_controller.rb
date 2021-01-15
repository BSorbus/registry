class Api::V1::Dictionary::JstLegalFormTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    jst_legal_form_types = FeatureType.only_jst_legal_form_type.order(:name)

    # render json: jst_legal_form_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: jst_legal_form_types.count}, status: :ok
    # render json: jst_legal_form_types, meta: {total_count: jst_legal_form_types.count}, status: :ok
    render json: jst_legal_form_types, each_serializer: SimpleFeatureTypeSerializer, root: 'jst_legal_form_types', meta: {total_count: jst_legal_form_types.count}, status: :ok
  end

  def show
    jst_legal_form_type = FeatureType.find_by(id: params[:id])

    if jst_legal_form_type.present?
      # render json: jst_legal_form_type
      render json: jst_legal_form_type, serializer: SimpleFeatureTypeSerializer, root: 'jst_legal_form_type' #, meta: {total_count: 1}
      # render json: jst_legal_form_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found jst_legal_form_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found jst_legal_form_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
