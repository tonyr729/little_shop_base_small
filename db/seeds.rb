require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant)

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

inactive_merchant_1 = create(:inactive_merchant)
inactive_user_1 = create(:inactive_user)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
create_list(:item, 10, user: merchant_1)

inactive_item_1 = create(:inactive_item, user: merchant_1)
inactive_item_2 = create(:inactive_item, user: inactive_merchant_1)

Random.new_seed
rng = Random.new

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: rng.rand(3).days.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: rng.rand(23).hour.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: rng.rand(5).days.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1, created_at: rng.rand(23).hour.ago, updated_at: rng.rand(59).minutes.ago)

order = create(:order, user: user)
create(:order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: rng.rand(23).days.ago, updated_at: rng.rand(23).hours.ago)

order = create(:cancelled_order, user: user)
create(:order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: rng.rand(23).hour.ago, updated_at: rng.rand(59).minutes.ago)
create(:order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: rng.rand(23).hour.ago, updated_at: rng.rand(59).minutes.ago)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: rng.rand(4).days.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: rng.rand(23).hour.ago, updated_at: rng.rand(59).minutes.ago)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 1, created_at: rng.rand(4).days.ago, updated_at: 1.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 9, created_at: rng.rand(4).days.ago, updated_at: 2.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 4, created_at: rng.rand(4).days.ago, updated_at: 3.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 5, created_at: rng.rand(4).days.ago, updated_at: 4.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 10, created_at: rng.rand(4).days.ago, updated_at: 5.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 8, created_at: rng.rand(4).days.ago, updated_at: 6.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 2, created_at: rng.rand(4).days.ago, updated_at: 7.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 7, created_at: rng.rand(4).days.ago, updated_at: 8.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 6, created_at: rng.rand(4).days.ago, updated_at: 9.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 12, created_at: rng.rand(4).days.ago, updated_at: 10.month.from_now)
order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 1, quantity: 3, created_at: rng.rand(4).days.ago, updated_at: 11.month.from_now)
