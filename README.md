Ruby on the Edge
================

"Ruby on the Edge", or "RotE", is an opinionated franken-framework that is
perfect for prototyping and hackathons. Oh, and large-scale production apps too.

Grok the 5-minute overview on YouTube to be enlightened, then keep reading.

Overview
--------

RotE is more Railsy than Rails, because all the decisions have been made, and
you have little say in the matter.

The goal of RotE is to go from an idea to a deployed production app in under
thirty minutes, including setting up all the things you'd normally leave until
later because they're too boring and you can't decide. It makes sure you're
doing things right before you write a line of code.

RotE is simple; it just bolts together these best-of-breed components:

* Language: Ruby
* Rack Server: Puma
* HTTP Framework: Sinatra
* ORM: Sequel
* Database: PostgreSQL
* Authentication: Omniauth
* Authorisation: Pundit
* Background Jobs: Sidekiq
* Email: Sendgrid
* Forms: ???
* HTML Templating: Slim
* JSON Templating: JBuilder
* Logging: Semantic Logger
* Testing: RSpec
* UI Framework: Bulma
* Data Binding: Vue
* Stylesheets: SCSS
* Scripting: Babel
* WebGL: Pixi
* Asset Build: Webpack
* Deployment: Heroku

It provides action objects, service objects and view models, along with a CLI
for running it all.

Creating a project
------------------

Here's my million-dollar idea: A microblogging engine for Twitter users. Let's
call it Blitter, and let's build it now.

First, create the project. You can do this on a brand-new MacBook Pro, even if
you've never written a line of code before. Hit command-space, type "terminal",
then type this...

```
curl ...
```

Setting it up
-------------

Great!

Now we need to set up the new project. RotE will first make sure you're running
all the things it needs.

```
git
rbenv
ruby
bundle
node
```

Now that's all done, you can run your brand new app.

```
> rote server
```

Configuration
-------------

Your browser will open, and you'll see some stuff. Click around and explore,
and, once you're done, go back to the home page and follow the instructions.
I'll wait while you do. Notice the admin UI too!

Notice that, although we're asking you to set up a whole bunch of third-party
services like Heroku and Codeship, this will all cost you nada until you need to
dial things up to scale to the demand of your users.

Deploying to production
-----------------------

Now that everything is ready to go, deploy your app to production (no, really)
by pushing to GitHub. Crazy, right?

Notice that your production app shows a neato signup page. You can get your
designers to start working on making it more awesome even as you start
collecting a list of potential customers. Meanwhile, your developers will want
to start implementing Blitter proper.

Making changes and testing them
-------------------------------

Now we'll walk you through the lifetime of a request (route, action, services,
view, template). We'll show you how to write tests for those things, and explain
validations and the data flow magic. We'll look at workers and mailers,
authentication and authorisation. We'll look at APIs and React as well as
Turbolinks.

Exiting stealth mode
--------------------

Your app is working? Great stuff! Ready to exit stealth mode and deploy to the
world? Easy. Just change the route and push it to GitHub and you're set.

Happy hacking!

Omakase by Kranzky
------------------

I have been your chef for today. I hope you've enjoyed your meal. Burp.

Copyright (c) 2016 Jason Hutchens. See UNLICENSE for further details.
