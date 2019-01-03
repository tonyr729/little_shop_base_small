class Item < ApplicationRecord
  before_save :generate_slug
  belongs_to :user, foreign_key: 'merchant_id'
  has_many :order_items
  has_many :orders, through: :order_items

  validates_presence_of :name, :description
  validates :slug, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :inventory, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def self.item_popularity(count, order)
    Item.joins(:order_items)
      .select("items.*, sum(order_items.quantity) as total_ordered")
      .order("total_ordered #{order}")
      .group(:id)
      .limit(count)
  end

  def self.popular_items(count)
    item_popularity(count, :desc)
  end

  def self.unpopular_items(count)
    item_popularity(count, :asc)
  end

  def avg_fulfillment_time
    results = ActiveRecord::Base.connection.execute("select avg(updated_at - created_at) as avg_f_time from order_items where item_id=#{self.id} and fulfilled='t'")
    if results.present?
      return results.first['avg_f_time']
    else
      return nil
    end
  end

  def ever_ordered?
    OrderItem.find_by_item_id(self.id) !=  nil
  end

  def to_param
    slug
  end

  private

    def slug_check(slug)
      if Item.where(slug: slug).exists?
        slug = "#{slug}-#{(Item.where("slug LIKE ?", "%#{slug}%").count + 1)}"
      end
      slug
    end

    def generate_slug
      slug = "#{ name.downcase.parameterize }" if name
      self.slug = slug_check(slug) if name
    end
end