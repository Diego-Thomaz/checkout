# frozen_string_literal: true

module TbmCheckout
  class Product
    attr_reader :list

    MOCKED_PRODUCTS = [
      { product_code: '001', name: 'Lavender heart', price: 9.25 },
      { product_code: '002', name: 'Personalised cufflinks', price: 45.00 },
      { product_code: '003', name: 'Kids T-shirt', price: 19.95 }
    ].freeze

    def initialize
      @list = MOCKED_PRODUCTS
    end
  end
end
