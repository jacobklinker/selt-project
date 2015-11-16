# NCAA Football - Rails 

### Hosting, workflow, and signin:
I have deployed the production app to heroku here: https://glacial-reef-4224.herokuapp.com/

Only I, Luke, will be able to deploy to that heroku instance... I think. I did find though, if you are on a branch and try to run 'git push heroku master', it doesn't actually push your current branch to heroku, it only pushes the master branch of our project.


With the production version, everything is working with the login and the mailer. The mailer, however, is a Heroku add-on, so it won't work on the cloud 9 instances that you spin up locally to test your changes.

That means that you wouldn't be able to verify your login, so you won't be able to access the app from those instances. Uh oh. But, I created a migration to add all of us as users.

```
Username: first_name@last_name.com
Password: password
```

These are just pre-verified users, so you can use them in the Cloud 9 test environment to login. Make sure you seed the database to get these users on the database.

###How to use email
I have added the email capability.  The following are instructions on how to use it.

Go to 

```
app/mailers/user_mailer.rb
```

Here you will find calls for diffenet email calls.  Add a function definition for the email you want to send.  For example...

```
def league_invite(user)
    @user=user
    mail(to: @user, subject: "You're Invited!")
end
```
You can pass in parameters as you like.  Once that is made, go to   

```
app/views/user_mailer
```
In this folder create a view file (ex. league_invite.html.erb).  This will hold the body of the email. The example I uploaded looks like this

```
Hello <%= @user %>, 

You've been invited to join a league in Pick 'Em!
```

You can use variables from the user_mailer in the view like I've done above.

Finally, to call the email simply type the following wherever you wish to send the email.

```
UserMailer.league_invite("tyler-parker@uiowa.edu").deliver_now
```


If you have any questions, let me know.

TP

## Setup and Deployment

#### Deploying to local environment from Cloud 9:
1. bundle install
2. rake db:create
3. rake db:migrate
4. rake db:seed 
5. rails server -p $PORT -b $IP


#### Creating a Heroku instance:
1. heroku create
2. git push heroku master
3. heroku run rake db:migrate
4. heroku run rake db:seed


#### Deploying to Heroku:
1. commit any changes
2. git push heroku master


## Useful Hints/Commands
1. You can still use rails console to view the Heroku Postgres database.

```
heroku run rails console
heroku run rails console --sandbox
```

2. Resetting the database is different on heroku.

```
heroku pg:reset DATABASE
heroku run rake db:migrate db:seed
```