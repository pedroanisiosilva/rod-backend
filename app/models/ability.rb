class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all #if user.role.name == "admin"
    # can :manage, :create if user.role.name == "admin"
  end

end
