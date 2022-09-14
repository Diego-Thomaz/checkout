# frozen_string_literal: true

module TbmCheckout
  class Basket
    BasketItems = Struct.new(:product_code, :name, :price)

    def add(item_id)
      @item_id = item_id

      BasketItems.new(product[:product_code], product[:name], product[:price])
    end

    private

    attr_reader :item_id

    def products
      @products ||= TbmCheckout::Product.new
    end

    def product
      product = products.list.find { |prod| prod[:product_code] == item_id }
      return product unless product.nil?

      raise TbmCheckout::Errors::ItemNotFound, "Item with id = #{item_id} not found!"
    end
  end
end
