class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin_mode
      can :manage, Target
      can :manage, Profile
      can :manage, Scenario
      can :manage, TestRun
    else
      can :manage, Target, user_id: user.id
      can :manage, Profile, user_id: user.id
      can :manage, Scenario, user_id: user.id
      can :manage, TestRun, user_id: user.id
    end

    # Profiles and Scenarios are shared by all
    can :read, Profile
    can :read, Scenario

    if user.admin
      can :manage, User
      can :toggle_admin_mode, :current_user
    end
  end
end
