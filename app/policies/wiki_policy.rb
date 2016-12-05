class WikiPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      wikis = []
      public_wikis = scope.where(private: false)
      all_wikis = scope.all
      if !user
        wikis = public_wikis
      elsif user.admin?
        wikis = all_wikis
      elsif user.premium?

        my_wikis = scope.where(user: user)
        wikis << public_wikis.or(my_wikis)

        wikis_i_collaborate = scope.joins(:collaborators).where(collaborators: { user: user })
        (wikis << wikis_i_collaborate).flatten!

      elsif user.standard?
        my_wikis = scope.where(user: user)
        wikis << public_wikis.or(my_wikis)
        wikis_i_collaborate = scope.joins(:collaborators).where(collaborators: { user: user })
        (wikis << wikis_i_collaborate).flatten!

      end
      wikis
    end
  end
end
