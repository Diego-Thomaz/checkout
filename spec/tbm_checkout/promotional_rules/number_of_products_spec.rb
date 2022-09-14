# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TbmCheckout::PromotionalRules::NumberOfProducts do
  subject(:number_of_products_rule) { described_class.new(basket_items: basket_items, params: params).call }

  let(:params) do
    {
      product_code: '001',
      amount: 2,
      discount_price: 8.5
    }
  end

  context "when basket items satisfy rule's criteria" do
    let(:basket_items) do
      [
        { product_code: '001', name: 'Lavender heart', price: 9.25 },
        { product_code: '001', name: 'Lavender heart', price: 9.25 },
        { product_code: '002', name: 'ersonalised cufflinks', price: 45.0 },
        { product_code: '002', name: 'ersonalised cufflinks', price: 45.0 }
      ]
    end
    let(:basket_with_discount) do
      [
        { product_code: '001', name: 'Lavender heart', price: 8.5 },
        { product_code: '001', name: 'Lavender heart', price: 8.5 },
        { product_code: '002', name: 'ersonalised cufflinks', price: 45.0 },
        { product_code: '002', name: 'ersonalised cufflinks', price: 45.0 }
      ]
    end

    it 'returns basket with discounts applied' do
      expect(number_of_products_rule).to eq(basket_with_discount)
    end
  end

  context "when basket items do NOT satisfy rule's criteria" do
    let(:basket_items) do
      [
        { product_code: '001', name: 'Lavender heart', price: 9.25 },
        { product_code: '003', name: 'Lavender heart', price: 19.95 },
        { product_code: '002', name: 'ersonalised cufflinks', price: 45.0 },
        { product_code: '002', name: 'ersonalised cufflinks', price: 45.0 }
      ]
    end

    it 'returns original basket' do
      expect(number_of_products_rule).to eq(basket_items)
    end
  end
end
