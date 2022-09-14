# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TbmCheckout::PromotionalRules do
  subject(:promotional_rules) { described_class.new(basket_items: basket_items, promotinal_rules: promotinal_rules) }

  let(:basket_items) { double([], sum: 10) } # rubocop:disable RSpec/VerifiedDoubles
  let(:number_of_products) { instance_spy(TbmCheckout::PromotionalRules::NumberOfProducts) }
  let(:total_amount) { instance_spy(TbmCheckout::PromotionalRules::TotalAmount) }
  let(:total_amount_spy) { class_spy(TbmCheckout::PromotionalRules::TotalAmount) }
  let(:number_of_products_spy) { class_spy(TbmCheckout::PromotionalRules::NumberOfProducts) }
  let(:number_of_products_rule) do
    {
      rule_type: :number_of_products,
      params: {
        product_code: '001',
        amount: 2,
        discount_price: 8.50
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

  describe '#apply_discount' do
    context 'when only product discount rule is present' do
      let(:promotinal_rules) { [number_of_products_rule] }

      before do
        allow(TbmCheckout::PromotionalRules::NumberOfProducts)
          .to receive(:new)
          .with(basket_items: basket_items, params: number_of_products_rule[:params])
          .and_return(number_of_products)
      end

      it 'calls the product discount class but does not call total discount', :aggregate_failures do
        promotional_rules.apply_discount

        expect(total_amount_spy).not_to have_received(:new)
        expect(number_of_products).to have_received(:call)
      end
    end

    context 'when only total amount rule is present' do
      let(:promotinal_rules) { [total_amount_rule] }

      before do
        allow(TbmCheckout::PromotionalRules::TotalAmount)
          .to receive(:new)
          .with(basket_total_amount: 10, params: total_amount_rule[:params])
          .and_return(total_amount)
      end

      it 'calls the total discount class but does not call product discount', :aggregate_failures do
        promotional_rules.apply_discount

        expect(number_of_products_spy).not_to have_received(:new)
        expect(total_amount).to have_received(:call)
      end
    end

    context 'when both rules are present' do
      let(:promotinal_rules) { [number_of_products_rule, total_amount_rule] }

      before do
        allow(TbmCheckout::PromotionalRules::NumberOfProducts)
          .to receive(:new)
          .with(basket_items: basket_items, params: number_of_products_rule[:params])
          .and_return(number_of_products)
        allow(TbmCheckout::PromotionalRules::TotalAmount)
          .to receive(:new)
          .with(basket_total_amount: 10, params: total_amount_rule[:params])
          .and_return(total_amount)
      end

      it 'calls both discount classes', :aggregate_failures do
        promotional_rules.apply_discount

        expect(number_of_products).to have_received(:call)
        expect(total_amount).to have_received(:call)
      end
    end
  end
end
