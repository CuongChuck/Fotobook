class AlbumAbility
  include CanCan::Ability

  def initialize(user)
    can :read, Album, isPublic: true

    return unless user.present?

    can :read, Album, isPublic: true
    can [:update, :destroy], Album, user: user
    can :create, Album unless user.isAdmin?

    return unless user.isAdmin?

    can [:read, :update, :destroy], Album
  end
end