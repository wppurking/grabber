require 'mongoid'
require 'active_support/core_ext'

class Listing
  include Mongoid::Document
  include Mongoid::Timestamps

  field :market, type: String
  field :asin, type: String
  field :title, type: String
  field :byWho, type: String
  field :review_score, type: Float
  field :likes, type: Integer
  field :price, type: Float
  field :sale, type: Float
  field :currency, type: String
  field :main_pic, type: String
  field :variation, type: Boolean, default: false

  field :also_bough, type: Array
  field :after_viewing, type: Array

  field :product_desc, type: String
  field :promotes, type: Array

  embeds_many :ranks

  # 每两份数据的最小间隔为 8 小时.
  def update_or_save(lst_obj)
    if self.created_at - Time.now > 8.hours
      # 保存新的
    else
      # 更新老的
      lst_obj.each do |k, v|
        case k
          when 'seller_rank'
            self.ranks = Rank.rank(v)
          else
            # 自行更新
            self[k] = v
        end
      end
    end
  end

end