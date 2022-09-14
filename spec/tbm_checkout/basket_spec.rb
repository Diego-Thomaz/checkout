# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TbmCheckout::Basket do
  describe '#add' do
    subject(:add_item_to_basket) { described_class.new.add(item_id) }

    context 'when product exists' do
      let(:item_id) { '001' }

      it 'adds an item to the basket' do
        expect(add_item_to_basket).to have_attributes(TbmCheckout::Product::MOCKED_PRODUCTS.first)
      end
    end

    context 'when product does not exists' do
      let(:item_id) { '004' }

      it 'raises an error' do
        message = "Item with id = #{item_id} not found!"
        expect { add_item_to_basket }.to raise_error(TbmCheckout::Errors::ItemNotFound, message)
      end
    end
  end
end
