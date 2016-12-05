class CollaboratorsController < ApplicationController

  before_action :check_if_already_collaborator, only: [:create]
  before_action :check_if_user_exists, only: [:create]
  before_action :check_if_private_wiki, only: [:new]

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new
  end

  def create

    wiki = Wiki.find(params[:wiki_id])
    user = User.where(email: params[:collaborator][:user]).first
    collaborator = user.collaborators.build(wiki: wiki)

    if collaborator.save
     flash[:notice] = "Collaborator added."
    else
     flash[:alert] = "Failed."
    end


    redirect_to wiki
  end

  def destroy
     wiki = Wiki.find(params[:wiki_id])
     collaborator = Collaborator.find(params[:id])


     if collaborator.destroy
       flash[:notice] = "Collaborator deleted"
     else
       flash[:alert] = "Failed."
     end
       redirect_to wikis_path
   end

  private
  def check_if_user_exists
    collaborator = Collaborator.new
    wiki = Wiki.find(params[:wiki_id])
    user = User.where(email: params[:collaborator][:user]).first

    if !user
      flash[:alert] = "That email does not belong to a blocipedia user"
      redirect_to wiki
    end
  end

  def check_if_already_collaborator
    collaborator = Collaborator.new
    wiki = Wiki.find(params[:wiki_id])
    user = User.where(email: params[:collaborator][:user]).first

    if Collaborator.where(user: user, wiki: wiki).count > 0
      flash[:alert] = "User is already a collaborator"
      redirect_to wiki
    end
  end

  def check_if_private_wiki
    wiki = Wiki.find(params[:wiki_id])
    if !wiki.private
      flash[:alert] = "No need to add collaborators to a public wiki"
      redirect_to wiki
    end
  end

end
