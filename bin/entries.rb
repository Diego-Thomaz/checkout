# frozen_string_literal: true

# !/usr/bin/env ruby

require_relative '../lib/tbm_checkout'

# ARGV[0] - Array of item_ids

TbmCheckout::Checkout.new(*ARGV[0])
