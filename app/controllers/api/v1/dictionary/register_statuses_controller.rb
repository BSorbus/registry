class Api::V1::Dictionary::RegisterStatusesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    register_statuses = RegisterStatus.order(:id)

    # render json: register_statuses, each_serializer: RegisterSerializer, include: "**", meta: {total_count: register_statuses.count}, status: :ok
    # render json: register_statuses, meta: {total_count: register_statuses.count}, status: :ok
    render json: register_statuses, each_serializer: Api::V1::RegisterStatusSerializer, root: 'register_statuses', meta: {total_count: register_statuses.count}, status: :ok
  end

  def show
    register_status = RegisterStatus.find_by(id: params[:id])

    if register_status.present?
      # render json: register_status
      render json: register_status, serializer: Api::V1::RegisterStatusSerializer, root: 'register_status' #, meta: {total_count: 1}
      # render json: register_status, serializer: RegisterSerializer, include: "**"
    else
      render json: { code: 404, message: "Not found register_status where id: #{params[:id]}" }, status: :not_found
    end
  end

end
