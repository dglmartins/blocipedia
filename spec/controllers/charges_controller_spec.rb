require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  let(:my_user) {User.create!(email: "user@example.com", password: "password", password_confirmation: "password") }
  describe "GET #new" do
    before do

      sign_in my_user
    end
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "downgrade" do
    before do

      sign_in my_user
      Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: my_user)
    end
    context "premium user" do

      it "makes all private wikis public at downgrade" do
        get :downgrade
        expect(Wiki.where(user: my_user, private:true).count).to eq(0)
      end

    end


  end

end
