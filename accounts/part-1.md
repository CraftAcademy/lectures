## Part 1 - Application set-up

### Goals
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

Also, if you check for your git remotes, you should get a response that looks something like this:
```
git remote -v
origin	git@github.com:MakersSweden/accounts-example.git (fetch)
origin	git@github.com:MakersSweden/accounts-example.git (push)
production	https://git.heroku.com/accounts-production.git (fetch)
production	https://git.heroku.com/accounts-production.git (push)
staging	https://git.heroku.com/accounts-staging.git (fetch)
staging	https://git.heroku.com/accounts-staging.git (push)
```


Now, add all files to git, create a commit and push up to your repository. Since we have two applications on Heroku we can also create a staging (or develop) branch in git. We will be discussing feature branches and git workflow in separate lectures.

```
git checkout -b staging
git add . 
git commit -am "first commit - initial setup with suspenders"
git push origin staging
``` 

### Ready to deploy?

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
 
### Ready to deploy now??

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


### Collaborating on code and setting up a workflow

Okay, so we have set up the main repository for this particular project. In the example above we've created the repo using the CLI (command line interface) provided by Hub. The git remote `origin` is pointing to that repository. Now, for the purpose of working on the code in a team, we should treat this repo as a repo exclusively to host code that will be used for deployment to live servers - in this case first to a staging server and then to a production server.

In order to be able to contribute code, each developer should fork this repository and create feature branches on his/hers own version of the repo. Code should be submittet to the main repository using Pull Requests from the forked repository. More on that later. 

Forking a repository is easily done using GitHubs web interface. But since we now have Hub's extended git commands at our disposal, I suggest we make use of the `fork` command. If your git configuration is correct you should be able to do this:
```
hub fork
```

With my setup the response was:
```
Updating tochman
From ssh://github.com/MakersSweden/accounts-example
 * [new branch]      develop    -> tochman/develop
 * [new branch]      master     -> tochman/master
new remote: tochman
```

Pretty neat, right? Head over to github.com and your profile page to see if a new repo has been added. You should see that in your repository list.

You now should have 4 remotes configured:

```
git remote -v
origin	git@github.com:MakersSweden/accounts-example.git (fetch)
origin	git@github.com:MakersSweden/accounts-example.git (push)
production	https://git.heroku.com/accounts-production.git (fetch)
production	https://git.heroku.com/accounts-production.git (push)
staging	https://git.heroku.com/accounts-staging.git (fetch)
staging	https://git.heroku.com/accounts-staging.git (push)
tochman	git@github.com:tochman/accounts-example.git (fetch)
tochman	git@github.com:tochman/accounts-example.git (push)
```
There is a problem with this configuration. The way I see it we should rename the current `origin` to `upstream` and `tochman` to `origin`. Why? Your `origin` remote should be the repository you are using to store your feature branches and the code you are currently working on. The convention I am used to is to refer to the main repository as `upstream`. You are going to use that remote quite often. Not to do `git push`, but to do `git pull` from. More on that later.

Okay, lets do the changes to the git remotes. 
```
git remote rename origin upstream
git remote rename tochman origin
```
**With these changes you should be set up to work on the code, make commits to your own fork, pull down the latest code from the main repository AND deploy code to Heroku.**

### Wrap up

This concludes the first part of this lecture. In the second part we will be focusing on setting up the testing framewoks we want to use and try them out.

  






 



