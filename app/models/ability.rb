class Ability
  include CanCan::Ability
  # Remember that CanCan is for a resource, meaning it must have a class(model).

  def initialize(user)

    if user.nil?
      user = User.new
      user.role = Role.new(:name=>"guest")
    end

    if user.role.name == "admin"
      can :manage, :all
    elsif user.role.name == "registered"
      can :manage, Run, :user_id => user.id
      can :manage, User, :id => user.id
      can :read, Membership, :group_id => user.groups.map{|g|g.id}
    elsif user.role.name == "banned"
      cannot :manage, :all
    end
  end
end