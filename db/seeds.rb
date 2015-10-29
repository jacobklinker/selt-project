# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [
        {:email => 'luke@klinker.com', :password => 'password', :password_confirmation => 'password'},
        {:email => 'jake@klinker.com', :password => 'password', :password_confirmation => 'password'},
        {:email => 'tyson@massey.com', :password => 'password', :password_confirmation => 'password'},
        {:email => 'rick@zamudio.com', :password => 'password', :password_confirmation => 'password'},
        {:email => 'tyler@parker.com', :password => 'password', :password_confirmation => 'password'},
  	 ]

users.each do |user_params|
  user = User.new(user_params)
  user.skip_confirmation!
  user.save!
end
