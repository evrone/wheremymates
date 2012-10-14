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

User.create!(:name => 'test1', :team => evrone_team, latitude: 51.697402, longitude: 39.263077)
User.create!(:name => 'test2', :team => evrone_team, latitude: 55.723810, longitude: 37.507324)
User.create!({latitude: 41.9137, longitude: 12.5205, name: "Kir Shatrov", uid: "1082591060", team: evrone_team, city: "Rome", country: "Italy"}, without_protection: true)
