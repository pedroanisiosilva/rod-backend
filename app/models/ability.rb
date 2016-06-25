require 'pp'
# class Ability
#   include CanCan::Ability

#   def initialize(user)
#     can :manage, :all #if user.role.name == "admin"
#     # can :manage, :create if user.role.name == "admin"
#   end

# end

class Ability
  include CanCan::Ability
  # Remember that CanCan is for a resource, meaning it must have a class(model).

  def initialize(user)
    if user.role.name == "admin"
      can :manage, :all
    elsif user.role.name == "registered"
      can :manage, Run, :user_id => user.id
      can :read, :all
    elsif user.role.name == "banned"
      cannot :manage, :all
    end
  end
end