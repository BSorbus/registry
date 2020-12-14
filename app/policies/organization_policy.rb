class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    user_activities.include?('organization:index')
  end

  def show?
    user_activities.include?('organization:show')
  end

  def new?
    create?
  end

  def create?
    user_activities.include?('organization:create')
  end

  def edit?
    update?
  end

  def update?
    user_activities.include?('organization:update')
  end

  def destroy?
    user_activities.include?('organization:delete')
  end
 
  def work?
    user_activities.include?('organization:work') || user_activities.include?('all:work')
  end

  def add_remove_organization_group?
    user_activities.include?('organization:add_remove_organization_group')
  end

  def add_remove_organization_user?
    user_activities.include?('organization:add_remove_organization_user')
  end
  
  
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end