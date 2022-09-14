# frozen_string_literal: true

module TbmCheckout
  class PromotionalRules
    MOCKED_RULES = [
      {
        rule_type: :number_of_products,
        params: {
          product_code: '001',
          amount: 2,
          discount_price: 8.5
        }
      },
      {
        rule_type: :total_amount,
        params: {
          amount: 60,
          discount_percentage: 10
        }
      }
    ].freeze

    MAPPED_RULES = {
      number_of_products: 'TbmCheckout::PromotionalRules::NumberOfProducts',
      total_amount: 'TbmCheckout::PromotionalRules::TotalAmount'
    }.freeze

    def initialize(basket_items:, promotinal_rules:)
      @basket_items = basket_items
      @promotinal_rules = promotinal_rules.empty? ? MOCKED_RULES : promotinal_rules
    end

    def apply_discount
      apply_product_discounts if product_discount?

      total_discount? ? apply_total_discount : basket_total_amount
    end

    private

    attr_reader :basket_items, :promotinal_rules

    def product_discounts
      @product_discounts ||= promotinal_rules.select do |promo_rules|
        promo_rules[:rule_type] == :number_of_products
      end
    end

    def product_discount?
      product_discounts.count.positive?
    end

    def total_discount?
      total_discount.count.positive?
    end

    def total_discount
      @total_discount ||= promotinal_rules.select do |promo_rules|
        promo_rules[:rule_type] == :total_amount
      end
    end

    def apply_product_discounts
      product_discounts.each do |rule|
        Object.const_get(MAPPED_RULES[:number_of_products]).new(basket_items: basket_items, params: rule[:params]).call
      end
    end

    def apply_total_discount
      Object.const_get(MAPPED_RULES[:total_amount])
            .new(basket_total_amount: basket_total_amount, params: total_discount.first[:params])
            .call
    end

    def basket_total_amount
      basket_items.sum(&:price)
    end
  end
end
