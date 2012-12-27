require 'mongoid'

class Listing
  include Mongoid::Document


  field :asin, type: String
end