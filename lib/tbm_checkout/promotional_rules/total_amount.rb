# frozen_string_literal: true

module TbmCheckout
  class PromotionalRules
    class TotalAmount
      def initialize(basket_total_amount:, params:)
        @basket_total_amount = basket_total_amount
        @discount_amount = params[:amount]
        @discount_percentage = params[:discount_percentage]
      end

      def call
        return basket_total_amount unless basket_total_amount_greater_than_discount_amount?

        apply_total_discount
      end

      private

      attr_reader :basket_total_amount, :discount_amount, :discount_percentage

      def basket_total_amount_greater_than_discount_amount?
        basket_total_amount > discount_amount
      end

      def apply_total_discount
        basket_total_amount.to_f - (discount_percentage.to_f / 100 * basket_total_amount.to_f)
      end
    end
  end
end
