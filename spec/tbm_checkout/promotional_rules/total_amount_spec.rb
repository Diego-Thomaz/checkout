# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TbmCheckout::PromotionalRules::TotalAmount do
  subject(:total_amount) { described_class.new(basket_total_amount: basket_total_amount, params: params).call }

  let(:params) do
    {
      amount: 60.0,
      discount_percentage: 10.0
    }
  end

  context 'when basket_total_amount is greater than the amount on the promotional rule' do
    let(:basket_total_amount) { 70.0 }
    let(:expected_price) { 63.0 }

    it 'applies the total discount' do
      expect(total_amount).to eq(expected_price)
    end
  end

  context 'when basket_total_amount is smaller than the amount on the promotional rule' do
    let(:basket_total_amount) { 50.0 }
    let(:expected_price) { 50.0 }

    it 'does not apply the total discount' do
      expect(total_amount).to eq(expected_price)
    end
  end
end
