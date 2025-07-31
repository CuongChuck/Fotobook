class PhotoAbility
  include CanCan::Ability

  def initialize(user)
    can :read, Photo, isPublic: true

    return unless user.present?

    can :read, Photo, isPublic: true
    can [:update, :destroy], Photo, user: user
    can :create, Photo unless user.isAdmin?

    return unless user.isAdmin?

    can [:read, :update, :destroy], Photo
  end
end