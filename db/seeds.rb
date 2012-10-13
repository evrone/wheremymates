# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

evrone_team = Team.create!(name: 'Evrone')
Team.create!(name: 'GitHub')
Team.create!(name: 'Heroku')

User.create!(:email => 'test1@test.com', :team => evrone_team)
User.create!(:email => 'test2@test.com', :team => evrone_team)
User.create!(:email => 'test2@test.com')
