### Part 2 - Setting up testing frameworks

We will be using Rspec and Cucumber to test our application. We will be using an approach that mixes high level acceptance tests and low level unit tests to both drive the development process and make sure that we build a robust and well structures application.

##### Cucumber

As you probably already know, Cucumber (https://cucumber.io/) is a framework for writing and executing high level descriptions of your software's functionality. One of Cucumber's most compelling features is that it provides the ability to write these descriptions using plain text - even in your native language. More on that in a moment.

With cucumber you take a user experience based approach to testing your application. Your application has or should have a set of features, right? These features can be used in a set of different ways, by different users, under different circumstances. Some of the features can probabluy also be restricted and only be used/accessed under special conditions.  

So how about describing those features in a structured way that is easily understandable and mapped to the business values and goales thef deliver?

Does that sound overly complicated? Let me put it this way

> A feature is something that your software does (or should do), and generally corresponds to a user story and a way to tell when it's finished and that it works.

The general format of a feature is:

``` 
Feature: <short description>
  As a <role>
  I want <feature>
  so that <business value>
	  
  <scenario 1>
  ...
  <scenario n>
``` 

This format focuses us on three important questions:
- Who's using the system?
- What are they doing?
- Why do they care?

A feature is defined by one or more scenarios. A scenario is a sequence of steps through the feature that exercises one path. 

A scenario is made up of 3 sections related to the 3 types of steps:
- **Given:** This sets up preconditions, or context, for the scenario. It works much like the setup in xUnit and before blocks in RSpec.
- **When:** This is what the feature is talking about, the action, the behaviour that we're focused on.
- **Then:** This checks postconditions… it verifies that the right thing happen in the When stage.

There is yet another type of step you can use in a scenario path, and that is the **And** keyword. **And** can be used in any of the three sections. It serves as a nice shorthand for repeating the **Given**, **When**, or **Then**. **And** stands in for whatever the most recent explicitly named step was.

Okay, that was a wery brief introduction to Cucumber. There is much more to it and we will be diving much deeper into this as we progress with our application. 

But for now lets focus on our application and implement this framework and write out first simple test.

Open up `Gemfile` and locate the `:test` group. Add:
	
```
gem 'cucumber-rails', :require => false

```

Save your file and run `bundle`. That will install `cucumber-rails` and its dependencies. To set everything up, run the install script:
```
rails generate cucumber:install
``` 

Alright, now run the `cucumber` command. The response should look something like this:
```
$ cucumber
Using the default profile...
0 scenarios
0 steps
0m0.000s
```

We are done with the setup of the framework. Now we can create our first test by adding a feature and a scenario. In the `features` folder, create a `root_page.feature` file. Open it up and add the following lines:
```
Feature: Accessing the site
  As a visitor
  I want to be able to access the site
  so that I can use the application

  Scenario: Getting the welcome message
    When I visit the site
    Then I should be on the application index page
    And I should see "Welcome!"
```

Save and head over to your terminal window. Run the `cucumber` command again. The output should look something like this:

```
$ cucumber
Using the default profile...
Feature: Accessing the site
  As a visitor
  I want to be able to access the site
  so that I can use the application

  Scenario: Getting the welcome message            # features/root_page.feature:6
    When I visit the site                          # features/root_page.feature:7
      Undefined step: "I visit the site" (Cucumber::Undefined)
      features/root_page.feature:7:in `When I visit the site'
    Then I should be on the application index page # features/root_page.feature:8
      Undefined step: "I should be on the application index page" (Cucumber::Undefined)
      features/root_page.feature:8:in `Then I should be on the application index page'
    And I should see "Welcome!"                    # features/root_page.feature:9
      Undefined step: "I should see "Welcome!"" (Cucumber::Undefined)
      features/root_page.feature:9:in `And I should see "Welcome!"'

1 scenario (1 undefined)
3 steps (3 undefined)
0m0.230s

You can implement step definitions for undefined steps with these snippets:

When(/^I visit the site$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be on the application index page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
``` 

Okay, that's seem like a lot. Lets break it down. The first block tells you that Cucumber tried to run your scenario and that it ran into some troubles becouse it did not know excactly what criiterias should be met in order to determine whether the test passes or not. We need to tell cucumber that. That is done by adding a definition for each step. 

The response also tells you that Cucumber ran 1 scnario with 3 steps and how long time it took to run it.

The last block of the response actually tells you, or suggests, what step definitions you should add to the framework so that we can actually get some criterias for the tests. In this case, it returns one `When`and two `Then` definitions. 

Okay, in the `features/step_definitions` forlder, create a file called `basic_steps.rb`. Add the following step definitions to that file:
```
When(/^I visit the site$/) do
  visit '/'
end

Then(/^I should be on the application index page$/) do
  expect(current_path).to eql root_path
end

Then(/^I should see "(.*?)"$/) do |arg1|
  expect(page).to have_text arg1
end
```

Save and head over to the terminal to run the `cucumber` command once again. Now, the response comes back with different results, right?
You should see something like this on your screen, colored in green and everything.

```
$ cucumber
Using the default profile...
Feature: Accessing the site
  As a visitor
  I want to be able to access the site
  so that I can use the application

  Scenario: Getting the welcome message            # features/root_page.feature:6
    When I visit the site                          # features/step_definitions/basic_steps.rb:1
    Then I should be on the application index page # features/step_definitions/basic_steps.rb:5
    And I should see "Welcome!"                    # features/step_definitions/basic_steps.rb:9

1 scenario (1 passed)
3 steps (3 passed)
0m0.324s
```

**Our first test has passed.**
I will cover in more detail what we exactly did to define the step definitions at a later stage. For now, lets just accept that Cucumber uses a library called Capybara that provides a set of method's that makes it easy to simulate how a user interacts with your application.

Using those methods we can tell Cucumber to do certain things (i e `visit '/'`) and to check certain conditions(`expect(page).to have_text 'Welcome!`) just as we was to manually visit the site to check for certain functionality. 


