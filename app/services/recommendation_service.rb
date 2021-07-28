require 'pycall/import'
# require 'pandas'

class RecommendationService
  include PyCall::Import

  def self.say_hello
    # PyCall.import_module("pandas")
    # df = Pandas.read_csv("cocktail_ratings.csv")
    binding.pry
    math = PyCall.import_module("math")
    math.sin(math.pi / 4) - Math.sin(Math::PI / 4)
  end
end