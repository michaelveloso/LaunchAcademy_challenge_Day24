require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')

PLANETS = ['Alpha', 'Beta', 'Delta', 'Epsilon', 'Gamma', 'Proxima', 'Kappa', 'Theta', 'Zeta']
CONSTELLATIONS = ['Aquarius', 'Aquilae', 'Auriga', 'Bootes', 'Camelopardalis', 'Carina', 'Cassiopeia', 'Centauri',
  'Cygnus', 'Draco', 'Gemini', 'Hydra', 'Lyra', 'Ophiuchus', 'Orion', 'Pegasus', 'Scorpius', 'Ursa Major']

10.times do
  meetup_hash = {}
  meetup_hash[:name] = Faker::App.name + " " + Faker::Company.name + " " + Faker::Company.suffix
  meetup_hash[:description] = Faker::Company.bs
  meetup_hash[:location] = PLANETS.sample + " " + CONSTELLATIONS.sample
  Meetup.create(meetup_hash)
end

def get_random_meetups
  random_meetups = []
  meetups = Meetup.all
  (rand(7) + 2).times do
    random_meetup = meetups.sample
    random_meetups << random_meetup unless random_meetups.include?(random_meetup)
  end
  random_meetups
end

20.times do
  provider = Faker::Company.name
  uid = Faker::Number.number(10)
  username = Faker::Internet.user_name
  email = Faker::Internet.safe_email
  avatar_url = Faker::Internet.url
  user = User.create(provider: provider, uid: uid, username: username, email: email, avatar_url: avatar_url, meetups: get_random_meetups)
end
