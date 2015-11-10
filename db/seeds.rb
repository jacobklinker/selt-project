# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [
        {:email => 'luke@klinker.com', :password => 'password', :password_confirmation => 'password',:first_name => "Luke",:last_name => "Klinker"},
        {:email => 'jake@klinker.com', :password => 'password', :password_confirmation => 'password',:first_name => "Jake",:last_name => "Klinker"},
        {:email => 'tyson@massey.com', :password => 'password', :password_confirmation => 'password',:first_name => "Tyson",:last_name => "Massey"},
        {:email => 'rick@zamudio.com', :password => 'password', :password_confirmation => 'password',:first_name => "Richardo",:last_name => "Zamudio"},
        {:email => 'tyler@parker.com', :password => 'password', :password_confirmation => 'password',:first_name => "T",:last_name => "P"},
  	 ]

users.each do |user_params|
  user = User.new(user_params)
  user.skip_confirmation!
  user.save!
end
