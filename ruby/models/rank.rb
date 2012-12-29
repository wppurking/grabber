require 'mongoid'
# 排名
class Rank
  include Mongoid::Document

  field :rank, type: Integer
  field :category, type: String


  def self.rank(rank_ob_arr)
    ranks = []
    rank_ob_arr.each do |r|
      ranks << Rank.new(rank: r.rank, category: r.category)
    end
    ranks
  end

end
