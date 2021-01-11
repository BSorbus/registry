class ProposalPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index_j?
    user_activities.include?('proposal_j:index')
  end

  def show_j?
    user_activities.include?('proposal_j:show')
  end

  def new_j?
    create_j?
  end

  def create_j?
    user_activities.include?('proposal_j:create')
  end

  def edit_j?
    update_j?
  end

  def edit_to_approved_j?
    update_to_approved_j?
  end

  def edit_to_rejected_j?
    update_to_rejected_j?
  end

  def edit_to_annuled_j?
    update_to_annuled_j?
  end

  def update_j?
    @model.can_update? && user_activities.include?('proposal_j:update')
  end

  def update_to_approved_j?
    @model.can_approve? && user_activities.include?('proposal_j:approve')
  end

  def update_to_rejected_j?
    @model.can_reject? && user_activities.include?('proposal_j:reject')
  end

  def update_to_annuled_j?
    @model.can_annul? && user_activities.include?('proposal_j:reject')
  end

  def destroy_j?
    @model.can_delete? && user_activities.include?('proposal_j:delete')
  end
 
  def work_j?
    user_activities.include?('proposal_j:work') || user_activities.include?('all:work')
  end

  def version_j?
    user_activities.include?('proposal_j:work') || user_activities.include?('all:work')
  end

  #########################################################

  def index_p?
    user_activities.include?('proposal_p:index')
  end

  def show_p?
    user_activities.include?('proposal_p:show')
  end

  def new_p?
    create_p?
  end

  def create_p?
    user_activities.include?('proposal_p:create')
  end

  def edit_p?
    update_p?
  end

  def edit_to_approved_p?
    update_to_approved_p?
  end

  def edit_to_rejected_p?
    update_to_rejected_p?
  end

  def edit_to_annuled_p?
    update_to_annuled_p?
  end

  def update_p?
    @model.can_update? && user_activities.include?('proposal_p:update')
  end

  def update_to_approved_p?
    @model.can_approve? && user_activities.include?('proposal_p:approve')
  end

  def update_to_rejected_p?
    @model.can_reject? && user_activities.include?('proposal_p:reject')
  end

  def update_to_annuled_p?
    @model.can_annul? && user_activities.include?('proposal_p:reject')
  end

  def destroy_p?
    @model.can_delete? && user_activities.include?('proposal_p:delete')
  end
 
  def work_p?
    user_activities.include?('proposal_p:work') || user_activities.include?('all:work')
  end

  def version_p?
    user_activities.include?('proposal_p:work') || user_activities.include?('all:work')
  end

  #########################################################

  def index_t?
    user_activities.include?('proposal_t:index')
  end

  def show_t?
    user_activities.include?('proposal_t:show')
  end

  def new_t?
    create_t?
  end

  def create_t?
    user_activities.include?('proposal_t:create')
  end

  def edit_t?
    update_t?
  end

  def edit_to_approved_t?
    update_to_approved_t?
  end

  def edit_to_rejected_t?
    update_to_rejected_t?
  end

  def edit_to_annuled_t?
    update_to_annuled_t?
  end

  def update_t?
    @model.can_update? && user_activities.include?('proposal_t:update')
  end

  def update_to_approved_t?
    @model.can_approve? && user_activities.include?('proposal_t:approve')
  end

  def update_to_rejected_t?
    @model.can_reject? && user_activities.include?('proposal_t:reject')
  end

  def update_to_annuled_t?
    @model.can_annul? && user_activities.include?('proposal_t:reject')
  end

  def destroy_t?
    @model.can_delete? && user_activities.include?('proposal_t:delete')
  end
 
  def work_t?
    user_activities.include?('proposal_t:work') || user_activities.include?('all:work')
  end

  def version_t?
    user_activities.include?('proposal_t:work') || user_activities.include?('all:work')
  end

  class Scope < Scope
    def resolve
      if user_activities.include? 'proposal_j:index'
        scope.where.not(id: nil).all
      else
        scope.where(id: nil)
      end
    end
  end
end