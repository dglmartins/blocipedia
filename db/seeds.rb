# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do
  password = Faker::Internet.password
  User.create!(
  email: Faker::Internet.email,
  password: password,
  password_confirmation: password
  )
end

standard_users = User.where(role: 'standard')

#premium users
10.times do
  password = Faker::Internet.password
  User.create!(
  email: Faker::Internet.email,
  password: password,
  password_confirmation: password,
  role: 'premium'
  )
end

premium_users = User.where(role: 'premium')

#premium users Wikis
10.times do
  Wiki.create!(
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph,
    private: Faker::Boolean.boolean,
    user: premium_users.sample
  )
end

#standard users Wikis
50.times do
  Wiki.create!(
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph,
    private: false,
    user: standard_users.sample
  )
end

admin = User.create!(
  email: 'admin@blocipedia.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role: 'admin'
)

standardMember = User.create!(
  email: 'standard_member@blocipedia.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role: 'standard'
)

standardMember = User.create!(
  email: 'premium_member@blocipedia.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role: 'premium'
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{User.where(role: 'standard').count} standard users created"
puts "#{User.where(role: 'premium').count} premium users created"
puts "#{User.where(role: 'admin').count} admin users created"
puts "#{Wiki.count} wikis created"
puts "#{Wiki.joins(:user).where(users: {role: 0}).count} wikis created by standard users"
puts "#{Wiki.joins(:user).where(users: {role: 1}).count} wikis created by premium users"
puts "#{Wiki.where(private: false).count} public wikis created"
puts "#{Wiki.where(private: true).count} private wikis created"
