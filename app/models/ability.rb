class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    can :manage, User, id: user.id
    can :manage, Post, user_id: user.id
    can :create, Comment
    can [:edit, :delete], Comment do |c|
      c.user_id == user.id && c.created_at > (Time.now - 15.minutes)
    end

    can :show, Comment do |c|
      c.verified? || c.user_id == user.id || user.admin? || user.moderator?
    end

    can :verify, Comment if user.admin? || user.moderator?

    can :manage, :all if user.admin?
    can :manage, Comment if user.moderator?

    cannot :create, Comment if user.new_record?
    cannot :create, Post if user.new_record?

  end
end
