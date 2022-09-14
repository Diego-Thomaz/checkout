# frozen_string_literal: true

require_relative '../tbm_checkout'

module TbmCheckout
  class Checkout
    def initialize(promotinal_rules)
      @promotinal_rules = promotinal_rules
      @basket_items = []
    end

    def scan(item_id)
      basket_items << basket.add(item_id)
    end

    def total
      "Total price expected: £#{calculate_total.round(2)}"
    end

    private

    attr_reader :promotinal_rules, :basket_items

    def basket
      @basket ||= TbmCheckout::Basket.new
    end

    def calculate_total
      return basket_items.sum(&:price) if promotinal_rules.nil?

      total_with_discounts
    end

    def total_with_discounts
      TbmCheckout::PromotionalRules.new(basket_items: basket_items, promotinal_rules: promotinal_rules).apply_discount
    end
  end
end
