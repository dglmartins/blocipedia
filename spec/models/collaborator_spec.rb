require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  let(:user) { User.create!(email: "user@example.com", password: "password", password_confirmation: "password")}
  let(:wiki) {Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user) }
  let(:collaborator) { Collaborator.create!(wiki: wiki, user: user) }

   it { is_expected.to belong_to(:wiki) }
   it { is_expected.to belong_to(:user) }
end
