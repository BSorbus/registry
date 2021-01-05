class ProposalCandidatesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized


  def create
    create_new_and_set_default_attributes
    proposal_candidate_authorize(@proposal_candidate, "create", params[:service_type])
    @proposal_candidate.save(validate: false)

    # redirect_to proposal_wizard_path(@proposal, id: Proposal.form_steps.first)  
    redirect_to proposal_candidate_wizard_path(service_type: @proposal_candidate.service_type, proposal_candidate_id: @proposal_candidate.id, id: ProposalCandidate.form_steps.first )  
  end

  private

    def create_new_and_set_default_attributes
      @proposal_candidate = ProposalCandidate.new.tap do |rec|
        rec.service_type       = params[:service_type]
        rec.proposal_status_id = ProposalStatus::PROPOSAL_STATUS_CREATED
        rec.insertion_date     = Time.zone.today
        rec.author             = current_user
      end
    end

    def proposal_candidate_authorize(model_class, action, service_type)
      unless ['j', 'p', 't'].include?(service_type)
         raise "Ruby injection service_type: #{service_type}"
      end
      unless ['create'].include?(action)
         raise "Ruby injection action: #{action}"
      end
      authorize model_class,"#{action}_#{service_type}?", policy_class: ProposalPolicy
    end

end
