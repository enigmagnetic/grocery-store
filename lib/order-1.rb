require 'csv'

module Grocery
  class Order
    attr_reader :id, :products

    def initialize(id, products)
      @id = id
      @products = products
    end

    def self.all
      orders = []
      ObjectSpace.each_object(self) do |order|
        orders << order
      end
      orders
    end

      # `self.find(id)` - returns an instance of `Order` where the value of the id field in the CSV matches the passed parameter.

    def self.find(id_num)
      orders = Order.all
      ids = []
      orders.each do |order|
        ids << order.id
        return order if order.id == id_num
      end
      if !(ids.include?(id_num))
        return "Invalid Order Number"
      end
    end

    def total
      sum = 0
      @products.each_value do |price|
        sum += price
      end
      (sum * 1.075).round(2)
    end

    def add_product(product_name, product_price)
      if @products[product_name] == nil
        @products.store(product_name, product_price)
        return true
      else
        return false
      end
    end

    def remove_product(product_name)
      if @products[product_name] == nil
        return false
      else
        @products.delete(product_name)
        return true
      end
    end
  end
end

CSV.open('./support/orders.csv', "r", headers: true).each do |row|
  order_products = row["products"].split(";")
  products = {}
  order_products.each do |product_price|
    product_hash = product_price.split(":")
    products.store(product_hash[0], product_hash[1].to_f)
  end
  Grocery::Order.new(row["id"].to_i, products)
end
