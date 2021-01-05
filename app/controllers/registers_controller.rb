class RegistersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:datatables_index, :ajax_load_proposals]
  before_action :set_register, only: [:show, :edit, :update, :destroy, :ajax_load_proposals]

  def ajax_load_proposals
    @proposals = @register.proposals.joins(:proposal_type, :proposal_status)
                  .references(:proposal_type, :proposal_status).order(insertion_date: :asc).all

    respond_to do |format|
      format.js  { render "ajax_load_proposals", status: :ok }
    end

  end

  def datatables_index
    respond_to do |format|
      format.json { render json: RegisterDatatable.new(params, view_context: view_context ) }
    end
  end

  # GET /registers
  # GET /registers.json
  def index
    register_authorize(:register, "index", params[:service_type])
    respond_to do |format|
      # disable button all/my if current_user not have role organization:index
      # format.html { render :index, locals: {index_in_role: policy(:register).index_in_role?} }
      format.html { render :index }
    end
  end

  def select2_index
    register_authorize(:register, "index", params[:service_type])
    params[:q] = params[:q]
    @registers = Register.includes(:organization, :proposal_registration_approved).references(:organization)
      .where(service_type: params[:service_type], register_status_id: RegisterStatus::REGISTER_STATUS_CURRENT)
      .finder_register(params[:q]).order(:register_no)
    @registers_on_page = @registers.page(params[:page]).per(params[:page_limit])
    
  #   render json: { 
  #     registers: @registers_on_page.as_json(methods: :fullname, only: [:id, :fullname, :register_no, :service_type]),
  #     meta: { total_count: @registers.count }  
  #   } 

    respond_to do |format|
      format.json {
        render json: { 
          registers: JSON.parse(@registers_on_page.to_json(
            only: [:id, :register_no, :service_type],
            include: {
              organization: {methods: :fullname, only: [:id, :fullname, :name, :nip]},
              proposal_registration_approved: {methods: :fullname, only: [:id, :fullname, :approved_date]}
            }
          )),
          meta: { total_count: @registers.count }  
        } 
      }
    end
  end

  # GET /registers/1
  # GET /registers/1.json
  def show
    #authorize @register, :show?
    register_authorize(@register, "show", params[:service_type])

    respond_to do |format|
      format.html { render :show }
      format.json {
        render json: JSON.parse(@register.to_json(
          only: [:id, :register_no, :service_type],
          include: {
            organization: {methods: :fullname, only: [:id, :fullname, :name, :nip]},
            proposal_registration_approved: {methods: :fullname, only: [:id, :fullname, :approved_date]}
          }
        ))
      } 
    end
  end

  # GET /registers/new
  def new
    @register = Register.new
    @register.name = params[:register][:name].strip if params.dig(:register, :name).present? 
    @register.author = current_user
    authorize @register, :new?
  end

  # GET /registers/1/edit
  def edit
    authorize @register, :edit?
  end

  # POST /registers
  # POST /registers.json
  def create
    @register = Register.new(register_params)
    authorize @register, :create?
    respond_to do |format|
      if @register.save
        @register.log_work('create', current_user.id)
        format.html { 
          flash[:success] = t('activerecord.successfull.messages.created', data: @register.fullname)
          redirect_to @register 
        }
        format.json { render :show, status: :created, location: @register }
        format.js { render :create }
      else
        format.html { render :new }
        format.json { render json: @register.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /registers/1
  # PATCH/PUT /registers/1.json
  def update
    authorize @register, :update?
    respond_to do |format|
      # if @register.update(name: params[:register][:name], note: params[:register][:note], special: params[:register][:special],activities: params[:register][:activities].split)
      if @register.update(register_params)
        @register.log_work('update', current_user.id)
        format.html { 
          flash[:success] = t('activerecord.successfull.messages.updated', data: @register.fullname)
          redirect_to @register 
        }
        format.json { render :show, status: :ok, location: @register }
        format.js { render :update }
      else
        format.html { render :edit }
        format.json { render json: @register.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /registers/1
  # DELETE /registers/1.json
  def destroy
    authorize @register, :destroy?
    destroyed_clone = @register.clone
    if @register.destroy
      destroyed_clone.log_work('destroy', current_user.id)
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @register.fullname)
      redirect_to registers_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @register.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    def register_authorize(model_class, action, service_type)
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
    def set_register
      @register = Register.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def register_params
      defaults = { author_id: "#{current_user.id}" }
      params.require(:register).permit(:name, :note, :author_id).reverse_merge(defaults)
    end

end
