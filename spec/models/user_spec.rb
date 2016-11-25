require 'rails_helper'

RSpec.describe User, type: :model do
  let(:my_user) {User.create!(email: "user@example.com", password: "password", password_confirmation: "password") }


  it { is_expected.to have_many(:wikis) }
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_presence_of(:password) }

  describe "attributes" do
    it "should have an email attribute" do
      expect(my_user).to have_attributes(email: "user@example.com")
    end

    it "responds to role" do
      expect(my_user).to respond_to(:role)
    end

    it "responds to admin?" do
      expect(my_user).to respond_to(:admin?)
    end

    it "responds to standard?" do
      expect(my_user).to respond_to(:standard?)
    end

    it "responds to premium?" do
      expect(my_user).to respond_to(:premium?)
    end

  end

  describe "roles" do
    it "is a standard by default" do
      expect(my_user.role).to eql("standard")
    end

    context "standard user" do
      it "returns true for #standard?" do
        expect(my_user.standard?).to be_truthy
      end

      it "returns false for #admin?" do
        expect(my_user.admin?).to be_falsey
      end

      it "returns false for #premium?" do
        expect(my_user.premium?).to be_falsey
      end
    end

    context "admin user" do
      before do
         my_user.admin!
       end
      it "returns false for #standard?" do
        expect(my_user.standard?).to be_falsey
      end

      it "returns true for #admin?" do
        expect(my_user.admin?).to be_truthy
      end

      it "returns false for #premium?" do
        expect(my_user.premium?).to be_falsey
      end
    end

    context "premium user" do
      before do
         my_user.premium!
       end
      it "returns false for #standard?" do
        expect(my_user.standard?).to be_falsey
      end

      it "returns false for #admin?" do
        expect(my_user.admin?).to be_falsey
      end

      it "returns true for #premium?" do
        expect(my_user.premium?).to be_truthy
      end
    end




  end

end
