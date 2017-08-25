require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

require_relative '../lib/online_order'
require_relative '../lib/order'
# You may also need to require other classes here

# Because an OnlineOrder is a kind of Order, and we've
# already tested a bunch of functionality on Order,
# we effectively get all that testing for free! Here we'll
# only test things that are different.

describe "OnlineOrder" do
  describe "#initialize" do
    it "Is a kind of Order" do
      # Check that an OnlineOrder is in fact a kind of Order
      online_order = Grocery::OnlineOrder.new(1337, 3)
      online_order.must_be_kind_of Grocery::Order
    end

    it "Can access Customer object" do
      online_order = Grocery::OnlineOrder.new(1337, 3, :paid)
      online_order.must_respond_to :customer
      online_order.customer.must_equal 3
    end

    it "Can access the online order status" do
      online_order = Grocery::OnlineOrder.new(1337, 3, :paid)
      online_order.must_respond_to :status
      online_order.status.must_equal :paid
    end

    it "Has default order status of :pending" do
      online_order = Grocery::OnlineOrder.new(1337, 3)
      online_order.status.must_equal :pending
    end
  end

  describe "#total" do
    it "Adds a shipping fee" do
      reg_order = Grocery::Order.new(1337, {"banana" => 1.0, "apple" => 1.25, "whole milk" => 3.59})
      online_order = Grocery::OnlineOrder.new(1337, 3, :pending, {"banana" => 1.0, "apple" => 1.25, "whole milk" => 3.59})
      online_order.total.must_equal (reg_order.total + 10)
    end

    it "Doesn't add a shipping fee if there are no products" do
      online_order = Grocery::OnlineOrder.new(1337, 3)
      online_order.total.must_equal 0
    end
  end

  describe "#add_product" do
    it "Does not permit action for processing, shipped or completed statuses" do
      online_order = Grocery::OnlineOrder.new(1337, 3, :shipped, {"banana" => 1.0, "apple" => 1.25, "whole milk" => 3.59})
      online_order.add_product("olives", 4.59)
      online_order.products.has_key?("olives").must_equal false # TODO: Your test code here!
    end

    xit "Raise ArgumentError for processing, shipped, or completed statuses" do
      online_order = Grocery::OnlineOrder.new(1337, 3, :procesing, {"banana" => 1.0, "apple" => 1.25, "whole milk" => 3.59})
      online_order.add_product("olives", 4.59).must_raise ArgumentError
    end

    it "Permits action for pending and paid satuses" do
      online_order = Grocery::OnlineOrder.new(1337, 3, :paid, {"banana" => 1.0, "apple" => 1.25, "whole milk" => 3.59})
      online_order.add_product("olives", 4.59)
      online_order.products.has_key?("olives").must_equal true# TODO: Your test code here!
    end
  end

  describe "OnlineOrder.all" do
    it "Returns an array of all online orders" do
      Grocery::OnlineOrder.all.must_be_instance_of Array
      Grocery::OnlineOrder.all.each { |order| order.must_be_instance_of Grocery::OnlineOrder }
    end
    # TODO: Your test code here!
    # Useful checks might include:
    #   - OnlineOrder.all returns an array
    #   - Everything in the array is an Order
    #   - The number of orders is correct
    #   - The customer is present
    #   - The status is present
    # Feel free to split this into multiple tests if needed
    it "Has the correct number of orders" do
      Grocery::Order.all.length.must_equal 100
    end

    it "Has a customer and status for every order" do
      Grocery::OnlineOrder.all.each { |order| order.customer.wont_be_nil }
      Grocery::OnlineOrder.all.each { |order| order.status.must_be_instance_of Symbol }
    end
  end

  xdescribe "OnlineOrder.find_by_customer" do
    it "Returns an array of online orders for a specific customer ID" do
      # TODO: Your test code here!
    end
  end
end
