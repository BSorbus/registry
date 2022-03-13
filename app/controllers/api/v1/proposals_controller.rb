class Api::V1::ProposalsController < Api::V1::BaseApiController

  before_action :authenticate_system_param_basic
  # before_action :authenticate_system_param_token

  respond_to :json

  def create

    case params[:service_type]
    when 'j'
      prop_params = j_proposal_create_params
    when 't'
      prop_params = t_proposal_create_params
    else
      return render json: { code: 404, message: "Not found service_type: #{params[:service_type]}" }, status: :not_found
    end


    puts '-----------------------------------------------------------------------'
    # puts params
    puts 'prop_params:'
    puts prop_params
    puts '-----------------------------------------------------------------------'

            # proposal = Proposal.where(service_type: params[:service_type]).last
            # # render json: proposal, status: :created
            # render json: proposal, serializer: Api::V1::ProposalSerializer, include: "**", meta: {total_count: 1, service_type: params[:service_type]}, status: :created

    # render json: { code: 201, message: "succesfull recived for cbo_new_data_service: id:#{params[:id]}), typ:#{params[:typ]}, source:#{params[:source]}" }, status: :ok
    # render json: { code: 200, message: "succesfull recived for cbo_new_data_service: id:#{params[:id]}), typ:#{params[:typ]}, source:#{params[:source]}" }, status: :ok


    proposal = Proposal.new(prop_params)
    # must save with transaction with Registry because change Registry status ex. "deletion_pending"
    if proposal.save_and_change_register_status
      # render :show, status: :created, location: @proposal 
      render json: proposal, serializer: Api::V1::ProposalSerializer, include: "**", meta: {total_count: 1, service_type: params[:service_type]}, status: :created
    else
      # render json: proposal.errors, status: :unprocessable_entity
      render json: { code: 422, message: "#{proposal.errors.full_messages}" }, status: :unprocessable_entity
    end

  end  


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    # def proposal_params
    #   defaults = { author_id: "#{current_user.id}", service_type: params[:service_type] }
    #   params.require(:proposal).permit(:proposal_type_id, :proposal_status_id, :organization_id, :insertion_date, 
    #     :jst_resolution_date, :jst_resolution_number,
    #     :jst_providing_networks, :jst_provision_telecom_services, :jst_provision_related_services, :jst_other_telecom_activities, 
    #     :activity_area_whole_poland, :scheduled_start_date, :scheduled_end_date, :status_comment, :note, :author_id, 
    #       proposal_networks_attributes: [:id, :network_type_id, :description, :_destroy],
    #       proposal_services_attributes: [:id, :service_type_id, :description, :only_wholesale, :only_resale, :_destroy],
    #       proposal_areas_attributes: [:id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name, :_destroy],
    #       proposal_attachments_attributes: [:id, :attachment_type_id, :attached_pdf_file, :_destroy]
    #     ).reverse_merge(defaults)
    # end

    def j_proposal_create_params
      # defaults = { author_id: "#{current_user.id}", service_type: params[:service_type] }
      defaults = {service_type: params[:service_type],
                  proposal_status_id: ProposalStatus::PROPOSAL_STATUS_CREATED, 
                  register_id: prepare_register(params.fetch(:proposal, {})), 
                  author_id: prepare_author(params.fetch(:proposal, {})) }
      params.require(:proposal).permit(:proposal_type_id, :organization_id, :register_id, :insertion_date, 
        :jst_resolution_date, :jst_resolution_number,
        :jst_providing_networks, :jst_provision_telecom_services, :jst_provision_related_services, :jst_other_telecom_activities, 
        :activity_area_whole_poland, :scheduled_start_date, :scheduled_end_date, :status_comment, :note, :author_id, 
          proposal_areas_attributes: [:id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name, :_destroy],
          proposal_attachments_attributes: [:id, :attachment_type_id, :attached_pdf_file, :_destroy]
        ).merge(defaults)
    end

    def t_proposal_create_params
      # defaults = { author_id: "#{current_user.id}", service_type: params[:service_type] }
      # params.require(:proposal).permit(:proposal_type_id, :proposal_status_id, :organization_id, :insertion_date, 
      #   :activity_area_whole_poland, :scheduled_start_date, :scheduled_end_date, :status_comment, :note, :author_id, 
      #     proposal_networks_attributes: [:id, :network_type_id, :description, :_destroy],
      #     proposal_services_attributes: [:id, :service_type_id, :description, :only_wholesale, :only_resale, :_destroy],
      #     proposal_areas_attributes: [:id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name, :_destroy],
      #     proposal_attachments_attributes: [:id, :attachment_type_id, :attached_pdf_file, :_destroy]
      #   ).reverse_merge(defaults)
    end

    def prepare_author(proposal_params)
      @api_user = User.order(:created_at).first
      PaperTrail.request.whodunnit = @api_user.id

      param_author_id = proposal_params.fetch(:author_id, nil)
      if param_author_id.present?
        user = User.find_by(email: param_author_id) 
        user = User.create(email: param_author_id, author: @api_user) unless user.present?

        if user.present?
          @api_user = user
          PaperTrail.request.whodunnit = @api_user.id
          return @api_user.id
        else
          return nil
        end
      end 
    end

    def prepare_register(proposal_params)
      (proposal_params.fetch(:proposal_type_id) == ProposalType::PROPOSAL_TYPE_REGISTRATION) ?  nil : proposal_params.fetch(:register_id)
    end

end
