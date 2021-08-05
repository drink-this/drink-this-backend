# Drink This
<!-- logo here -->
<!-- badges here -->
<!-- badges for last commit, commit activity, state of the build, dependencies up to date -->
Drink This provides cocktail recommendations using a memory-based approach to collaborative filtering. We use the PyCall gem to import key Python libraries into our Rails app, including `numpy`, `pandas`, and `sklearn`. This allows us, for example, to calculate similarity between users with sci-kit learn's `euclidean_distance` method and to use pandas DataFrames to manipulate data as we pass it through the engine. The recommendation model takes a users ratings history into account, identifies the closest 15% of users, then makes a recommendation to the requester based on what similar users have rated highly in the past.
<!-- features, example of the ML code, link to demo vid, link to wiki homepage -->

#### System Dependencies
<!-- list of packages/gems etc that are used, link to wiki for this? -->

#### Configuration
<!-- cli to get project running, potentially file descriptions, maybe just link to wiki -->

#### Database Setup
<!-- also explain dataset? -->

#### How to run Test Suite
<!-- link to wiki -->
[faker](https://github.com/faker-ruby/faker)
[factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
[rspec-rails](https://github.com/rspec/rspec-rails)
[shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
[simplecov](https://github.com/simplecov-ruby/simplecov)
[webmock](https://github.com/bblimke/webmock)

#### Deployment
<!-- touch on the sadness that is ruby+python -->
Since this Rails app also requires Python, both [this Ruby buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-ruby) and [this Python buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-python) are required for deploying to Heroku. The Python buildpack **must** be ordered **before** the Ruby buildpack. The Python buildpack includes a built in post compile hook, which will run the `bin/post_compile` script included in this app to ensure that Python is built with shared libraries enabled. This is required for your local environment as well. We have written some [basic instructions for installing Python](https://github.com/drink-this/drink-this-backend/wiki/Python-pyenv-Installation), but these may not work for all environments. The app requires Python 3.9.6.

#### Future features

#### Contributers
<!-- each of us with links to github and linked in profiles -->
  * Mark Yen - [markcyen](https://github.com/markcyen)
  * Taija Warbelow - [twarbelow](https://github.com/twarbelow)
  * Molly Krumholz - [mkrumholz](https://github.com/mkrumholz)
  * Zach Green - [zachjamesgreen](https://github.com/zachjamesgreen)
  * Richard DeSilvey - [redferret](https://github.com/redferret)
  * Jermaine Braumuller - [Jaybraum](https://github.com/Jaybraum)
