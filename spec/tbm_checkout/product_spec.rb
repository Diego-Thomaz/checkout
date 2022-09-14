# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TbmCheckout::Product do
  subject(:product) { described_class.new }

  describe '#initialized' do
    it { expect(product.list).to match(described_class::MOCKED_PRODUCTS) }
  end
end
