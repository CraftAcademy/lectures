#### Part 1 - Application set-up

Goals:
- Set up the application
- Create GitHub repository
- Create Heroku instances
- Add root page
- Deploy application
- Share code/repository



We will give `git` commands some superpowers by installing Hub (https://github.com/github/hub)

Install Hub by running 
```
$ brew install hub
$ hub version
git version 2.2.1
hub version 2.2.0
```
Now you have access to some nice commands that extendes git - read more about it on Hub's gh readme.

Alright, lets create a rails application. 

In this example we will be using Thoughtbot's suspenders - a Rails template with some standard defaults (https://github.com/thoughtbot/suspenders). If you don't have suspenders installed, go ahead and install it with `gem install suspenders`. 

We will be using the `--heroku` & `--github` switches to both set up a GH repo for the project AND create a staging and production Heroku app. 

We could do all that using the webinterface for both GH and Heroku, but for the sake of automating as many tasks as possible let's try to do it this way:

```
curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
suspenders accounts --heroku true --github makerssweden/accounts-example
``` 

You might be prompted for your username and password on GH or/and Heroku during the process.

Use `rails generate simple_form:install` to generate the Simple Form configuration. You can (and should) read about Simple Form on https://github.com/plataformatec/simple_form.

Visit your Heroku dashboard. You should now have two new applications - `accounts-staging` and `accounts-production`. Also, if you access your GitHub account, you should see a new repository - `accounts-example`.

Now, add all files to git, create a commit and push up to your repository. Since we have two applications on Heroku we can also create a staging (or develop) branch in git. We will be discussing feature branches and git workflow in separate lectures.

```
git checkout -b staging
git add . 
git commit -am "first commit - initial setup with suspenders"
git push origin staging
``` 

#### Ready to deploy?

We are almost there, but there are a few steps we need to take before we can launch the application. 

We need to generate a `secret_token` for the `development` enviroment (the staging and production secret tokens are already set during the app setup process). The `secret_token` can basically be any string you want - the longer the better. There is a rake task we can use. Run the `rake secret` task in your terminal window. That will return a long string of random numbers - that will be our `secret_token`. Open `config/secrets.yml` and modify its code to: 

```
default: &default
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>

development: &development
  secret_key_base: [your generated string]

test:
  <<: *development

staging:
  <<: *default

production:
  <<: *default

```

Okay, so now if you start your rails server you will be able to see the default index page for a rails application. Well done!

`rails s` or `foreman start` will fire up the server on your local machine.
 
#### Ready to deploy now??
There are still some issues with the default configuration that comes with suspenders that we have not addressed yet and the application is not yet ready to deploy to a Heroku server (there is not much to deploy because we only have a default index page to show for your efforts so far, but still...). In order to get this out we need to disable some functions for the time being and set some environmental variables.

First, the application is set up to send out emails and are looking for av enviromental variable called `SMTP_ADDRESS` amog other things. We need to turn that functionality off for now. Open `config/smtp.rb` and comment out every line - do not delete it, you will probably use these settings at a later stage. 

Another setting that we need to configure is the `HOST` & `EMAIL_RECIPIENTS` variables om Heroku. It is used for assets handling in the enviroment setup and for sending out emails. For now we can set it by: 
```
heroku config:set HOST='' --remote staging
heroku config:set EMAIL_RECIPIENTS='your@email.org' --remote staging
``` 


Commit your changes, update your GH repository and push up to Heroku. How? Here we go:
```
git commit -am "added secret_token and disabled SMTP settings"
git push origin staging
git push staging staging:master
```

Once you get a confirmation that all is okay you need to migrate the database in order to get everything working. At this stage we only have one migration for background jobs. 

```
heroku run rake db:migrate --remote staging
```

Okay, there is not much to look at and you probably get a "The page you were looking for doesn't exist." wher you try to access the application through it's uri. No suprising at all - after all, we have not created any pages yet. 

suspenders comes with a library for handling static pages - `High_voltage` (https://github.com/thoughtbot/high_voltage)

Here is what we are gonna do. In `config/initializers/high_voltage.rb` set:

```
HighVoltage.configure do |config|
  config.home_page = 'welcome'
end
```
That tells the application to set the defaul route to the `welcome` page. So let's create that. 

In your IDE create and edit a file called `welcome.html.erb` in the `app/views/pages` folder. If you want to do this from the command line (and most of us do), you can go ahead and run these commands:
```
touch app/views/pages/welcome.html.erb
nano app/views/pages/welcome.html.erb
```

Add some markup to that file, i e `<h1>Welcome!</h1>` and save the file. Commit your changes and redeploy the application. Also, make sure to push up to your GH repo. 

Now you can access the site again, and you should see the welcome page. **Still not much of a webbapp but you are well on your way!**


#### Collaborating on code

TODO: Write section




 



