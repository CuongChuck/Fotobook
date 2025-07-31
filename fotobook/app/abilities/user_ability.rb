class UserAbility
  include CanCan::Ability

  def initialize(user)
    can :show, User unless user.present?

    return unless user.present?

    can :show, User unless user.isAdmin?
    can [:update, :destroy], User, user: user

    return unless user.isAdmin?

    can [:index, :update, :destroy], User
  end
end