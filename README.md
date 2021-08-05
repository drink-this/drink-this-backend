# Drink This
<!-- logo here -->
<!-- badges here -->
<!-- badges for last commit, commit activity, state of the build, dependencies up to date -->
Drink This provides cocktail recommendations using a memory-based approach to collaborative filtering. We use the PyCall gem to import key Python libraries into our Rails app, including `numpy`, `pandas`, and `sklearn`. This allows us, for example, to calculate similarity among users in our application with sci-kit learn's `euclidean_distance` method and to use pandas DataFrames to manipulate data as we pass it through our recommendation engine. The recommendation model takes a users ratings history into account, identifies the closest 15% of users, then makes a recommendation to the requester based on what similar users who have rated highly in the past.
Check out our [Wiki](https://github.com/drink-this/drink-this-backend/wiki) for more info.
<!-- features, example of the ML code, link to demo vid, link to wiki homepage -->

#### System Dependencies
##### Some useful gems needed:
- `gem faraday`
- `gem pycall`
- `gem numpy`
- `gem pandas`
- `gem atcive_model_serializer`
- `gem figaro`

From the `numpy` gem we reached into `sklearn` to import the module `metrics`, which includes score functions, performance metrics and pairwise metrics and distance computations. Leveraging the `pairwise` metrics submodule, we were able to reach into this library of equations for distance metrics, including a popular one in the data science arena -- the [Euclidean Distance](https://en.wikipedia.org/wiki/Euclidean_distance). In Euclidean geometry, simply put, the Euclidean distance is the usual distance between two points, and this distance is measured as a line segment. In our app, we used the Euclidean distance method to calculate, among users when compared to the current user, which users (the 15% of users in our database) is closest in the rating of cocktails to the current user. This method enables our app to recommend an accurate cocktail to the current user with like users. 

From the `pandas` gem, were able to manipulate the data into dataframes and apply the Euclidean distance method into the data inputs we received. As the user base grows in our app, the recommendation model would be more precise in provide the most accurate recommended cocktail to a particular user so that the current user may enjoy that nice drink.
<!-- list of packages/gems etc that are used, link to wiki for this? -->

#### Configuration
<!-- cli to get project running, potentially file descriptions, maybe just link to wiki -->

#### Database
<img width="685" alt="Screen Shot 2021-08-05 at 8 12 40 AM" src="https://user-images.githubusercontent.com/10294841/128374788-a88a6835-a76b-44f1-9a8a-91c2dc9c3f11.png">
<!-- also explain dataset? -->

#### How to run Test Suite
<!-- link to wiki -->
Gems required for testing:
- [faker](https://github.com/faker-ruby/faker)
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
- [rspec-rails](https://github.com/rspec/rspec-rails)
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- [simplecov](https://github.com/simplecov-ruby/simplecov)
- [vcr](https://github.com/vcr/vcr)
- [webmock](https://github.com/bblimke/webmock)
- [rubocop](https://github.com/rubocop/rubocop)

#### Deployment schema
<!-- touch on the sadness that is ruby+python -->
Since this Rails app also requires Python, both [this Ruby buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-ruby) and [this Python buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-python) are required for deploying to Heroku. The Python buildpack **must** be ordered **before** the Ruby buildpack. The Python buildpack includes a built in post compile hook, which will run the `bin/post_compile` script included in this app to ensure that Python is built with shared libraries enabled. This is required for your local environment as well. We have written some [basic instructions for installing Python](https://github.com/drink-this/drink-this-backend/wiki/Python-pyenv-Installation), but these may not work for all environments. The app requires Python 3.9.6.

#### Future features
- Implement GraphQL
- Using the microservices approach on python, instead of the `gem pycall`
- Implement Docker

#### Contributers
<!-- each of us with links to github and linked in profiles -->
  * Mark Yen - [markcyen](https://github.com/markcyen)
  * Taija Warbelow - [twarbelow](https://github.com/twarbelow)
  * Molly Krumholz - [mkrumholz](https://github.com/mkrumholz)
  * Zach Green - [zachjamesgreen](https://github.com/zachjamesgreen)
  * Richard DeSilvey - [redferret](https://github.com/redferret)
  * Jermaine Braumuller - [Jaybraum](https://github.com/Jaybraum)
