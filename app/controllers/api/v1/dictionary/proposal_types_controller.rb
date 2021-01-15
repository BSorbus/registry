class Api::V1::Dictionary::ProposalTypesController < Api::V1::BaseApiController

  # before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    proposal_types = ProposalType.order(:id)

    # render json: proposal_types, each_serializer: RegisterSerializer, include: "**", meta: {total_count: proposal_types.count}, status: :ok
    # render json: proposal_types, meta: {total_count: proposal_types.count}, status: :ok
    render json: proposal_types, each_serializer: ProposalTypeSerializer, root: 'proposal_types', meta: {total_count: proposal_types.count}, status: :ok
  end

  def show
    proposal_type = ProposalType.find_by(id: params[:id])

    if proposal_type.present?
      # render json: proposal_type
      render json: proposal_type, serializer: ProposalTypeSerializer, root: 'proposal_type' #, meta: {total_count: 1}
      # render json: proposal_type, serializer: RegisterSerializer, include: "**"
    else
      render json: { code: 404, message: "Not found proposal_type where id: #{params[:id]}" }, status: :not_found
    end
  end

end
