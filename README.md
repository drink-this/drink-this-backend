![Logo](https://user-images.githubusercontent.com/26797256/128451731-ba02dea0-b1cc-4296-b8f3-a81f5cb649f1.png)
# Drink This

[Check out the app on Heroku](https://drink-this-frontend.herokuapp.com/)
[Explore the frontend repo](https://github.com/drink-this/drink-this-frontend)
<!-- badges here -->
<!-- badges for last commit, commit activity, state of the build, dependencies up to date -->
Drink This provides cocktail recommendations using a memory-based approach to collaborative filtering. We use the PyCall gem to import key Python libraries into our Rails app, including `numpy`, `pandas`, and `sklearn`. This allows us, for example, to calculate similarity among users in our application with sci-kit learn's `euclidean_distance` method and to use pandas DataFrames to manipulate data as we pass it through our recommendation engine. The recommendation model takes a user's rating history into account, identifies the closest 15% of users, then makes a recommendation to the requester based on what similar users have rated highly.

Check out our [Wiki](https://github.com/drink-this/drink-this-backend/wiki) for more info.
<!-- features, example of the ML code, link to demo vid, link to wiki homepage -->

### System Dependencies
#### Required gems:

##### Standard Rails Gems
- `gem faraday`
- `gem active_model_serializer`
- `gem figaro`

##### Python Gems
- `gem pycall`
- `gem numpy`
- `gem pandas`

### Using Python in Rails

We make use of three Python libraries commonly used in data science to construct our recommendation model: NumPy, pandas, and sci-kit learn (`sklearn` here). In order to use these inside of a Rails application, we utilize a gem called `PyCall`, which allows us to import and use these libraries, and by extension Python syntax and functions, within Ruby methods. The bulk of our model is constructed with Python, after converting an array of Ruby objects (Ratings) from our database into a pandas [DataFrame](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html) in our Dataframeable module:

<img width="784" alt="dataframeable" src="https://user-images.githubusercontent.com/26797256/128450438-682f1478-3820-4823-9ca1-3c089a0f9003.png">

The sci-kit learn library gives us access to [`metrics`](https://scikit-learn.org/stable/modules/model_evaluation.html), which includes score functions, performance metrics and pairwise metrics and distance computations, and by extension `pairwise`, from which we get the calculation of [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance). In Euclidean geometry, the Euclidean distance is the usual distance between two points (roughly, distance in multi-dimensional space), and this distance is measured as a line segment. In our model, we use the Euclidean distance to calculate, among users when compared to the current user, which users (the 15% of users in our database) is closest in preferences to the current user. This method enables our app to recommend an accurate cocktail to the current user based on the preferences of other similar users. 

Some examples of this in action: 

<img width="844" alt="distance_calculations" src="https://user-images.githubusercontent.com/26797256/128450433-1f90c288-b48e-4174-9f6b-ff0c1feb12b0.png">

<img width="670" alt="weighted_ratings" src="https://user-images.githubusercontent.com/26797256/128450437-8794b1c0-1c6e-4869-ab72-0bf9217275d1.png">

As the user base grows in our app (and thus our database of user ratings also grows), the recommendation model will become more accurate in providing a recommendation to a particular user that they will enjoy.

### Configuration
<!-- cli to get project running, potentially file descriptions, maybe just link to wiki -->
1. Fork and clone this repo
2. Install Python3 locally with shared libraries enabled. Detailed instructions for installing Python and the packages we rely on can be found [in this Wiki article](https://github.com/drink-this/drink-this-backend/wiki/Python-pyenv-Installation).
3. Bundle install
4. Configure API keys:

    - Run `bundle exec figaro install` for [Figaro](https://github.com/laserlemon/figaro) to generate an application.yml file where secure information can be stored locally
    - Create an app and retrieve an API key from the [Yelp Fusion API](https://www.yelp.com/developers/documentation/v3/authentication)
    - Sign up to get an API key for [TheCocktailDB](https://www.thecocktaildb.com/api.php)

### Database schema
<img width="685" alt="Screen Shot 2021-08-05 at 8 12 40 AM" src="https://user-images.githubusercontent.com/10294841/128374788-a88a6835-a76b-44f1-9a8a-91c2dc9c3f11.png">
<!-- also explain dataset? -->

### Endpoints

NOTE: All endpoints require a user authorization token from OAuth

#### Request a recommendation

  `GET /recommendation`

  * User must have ratings prior to requesting a recommendation or the model will simply return a random cocktail

  <img width="1284" alt="recommendation_for_mojito" src="https://user-images.githubusercontent.com/26797256/128460346-6c9c4c50-2b51-4cf9-aa65-6dc352bbddaf.png">

#### Details for a given cocktail

  `GET /cocktail/:id`

  * Includes: Name, image, recipe (ingredients and measurements), directions, user rating (if applicable)
  * Requires a `cocktail_id` parameter

  <img width="1178" alt="cocktail_show_page" src="https://user-images.githubusercontent.com/26797256/128459231-5f231bd0-8feb-4f7f-93bf-44691688196b.png">

#### Create or update a user cocktail rating

  `POST /rating`
  
  * Requires `cocktail_id` and `stars` parameters
  * Stars parameter must be an integer from 1-5

#### Display 5 random cocktails for new user to rate

  `GET /dashboard`

  <img width="1287" alt="onboarding_dash" src="https://user-images.githubusercontent.com/26797256/128459778-a97bcf31-95b2-4316-9fe3-a607e4bff3d0.png">

#### Search cocktails by name

  `GET /search`

  * Requires a `name` parameter with a string or string fragment to search

  <img width="1181" alt="search_by_name" src="https://user-images.githubusercontent.com/26797256/128459781-69245f45-5486-4b3d-99f2-d0d83e8bb014.png">

#### Search Yelp for locations to find a specific cocktail

  `GET /search/yelp`

  <img width="1169" alt="search_yelp_for_cocktail" src="https://user-images.githubusercontent.com/26797256/128459772-438b2fb1-4ce1-455f-a45c-39cda860f737.png">

### How to run Test Suite

To run the full test suite, simply run `bundle exec rspec`.
Gems required for testing:
- [faker](https://github.com/faker-ruby/faker)
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
- [rspec-rails](https://github.com/rspec/rspec-rails)
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- [simplecov](https://github.com/simplecov-ruby/simplecov)
- [vcr](https://github.com/vcr/vcr)
- [webmock](https://github.com/bblimke/webmock)
- [rubocop](https://github.com/rubocop/rubocop)

### Deployment
<!-- touch on the sadness that is ruby+python -->
Since this Rails app also requires Python, both [this Ruby buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-ruby) and [this Python buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-python) are required for deploying to Heroku. The Python buildpack **must** be ordered **before** the Ruby buildpack. The Python buildpack includes a built in post compile hook, which will run the `bin/post_compile` script included in this app to ensure that Python is built with shared libraries enabled. This is required for your local environment as well. We have written some [basic instructions for installing Python](https://github.com/drink-this/drink-this-backend/wiki/Python-pyenv-Installation), but these may not work for all environments. The app requires Python 3.9.6 configred with shared libraries enabled on install.

### Future features
- Implement GraphQL
- Using the microservices approach on python, instead of using PyCall
- Implement Docker
- Update the recommendation model to a model-based approach using Python's ML libraries

### Contributers
<!-- each of us with links to github and linked in profiles -->
  * Mark Yen - [markcyen](https://github.com/markcyen)
  * Taija Warbelow - [twarbelow](https://github.com/twarbelow)
  * Molly Krumholz - [mkrumholz](https://github.com/mkrumholz)
  * Zach Green - [zachjamesgreen](https://github.com/zachjamesgreen)
  * Richard DeSilvey - [redferret](https://github.com/redferret)
  * Jermaine Braumuller - [Jaybraum](https://github.com/Jaybraum)
