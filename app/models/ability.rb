# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Project, user_id: user.id
    can %i[manage change_position complete_task], Task, project: { user_id: user.id }
    can :manage, Comment, task: { project: { user_id: user.id } }
  end
end
