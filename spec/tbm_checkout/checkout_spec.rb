# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TbmCheckout::Checkout do
  subject(:checkout) { described_class.new(promotinal_rules) }

  let(:promotinal_rules) { [] }
  let(:product_code1) { '001' }
  let(:product_code2) { '002' }
  let(:product_code3) { '003' }
  let(:products) do
    [
      { product_code: product_code1, name: 'Lavender heart', price: 9.25 },
      { product_code: product_code2, name: 'Personalised cufflinks', price: 45.00 },
      { product_code: product_code3, name: 'Kids T-shirt', price: 19.95 }
    ]
  end

  describe '#scan' do
    it 'adds an object to the basket', :aggregate_failures do
      basket_items = checkout.instance_variable_get(:@basket_items)

      expect { checkout.scan(product_code1) }.to change(basket_items, :count).by(1)
      expect(basket_items).to contain_exactly(an_object_having_attributes(products.first))
    end
  end

  describe '#total' do
    context 'when promotional_rules is nil' do
      let(:promotinal_rules) { nil }
      let(:expected_price) { products.first[:price] * 3 }

      before do
        checkout.scan(product_code1)
        checkout.scan(product_code1)
        checkout.scan(product_code1)
      end

      it { expect(checkout.total).to eq("Total price expected: £#{expected_price}") }
    end

    context 'when promotional_rules is not nil' do
      let(:discount_price) { 8.5 }
      let(:number_of_products_rule) do
        {
          rule_type: :number_of_products,
          params: {
            product_code: product_code1,
            amount: 2,
            discount_price: discount_price
          }
        }
      end
      let(:total_amount_rule) do
        {
          rule_type: :total_amount,
          params: {
            amount: 60,
            discount_percentage: 10
          }
        }
      end

      context 'when only number_of_products rule is present' do
        let(:promotinal_rules) { [number_of_products_rule] }
        let(:expected_price) { (discount_price * 2) + products.last[:price] }

        before do
          checkout.scan(product_code1)
          checkout.scan(product_code3)
          checkout.scan(product_code1)
        end

        it { expect(checkout.total).to eq("Total price expected: £#{expected_price}") }
      end

      context 'when only total_amount rule is present' do
        let(:promotinal_rules) { [total_amount_rule] }
        let(:expected_price_with_discount) { 66.78 }

        before do
          checkout.scan(product_code1)
          checkout.scan(product_code2)
          checkout.scan(product_code3)
        end

        it { expect(checkout.total).to eq("Total price expected: £#{expected_price_with_discount}") }
      end

      context 'when both rules are present' do
        let(:promotinal_rules) { [number_of_products_rule, total_amount_rule] }
        let(:expected_price_with_discount) { 73.76 }

        before do
          checkout.scan(product_code1)
          checkout.scan(product_code2)
          checkout.scan(product_code1)
          checkout.scan(product_code3)
        end

        it { expect(checkout.total).to eq("Total price expected: £#{expected_price_with_discount}") }
      end
    end
  end
end
