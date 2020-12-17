class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :datatables_index, :ajax_load_proposals, :ajax_load_registers]
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :ajax_load_proposals, :ajax_load_registers]

  def ajax_load_proposals
    @proposals = @organization.proposals.joins(:proposal_type, :proposal_status, :organization)
                  .references(:proposal_type, :proposal_status).where(service_type: params[:service_type]).all
    respond_to do |format|
      # format.js  { render status: :ok, file: '/organizations/ajax_load_proposals.js.erb' }
      format.js  { render "ajax_load_proposals_#{params[:service_type]}", status: :ok }
    end 
  end

  def ajax_load_registers
    @registers = @organization.registers.joins(:register_status, :organization)
                  .references(:register_status).where(service_type: params[:service_type]).all
    respond_to do |format|
      format.js  { render "ajax_load_registers_#{params[:service_type]}", status: :ok }
    end 
  end

  def datatables_index
    respond_to do |format|
      format.json { render json: OrganizationDatatable.new(params, view_context: view_context ) }
    end
  end

  def index
    authorize :organization, :index?
    respond_to do |format|
      # disable button all/my if current_user not have role organization:index
      # format.html { render :index, locals: {index_in_role: policy(:organization).index_in_role?} }
      format.html { render :index }
    end
  end

  def select2_index
    authorize :organization, :index?
    params[:q] = params[:q]
    @organizations = Organization.order(:name).finder_organization(params[:q])
    @organizations_on_page = @organizations.page(params[:page]).per(params[:page_limit])
    
    render json: { 
      organizations: @organizations_on_page.as_json(methods: :fullname, only: [:id, :fullname, :name, :nip, :jointly_identifiers]),
      meta: { total_count: @organizations.count }  
    } 
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize @organization, :show?
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @organization.name = params[:organization][:name].strip if params.dig(:organization, :name).present? 
    @organization.author = current_user
    authorize @organization, :new?
  end

  # GET /organizations/1/edit
  def edit
    authorize @organization, :edit?
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    authorize @organization, :create?
    respond_to do |format|
      if @organization.save
        @organization.log_work('create', current_user.id)
        format.html { 
          flash[:success] = t('activerecord.successfull.messages.created', data: @organization.fullname)
          redirect_to @organization 
        }
        format.json { render :show, status: :created, location: @organization }
        format.js { render :create }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    authorize @organization, :update?
    respond_to do |format|
      if @organization.update(organization_params)
        @organization.log_work('update', current_user.id)
        format.html { 
          flash[:success] = t('activerecord.successfull.messages.updated', data: @organization.fullname)
          redirect_to @organization 
        }
        format.json { render :show, status: :ok, location: @organization }
        format.js { render :update }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    authorize @organization, :destroy?
    destroyed_clone = @organization.clone
    if @organization.destroy
      destroyed_clone.log_work('destroy', current_user.id)
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @organization.fullname)
      redirect_to organizations_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @organization.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      defaults = { author_id: "#{current_user.id}" }
      params.require(:organization).permit(:name, :legal_form_type_id, :jst_legal_form_type_id, :jst_teryt, :nip, :note, :author_id,
        features_attributes: [:id, :feature_type_id, :feature_value, :_destroy],
        addresses_attributes: [ :id, :address_type_id, :country_code, :address_combine_id, 
          :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name,
          :city_code, :city_name, :parent_city_code, :parent_city_name, :street_code, :street_name, :street_attribute,
          :address_house, :address_number, :address_postal_code, :_destroy],
        representatives_attributes: [ :id, :representative_type_id, :first_name, :last_name, :note, :_destroy, 
          features_attributes: [:id, :feature_type_id, :feature_value, :_destroy],
          addresses_attributes: [ :id, :address_type_id, :country_code, :address_combine_id, 
            :province_code, :province_name, :district_code, :district_name, :commune_code, :commune_name,
            :city_code, :city_name, :parent_city_code, :parent_city_name, :street_code, :street_name, :street_attribute,
            :address_house, :address_number, :address_postal_code, :_destroy]
          ]
        ).reverse_merge(defaults)
    end

end
