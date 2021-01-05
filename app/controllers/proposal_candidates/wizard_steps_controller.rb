class ProposalCandidates::WizardStepsController < ApplicationController
  include ProposalsHelper
  include Wicked::Wizard

  before_action :authenticate_user!
  after_action :verify_authorized

  respond_to :html

  steps *ProposalCandidate.form_steps
  
  def show
    @proposal_candidate = ProposalCandidate.find(params[:proposal_candidate_id])
    proposal_candidate_wizard_authorize(@proposal_candidate, "create", @proposal_candidate.service_type)

    case step.to_s
    when 'step3'
      if [ProposalType::PROPOSAL_TYPE_DELETION, ProposalType::PROPOSAL_TYPE_CERTIFICATE].include?(@proposal_candidate.proposal_type_id)
        skip_step
      end
    when 'step4'
      if [ProposalType::PROPOSAL_TYPE_DELETION, ProposalType::PROPOSAL_TYPE_CERTIFICATE].include?(@proposal_candidate.proposal_type_id)
        skip_step
      end
    when 'step5'
      if [ProposalType::PROPOSAL_TYPE_DELETION, ProposalType::PROPOSAL_TYPE_CERTIFICATE].include?(@proposal_candidate.proposal_type_id)
        skip_step
      end
    end
    render_wizard
  end

  def update
    @proposal_candidate = ProposalCandidate.find(params[:proposal_candidate_id])
    proposal_candidate_wizard_authorize(@proposal_candidate, "create", @proposal_candidate.service_type)

    params[:proposal_candidate][:wizard_saved_step] = step.to_s
    unless step == steps.last
      if step.to_s == "step2" 
        params[:proposal_candidate][:register_id] = nil if params[:proposal_candidate][:organization_id].present?
        params[:proposal_candidate][:organization_id] = Register.find(params[:proposal_candidate][:register_id]).organization_id if params[:proposal_candidate][:register_id].present? 
      end

      # save data:
      if @proposal_candidate.update(proposal_candidate_params(step))
        if step.to_s == "step2" &&
          source_proposal_object = proposal_source_object()
          if source_proposal_object.present?
            set_basic_date(source_proposal_object)
          # unless [ProposalType::PROPOSAL_TYPE_DELETION, ProposalType::PROPOSAL_TYPE_CERTIFICATE].include?(@proposal_candidate.proposal_type_id)
            set_jst_networks_and_services(source_proposal_object)
            set_networks(source_proposal_object)
            set_services(source_proposal_object) 
            set_areas(source_proposal_object)
            set_attachments(source_proposal_object)
          # end
          end
        end
      end
      render_wizard @proposal_candidate
    else
      # @proposal_candidate.update(proposal_candidate_params(step))
      if @proposal_candidate.set_last_step_and_create_proposal(proposal_candidate_params(step))
        puts '----------------------------------------------------------------------'  
        puts 'set_last_step_and_create_proposal(proposal_candidate_params(step)) = true'
        puts 'render_wizard @proposal_candidate'
        puts '----------------------------------------------------------------------'  
        render_wizard @proposal_candidate

        # puts '----------------------------------------------------------------------'  
        # puts 'redirect_to_finish_wizard'
        # puts '----------------------------------------------------------------------'  
        # redirect_to_finish_wizard
      else
        puts '----------------------------------------------------------------------'  
        puts 'set_last_step_and_create_proposal(proposal_candidate_params(step)) = false'
        puts 'render_wizard'
        puts '----------------------------------------------------------------------'  
        render_wizard
      end
    end
  end

  private

    def proposal_candidate_wizard_authorize(model_class, action, service_type)
      unless ['j', 'p', 't'].include?(service_type)
         raise "Ruby injection service_type: #{service_type}"
      end
      unless ['create'].include?(action)
         raise "Ruby injection action: #{action}"
      end
      # authorize model_class,"#{action}_#{service_type}?", policy_class: ProposalPolicy
      # always action as 'create'!!!
      authorize model_class,"create_#{service_type}?", policy_class: ProposalPolicy
    end

    def proposal_source_object
      if @proposal_candidate.register_id.present?
        if @proposal_candidate.register.proposal_current_approved.present?
          return @proposal_candidate.register.proposal_current_approved
        else 
          return @proposal_candidate.register.proposal_registration_approved
        end
      end
    end      

    def set_basic_date(source_proposal)
      if source_proposal.present?
        @proposal_candidate.scheduled_start_date = source_proposal.scheduled_start_date
        @proposal_candidate.scheduled_end_date   = source_proposal.scheduled_end_date
        @proposal_candidate.note                 = source_proposal.note
      end      
    end      

    def set_jst_networks_and_services(source_proposal)
      if source_proposal.present?
        @proposal_candidate.jst_providing_networks         = source_proposal.jst_providing_networks
        @proposal_candidate.jst_provision_telecom_services = source_proposal.jst_provision_telecom_services 
        @proposal_candidate.jst_provision_related_services = source_proposal.jst_provision_related_services
        @proposal_candidate.jst_other_telecom_activities   = source_proposal.jst_other_telecom_activities
      end      
    end      

    def set_networks(source_proposal)
      if source_proposal.present?
        @proposal_candidate.proposal_networks.destroy_all
        # via build array method:
        # networks_array = []
        # source_proposal.proposal_networks.each do |row|
        #   networks_array.push( { network_type_id: row.network_type_id, description: row.description } )
        # end
        # @proposal_candidate.proposal_networks.build(networks_array)
        # or:
        source_proposal.proposal_networks.each do |row|
          @proposal_candidate.proposal_networks.create( { network_type_id: row.network_type_id, description: row.description } )
        end
      end
    end      

    def set_services(source_proposal)
      if source_proposal.present?
        @proposal_candidate.proposal_services.destroy_all
        source_proposal.proposal_services.each do |row|
          @proposal_candidate.proposal_services.create( { service_type_id: row.service_type_id, description: row.description, only_wholesale: row.only_wholesale, only_resale: row.only_resale } )
        end
      end
    end

    def set_areas(source_proposal)
      if source_proposal.present?
        @proposal_candidate.activity_area_whole_poland = source_proposal.activity_area_whole_poland
        @proposal_candidate.proposal_areas.destroy_all
        source_proposal.proposal_areas.each do |row|
          @proposal_candidate.proposal_areas.create( { province_code: row.province_code, province_name: row.province_name, 
                                                       district_code: row.district_code, district_name: row.district_name,
                                                       commune_code: row.commune_code, commune_name: row.commune_name } )
        end
      end
    end

    def set_attachments(source_proposal)
      if source_proposal.present?
        @proposal_candidate.proposal_attachments.destroy_all
        source_proposal.proposal_attachments.each do |row|
          @proposal_candidate.proposal_attachments.new( { attachment_type_id: row.attachment_type_id } ).tap do |destination_row|
            destination_row.attached_pdf_file.attach(
              io: StringIO.new(row.attached_pdf_file.download),
              filename: row.attached_pdf_file.filename.to_s,
              content_type: row.attached_pdf_file.content_type
            )
            destination_row.save!
          end
        end
      end
    end

    def finish_wizard_path
      flash[:success] = t('activerecord.successfull.messages.created', data: @proposal_candidate.fullname)
      # proposals_path
      proposal_path(@proposal_candidate.proposal.service_type, @proposal_candidate.proposal)
    end

    def proposal_candidate_params(step)
      permitted_attributes = case step
        when "step1"
          [ :wizard_saved_step, :insertion_date, :proposal_type_id ]
        when "step2"
          [ :wizard_saved_step, :organization_id, :register_id ]
        when "step3"
          [ :wizard_saved_step, :jst_date_of_adopting_the_resolution_date, :jst_resolution_number,
            :jst_providing_networks, :jst_provision_telecom_services, :jst_provision_related_services, :jst_other_telecom_activities, 
              proposal_networks_attributes: [ :id, :network_type_id, :description, :_destroy ],
              proposal_services_attributes: [ :id, :service_type_id, :description, :only_wholesale, :only_resale, :_destroy ]
          ]
        when "step4"
          [ :wizard_saved_step, :activity_area_whole_poland,
              proposal_areas_attributes: [ :id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name, :_destroy ]
          ]
        when "step5"
          [ :wizard_saved_step,
              proposal_attachments_attributes: [ :id, :attachment_type_id, :attached_pdf_file, :_destroy ]
          ]
        when "step6"
          [ :wizard_saved_step, :scheduled_start_date, :scheduled_end_date, :note ]
      end

      params.require(:proposal_candidate).permit(permitted_attributes).merge(form_step: step)
    end

end
