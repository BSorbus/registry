class Api::V1::OrganizationsController < Api::V1::BaseApiController

  before_action :authenticate_system_param_basic
  # before_action :authenticate_system_param_token

  respond_to :json

  def cbo_new_data_service
    render json: { message: "cbo_new_data_service: OK for id:#{params[:id]}), typ:#{params[:typ]}, source:#{params[:source]}" }, status: :ok
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:organization_status_id, :not_approved_comment )
    end

end
