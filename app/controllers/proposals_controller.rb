class ProposalsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:datatables_index]
  before_action :set_proposal, only: [:show, :edit, :update, :destroy, 
                                      :edit_to_approved, :edit_to_rejected, :edit_to_annuled, 
                                      :update_to_approved, :update_to_rejected, :update_to_annuled]

  def datatables_index
    respond_to do |format|
      format.json { render json: ProposalDatatable.new(params, view_context: view_context ) }
      # without [active_model_serializers]:
      # format.json { render json: ProposalDatatable.new(params, view_context: view_context ).to_json }
    end
  end

  # GET /proposals
  # GET /proposals.json
  def index
    proposal_authorize(:proposal, "index", params[:service_type])
    respond_to do |format|
      # disable button all/my if current_user not have role organization:index
      # format.html { render :index, locals: {index_in_role: policy(:proposal).index_in_role?} }
      format.html { render :index }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    # authorize @proposal, :show?
    proposal_authorize(@proposal, "show", params[:service_type])
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
    # @proposal.name = params[:proposal][:name].strip if params.dig(:proposal, :name).present? 
    @proposal.service_type = params[:service_type]
    @proposal.proposal_status_id = ProposalStatus::PROPOSAL_STATUS_CREATED
    @proposal.author = current_user
    # authorize @proposal, :new?
    proposal_authorize(@proposal, "new", params[:service_type])
  end

  # GET /proposals/1/edit
  def edit
    # authorize @proposal, :edit?
    proposal_authorize(@proposal, "edit", params[:service_type])
  end

  # GET /proposals/1/edit_approved
  def edit_to_approved
    proposal_authorize(@proposal, "edit_to_approved", params[:service_type])
    # respond_to do |format|
    #   format.html { render :edit_to_approved, locals: { back_url: params[:back_url] } }
    # end
  end

  # GET /proposals/1/edit_rejected
  def edit_to_rejected
    proposal_authorize(@proposal, "edit_to_rejected", params[:service_type])
  end

  # GET /proposals/1/edit_approved
  def edit_to_annuled
    proposal_authorize(@proposal, "edit_to_annuled", params[:service_type])
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(proposal_params)

    proposal_authorize(@proposal, "create", params[:service_type])
    respond_to do |format|
      # must save with transaction with Registry because change Registry status ex. "deletion_pending"
      if @proposal.save_and_change_register_status
        #@proposal.log_work('create', current_user.id)
        format.html { 
          flash[:success] = t('activerecord.successfull.messages.created', data: @proposal.fullname)
          redirect_to @proposal 
        }
        format.json { render :show, status: :created, location: @proposal }
        format.js { render :create }
      else
        format.html { render :new }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /proposals/1
  # PATCH/PUT /proposals/1.json
  def update
    # authorize @proposal, :update?
    proposal_authorize(@proposal, "update", params[:service_type])
    respond_to do |format|
      if @proposal.update(proposal_params)
      # if @proposal.save_and_change_register_status
        #@proposal.log_work('update', current_user.id)
        format.html { 
          flash[:success] = t('activerecord.successfull.messages.updated', data: @proposal.fullname)
          redirect_to proposal_path(params[:service_type], @proposal) 
        }
        format.json { render :show, status: :ok, location: @proposal }
        format.js { render :update }
      else
        format.html { render :edit }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def update_to_approved
    proposal_authorize(@proposal, "update_to_approved", params[:service_type])

    @proposal.attributes = proposal_approved_params

    respond_to do |format|
      if @proposal.save_and_change_register_status
        # @proposal.works.create!(trackable_url: "#{proposal_path(@proposal, category_service: params[:category_service])}", action: :approved, user: current_user, 
        #   parameters: @proposal.to_json(except: {proposal: [:id, :proposal_status_id, :user_id]}, 
        #           include: { 
        #             exam: {
        #               only: [:id, :number, :date_exam, :place_exam] },
        #             proposal_status: {
        #               only: [:id, :name] },
        #             user: {
        #               only: [:id, :name, :email] } 
        #                   }))

        # @proposal.add_to_examinations

        flash[:success] = t('activerecord.successfull.messages.updated', data: @proposal.fullname)

        format.html { redirect_to proposal_path(@proposal, service_type: @proposal.service_type) }
      else
        format.html { render :edit_to_approved }
      end
    end
  end

  def update_to_rejected
    proposal_authorize(@proposal, "update_to_rejected", params[:service_type])
    @proposal.attributes = proposal_rejected_params

    respond_to do |format|
      if @proposal.save_and_change_register_status
        flash[:success] = t('activerecord.successfull.messages.updated', data: @proposal.fullname)
        format.html { redirect_to proposal_path(@proposal, service_type: @proposal.service_type) }
      else
        format.html { render :edit_to_rejected }
      end
    end
  end

  def update_to_annuled
    proposal_authorize(@proposal, "update_to_annuled", params[:service_type])
    @proposal.attributes = proposal_annuled_params

    respond_to do |format|
      if @proposal.save_and_change_register_status
        flash[:success] = t('activerecord.successfull.messages.updated', data: @proposal.fullname)
        format.html { redirect_to proposal_path(@proposal, service_type: @proposal.service_type) }
      else
        format.html { render :edit_to_annuled }
      end
    end
  end




  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    # authorize @proposal, :destroy?
    proposal_authorize(@proposal, "destroy", params[:service_type])
    destroyed_clone = @proposal.clone
    if @proposal.destroy
      #destroyed_clone.log_work('destroy', current_user.id)
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @proposal.fullname)
      redirect_to proposals_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @proposal.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private

    def create_new_and_set_default_attributes
      @proposal = Proposal.new.tap do |rec|
        rec.service_type       = params[:service_type]
        rec.proposal_status_id = ProposalStatus::PROPOSAL_STATUS_CREATED
        rec.author             = current_user
      end
    end


    def proposal_authorize(model_class, action, service_type)
      unless ['j', 'p', 't'].include?(service_type)
         raise "Ruby injection"
      end
      unless ['index', 'show', 'new', 'create', 'edit', 'update', 'destroy', 'print', 'work', 
              'edit_to_approved', 'edit_to_rejected', 'edit_to_annuled', 
              'update_to_approved', 'update_to_rejected', 'update_to_annuled'].include?(action)
         raise "Ruby injection"
      end
      authorize model_class,"#{action}_#{service_type}?"      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposal_params
      defaults = { author_id: "#{current_user.id}", service_type: params[:service_type] }
      params.require(:proposal).permit(:proposal_type_id, :proposal_status_id, :organization_id, :insertion_date, 
        :jst_resolution_date, :jst_resolution_number,
        :jst_providing_networks, :jst_provision_telecom_services, :jst_provision_related_services, :jst_other_telecom_activities, 
        :activity_area_whole_poland, :scheduled_start_date, :scheduled_end_date, :status_comment, :note, :author_id, 
          proposal_networks_attributes: [:id, :network_type_id, :description, :_destroy],
          proposal_services_attributes: [:id, :service_type_id, :description, :only_wholesale, :only_resale, :_destroy],
          proposal_areas_attributes: [:id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name, :_destroy],
          proposal_attachments_attributes: [:id, :attachment_type_id, :attached_pdf_file, :_destroy]
        ).reverse_merge(defaults)
    end

    def proposal_approved_params
      defaults = { author_id: "#{current_user.id}", proposal_status_id: ProposalStatus::PROPOSAL_STATUS_APPROVED }
      params.require(:proposal).permit(:approved_date, :status_comment, :note).reverse_merge(defaults)
    end

    def proposal_rejected_params
      defaults = { author_id: "#{current_user.id}", proposal_status_id: ProposalStatus::PROPOSAL_STATUS_REJECTED }
      params.require(:proposal).permit(:rejected_date, :status_comment, :note).reverse_merge(defaults)
    end

    def proposal_annuled_params
      defaults = { author_id: "#{current_user.id}", proposal_status_id: ProposalStatus::PROPOSAL_STATUS_ANNULLED }
      params.require(:proposal).permit(:annuled_date, :status_comment, :note).reverse_merge(defaults)
    end

end
