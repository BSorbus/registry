class Api::V1::Dictionary::AttachmentTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    attachment_types = FeatureType.only_attachment_type.order(:name)

    # render json: attachment_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: attachment_types.count}, status: :ok
    # render json: attachment_types, meta: {total_count: attachment_types.count}, status: :ok
    render json: attachment_types, each_serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'attachment_types', meta: {total_count: attachment_types.count}, status: :ok
  end

  def show
    attachment_type = FeatureType.find_by(id: params[:id])

    if attachment_type.present?
      # render json: attachment_type
      render json: attachment_type, serializer: Api::V1::SimpleFeatureTypeSerializer, root: 'attachment_type' #, meta: {total_count: 1}
      # render json: attachment_type, serializer: RegisterSerializer, include: "**"
    else
      # render json: { errors: "Not found attachment_type where id: #{params[:id]}" }, status: :not_found
      render json: { code: 404, message: "Not found attachment_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
