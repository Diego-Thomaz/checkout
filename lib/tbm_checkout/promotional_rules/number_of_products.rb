# frozen_string_literal: true

module TbmCheckout
  class PromotionalRules
    class NumberOfProducts
      def initialize(basket_items:, params:)
        @basket_items = basket_items
        @product_code = params[:product_code]
        @amount = params[:amount]
        @discount_price = params[:discount_price]
      end

      def call
        return basket_items unless necessary_amount_of_products?

        apply_products_discount
      end

      private

      attr_reader :product_code, :amount, :discount_price, :basket_items

      def necessary_amount_of_products?
        matched_products.count >= amount
      end

      def matched_products
        @basket_items.select { |basket_item| basket_item[:product_code] == product_code }
      end

      def apply_products_discount
        basket_items.each do |basket_item|
          next unless basket_item[:product_code] == product_code

          basket_item[:price] = discount_price
        end
      end
    end
  end
end
