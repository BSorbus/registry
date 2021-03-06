class RegisterPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index_j?
    user_activities.include?('register_j:index')
  end

  def show_j?
    user_activities.include?('register_j:show')
  end

  def new_j?
    create?
  end

  def create_j?
    user_activities.include?('register_j:create')
  end

  def edit_j?
    update_j?
  end

  def update_j?
    user_activities.include?('register_j:update')
  end

  def destroy_j?
    user_activities.include?('register_j:delete')
  end
 
  def work_j?
    user_activities.include?('register_j:work') || user_activities.include?('all:work')
  end

  def version_j?
    user_activities.include?('register_j:work') || user_activities.include?('all:work')
  end

  #########################################################

  def index_p?
    user_activities.include?('register_p:index')
  end

  def show_p?
    user_activities.include?('register_p:show')
  end

  def new_p?
    create?
  end

  def create_p?
    user_activities.include?('register_p:create')
  end

  def edit_p?
    update_p?
  end

  def update_p?
    user_activities.include?('register_p:update')
  end

  def destroy_p?
    user_activities.include?('register_p:delete')
  end
 
  def work_p?
    user_activities.include?('register_p:work') || user_activities.include?('all:work')
  end

  def version_p?
    user_activities.include?('register_p:work') || user_activities.include?('all:work')
  end

  #########################################################

  def index_t?
    user_activities.include?('register_t:index')
  end

  def show_t?
    user_activities.include?('register_t:show')
  end

  def new_t?
    create?
  end

  def create_t?
    user_activities.include?('register_t:create')
  end

  def edit_t?
    update_t?
  end

  def update_t?
    user_activities.include?('register_t:update')
  end

  def destroy_t?
    user_activities.include?('register_t:delete')
  end
 
  def work_t?
    user_activities.include?('register_t:work') || user_activities.include?('all:work')
  end

  def version_t?
    user_activities.include?('register_t:work') || user_activities.include?('all:work')
  end

  class Scope < Scope
    def resolve
      if user_activities.include? 'register_j:index'
        scope.where.not(id: nil).all
      else
        scope.where(id: nil)
      end
    end
  end
end