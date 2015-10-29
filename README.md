# Rails Sport App

### Info about hosting, workflow, and signin:
I have deployed the production app to heroku here: https://glacial-reef-4224.herokuapp.com/

Only I, Luke, will be able to deploy to that heroku instance... I think. I did find though, if you are on a branch and try to run 'git push heroku master', it doesn't actually push your current branch to heroku, it only pushes the master branch of our project.


With the production version, everything is working with the login and the mailer. The mailer, however, is a Heroku add-on, so it won't work on the cloud 9 instances that you spin up locally to test your changes.

That means that you wouldn't be able to verify your login, so you won't be able to access the app from those instances. Uh oh. But, I created a migration to add all of us as users.

```
Username: first_name@last_name.com
Password: password
```

These are just pre-verified users, so you can use them in the Cloud 9 test environment to login. Make sure you seed the database to get these users on the database.



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