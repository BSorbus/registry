class Api::V1::RegistersController < Api::V1::BaseApiController

  before_action :authenticate_system_param_basic, except: [:index, :show] 
  # before_action :authenticate_system_param_token

  respond_to :json

  def index
    registers = Register.where(service_type: params[:service_type]).order(:register_no)

    render json: registers, each_serializer: Api::V1::RegisterSerializer, include: "**", meta: {total_count: registers.count, service_type: params[:service_type]}, status: :ok
    # render json: registers, meta: {total_count: registers.count, service_type: params[:service_type]}, status: :ok
  end

  def show
    puts '-----------------------------------------------------------------------'
    puts params
    puts '-----------------------------------------------------------------------'

    if is_uuid_format?(params[:id_or_number])
      register = Register.find_by(id: params[:id_or_number])
    else
      register = Register.find_by(service_type: params[:service_type], register_no: params[:id_or_number])
    end

    if register.present?
      # render json: register
      # render json: register, serializer: RegisterSerializer, meta: {total_count: 1}
      # render json: register, serializer: RegisterSerializer, include: "**"
      render json: register
    else
      # render json: { errors: "Not found register where id_or_number: #{params[:id_or_number]}" }, status: :not_found
      render json: { code: 404, message: "Not found register where id: #{params[:id_or_number]}" }, status: :not_found
    end
  end

end
