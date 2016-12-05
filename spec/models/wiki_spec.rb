require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:my_user) { User.create!(email: "user@example.com", password: "password")}
  let(:wiki) { Wiki.create!(title: "New Wiki Title", body: "New Wiki Body", private: false, user: my_user)}
  let(:other_wiki) {Wiki.create!(title: "New Wiki Title", body: "New Wiki Body", user: my_user)}

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:collaborators)}

  describe "attributes" do
    it "has title, body, private and user attributes" do
      expect(wiki).to have_attributes(title:"New Wiki Title", body: "New Wiki Body", private: false, user: my_user)
    end

    it "has a private attribute that defaults to false" do
      expect(other_wiki).to have_attributes(title:"New Wiki Title", body: "New Wiki Body", private: false, user: my_user)
    end
  end

end
