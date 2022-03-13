class Api::V1::Dictionary::ProposalStatusesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    proposal_statuses = ProposalStatus.order(:id)

    # render json: proposal_statuses, each_serializer: RegisterSerializer, include: "**", meta: {total_count: proposal_statuses.count}, status: :ok
    # render json: proposal_statuses, meta: {total_count: proposal_statuses.count}, status: :ok
    render json: proposal_statuses, each_serializer: Api::V1::ProposalStatusSerializer, root: 'proposal_statuses', meta: {total_count: proposal_statuses.count}, status: :ok
  end

  def show
    proposal_status = ProposalStatus.find_by(id: params[:id])

    if proposal_status.present?
      # render json: proposal_status
      render json: proposal_status, serializer: Api::V1::ProposalStatusSerializer, root: 'proposal_status' #, meta: {total_count: 1}
      # render json: proposal_status, serializer: RegisterSerializer, include: "**"
    else
      render json: { code: 404, message: "Not found proposal_status where id: #{params[:id]}" }, status: :not_found
    end
  end

end
