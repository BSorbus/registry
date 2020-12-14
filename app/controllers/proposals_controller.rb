class ProposalsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:datatables_index]
  before_action :set_proposal, only: [:show, :edit, :update, :destroy]

  def datatables_index
    respond_to do |format|
      format.json { render json: ProposalDatatable.new(params, view_context: view_context ) }
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
    @proposal.name = params[:proposal][:name].strip if params.dig(:proposal, :name).present? 
    @proposal.service_type = params[:service_type]
    @proposal.proposal_status_id = ProposalStatus::PROPOSAL_STATUS_CREATED
    @proposal.author = current_user
    authorize @proposal, :new?
  end

  # GET /proposals/1/edit
  def edit
    # authorize @proposal, :edit?
    proposal_authorize(@proposal, "edit", params[:service_type])
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(proposal_params)
    # authorize @proposal, :create?
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

    # puts '---------- 1 -----------------------------------------------------------------------------------'
    # puts @proposal.attributes
    # puts '---------- 2 -----------------------------------------------------------------------------------'
    # puts "#{proposal_params}"
    # puts '------------------------------------------------------------------------------------------------'

    # @proposal.assign_attributes( proposal_params )

    # puts '---------- 3 -----------------------------------------------------------------------------------'
    # puts @proposal.attributes
    # puts '------------------------------------------------------------------------------------------------'

    # raise

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
    def proposal_authorize(model_class, action, service_type)
      unless ['j', 'p', 't'].include?(service_type)
         raise "Ruby injection"
      end
      unless ['index', 'show', 'new', 'create', 'edit', 'update', 'destroy', 'print', 'work', 
              'edit_approved', 'edit_not_approved', 'edit_closed', 'update_approved', 'update_not_approved', 'update_closed'].include?(action)
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
      defaults = { author_id: "#{current_user.id}" }
      params.require(:proposal).permit(:service_type, :proposal_type_id, :proposal_status_id, :organization_id, :insertion_date, 
        :activity_area_whole_poland, :scheduled_start_date, :scheduled_end_date, :esod_category, :note, :author_id, 
          proposal_networks_attributes: [:id, :network_type_id, :description, :_destroy,
            proposal_services_attributes: [:id, :service_type_id, :description, :only_wholesale, :only_resale, :_destroy],
          ],
          proposal_areas_attributes: [:id, :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name, :_destroy]
        ).reverse_merge(defaults)
    end

end
