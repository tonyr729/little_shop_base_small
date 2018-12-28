require 'rails_helper'

RSpec.describe Cart do
  it '.total_count' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })
    expect(cart.total_count).to eq(5)
  end

  it '.count_of' do
    cart = Cart.new({})
    expect(cart.count_of(5)).to eq(0)

    cart = Cart.new({
      '2' => 3
    })
    expect(cart.count_of(2)).to eq(3)
  end

  it '.add_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.add_item(1)
    cart.add_item(2)
    cart.add_item(3)

    expect(cart.contents).to eq({
      '1' => 3,
      '2' => 4,
      '3' => 1
      })
  end

  it '.items' do
    item_1, item_2 = create_list(:item, 2)
    cart = Cart.new({})
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)

    expect(cart.items).to eq([item_1, item_2])
  end
end