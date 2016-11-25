class WikiPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if !user
        scope.where(private: false)
      elsif user.admin?
        scope.all
      else
        scope.where(private: false).or(scope.where(user: user))
      end
    end
  end
end
