require 'rails_helper'

RSpec.describe UsersController, type: :controller do
let(:my_user) {User.create!(email: "user@example.com", password: "password", password_confirmation: "password") }
let(:my_wiki) {Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user) }
let(:other_user) {User.create!(email: RandomData.random_email, password: "password", password_confirmation: "password") }
let(:other_user_wiki) {Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: other_user) }

  describe "GET #show" do

    context "not signed in" do
      it "returns http success" do
        get :show, {id:my_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end

    end

    context "signed in user" do
      before do

        sign_in my_user
      end

      it "returns http success" do
        get :show, {id:my_user.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, {id:my_user.id }
        expect(response).to render_template :show
      end

      it "assigns my_user to @user" do
        get :show, {id:my_user.id }
        expect(assigns(:user)).to eq(my_user)
      end

      it "assigns [my_wiki] to @wikis and @wikis count to be 1" do
        get :show, {id:my_user.id }
        expect(assigns(:wikis)).to eq([my_wiki])
        expect(assigns(:wikis).where(user: my_user).count).to be(1)
      end

      it "does not assign [other_user_wiki] to @wikis and @wikis count to be 0" do
        get :show, {id:my_user.id }
        expect(assigns(:wikis)).not_to eq([other_user_wiki])
        expect(assigns(:wikis).where(user: my_user).count).to be(0)
      end
    end

  end

end
