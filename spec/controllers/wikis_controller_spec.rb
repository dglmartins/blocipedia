require 'rails_helper'

RSpec.describe WikisController, type: :controller do

  let(:my_user) {User.create!(email: RandomData.random_email, password: "password") }

  let(:other_user) { User.create!(email: RandomData.random_email, password: "password") }

  let(:my_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user) }

  let(:my_private_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: my_user) }

  let(:other_user_public_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: other_user) }

  let(:other_user_private_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: other_user) }


  describe "GET #index" do
    before do

      sign_in my_user
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns [my_wiki] to @wikis and @wikis count is 1 because it's public" do
      get :index
      expect(assigns(:wikis)).to eq([my_wiki])
      expect(assigns(:wikis).where(user: my_user).count).to be(1)
    end

    it "assigns [my_private_wiki] to @wikis and @wikis count is 1 because I am signed in" do
      get :index
      expect(assigns(:wikis)).to eq([my_private_wiki])
      expect(assigns(:wikis).where(user: my_user).count).to be(1)
    end

    it "assigns [other_user_public_wiki] to @wikis and @wikis count is 1 because it's public" do
      get :index
      expect(assigns(:wikis)).to eq([other_user_public_wiki])
      expect(assigns(:wikis).where(user: other_user).count).to be(1)
    end

    it "does not assign [other_user_private_wiki] to @wikis and @wikis count is 0 because it's private and belongs to other_user" do
      get :index
      expect(assigns(:wikis)).not_to eq([other_user_private_wiki])
      expect(assigns(:wikis).where(user: other_user).count).to be(0)
    end

  end

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: my_wiki.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, {id: my_wiki.id}
      expect(response).to render_template :show
    end

    it "assigns my_wiki to @wiki" do
      get :show, {id: my_wiki.id}
      expect(assigns(:wiki)).to eq(my_wiki)
    end

  end

  describe "GET #new" do
    context "guest  user" do
      it "redirects to referrer" do
        put :new
        expect(response).to redirect_to(request.referrer || root_path)
      end
    end
    context "signed in  user" do
      before do

        sign_in my_user
      end

      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end
  end

  describe "POST create" do
    before do

      sign_in my_user
    end

    it "increases the number of Wiki by 1" do
      expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user }}.to change(Wiki,:count).by(1)
    end

    it "assigns the new wiki to @wiki" do
      post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user }
      expect(assigns(:wiki)).to eq Wiki.last
    end

    it "redirects to the new wiki" do
      post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user }
      expect(response).to redirect_to Wiki.last
    end
  end

  describe "GET #edit" do
    context "guest  user" do
      it "redirects to referrer" do
        get :edit, {id: my_wiki.id}
        expect(response).to redirect_to(request.referrer || root_path)
      end
    end

    context "signed in user" do
      before do

        sign_in my_user
      end
      it "returns http success" do
        get :edit, {id: my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, {id: my_wiki.id}
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: my_wiki.id}
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
        expect(wiki_instance.private).to eq my_wiki.private
      end
    end

    context "signed in user allowed to update someone else's wiki" do
      before do

        sign_in other_user
      end
      it "returns http success" do
        get :edit, {id: my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, {id: my_wiki.id}
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: my_wiki.id}
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
        expect(wiki_instance.private).to eq my_wiki.private
      end
    end
  end

  describe "PUT update" do

    context "signed in user" do
      before do

        sign_in my_user
      end

      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

         put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

         updated_post = assigns(:wiki)
         expect(updated_post.id).to eq my_wiki.id
         expect(updated_post.title).to eq new_title
         expect(updated_post.body).to eq new_body
      end

      it "redirects to the updated wiki" do
         new_title = RandomData.random_sentence
         new_body = RandomData.random_paragraph


         put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
         expect(response).to redirect_to my_wiki
      end
    end

    context "signed in user allowed to update someone else's wiki" do
      before do

        sign_in other_user
      end

      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

         put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

         updated_post = assigns(:wiki)
         expect(updated_post.id).to eq my_wiki.id
         expect(updated_post.title).to eq new_title
         expect(updated_post.body).to eq new_body
      end

      it "redirects to the updated wiki" do
         new_title = RandomData.random_sentence
         new_body = RandomData.random_paragraph


         put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
         expect(response).to redirect_to my_wiki
      end
    end

  end

  describe "DELETE destroy" do
    context "guest  user" do
      it "redirects to referrer" do
        get :destroy, {id: my_wiki.id}
        expect(response).to redirect_to(request.referrer || root_path)
      end
    end

    context "signed in user deleting own post" do
      before do

        sign_in my_user
      end
      it "deletes the wiki" do
        delete :destroy, {id: my_wiki.id}

        count = Wiki.where({id: my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wiki index" do
        delete :destroy, {id: my_wiki.id}
        expect(response).to redirect_to wikis_path
      end
    end

    context "signed in user trying to delete someone else's wiki" do
      before do

        sign_in other_user
      end
      it "redirects to referrer" do
        get :destroy, {id: my_wiki.id}
        expect(response).to redirect_to(request.referrer || root_path)
      end
    end

    context "admin user deleting someone else's wiki" do
      before do

        sign_in other_user
        other_user.admin!
      end
      it "deletes the wiki" do
        delete :destroy, {id: my_wiki.id}

        count = Wiki.where({id: my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wiki index" do
        delete :destroy, {id: my_wiki.id}
        expect(response).to redirect_to wikis_path
      end
    end

  end



end
