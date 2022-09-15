# TbmCheckout
Simple checkout system written in Ruby only. It's possible to specify some promotional rules to get discounts on products.
Check the Specs for examples on how to build the rules.

This app also has some mock products and rules that can be used. Check the respective classes for more information.

## Installation

Clone the project and execute:

    $ bundle install

To use the code on Ruby terminal execute:

    $ irb -r ./lib/tbm_checkout

## Development
Simple Ruby app, following all Solid principles, DRY, KISS. However, there are some points that can be worked. A ruby script can be written to test it without the necessity to open in on the console. Also, some other methods can be implemented, such as remove an item from the basket. The promotional_rules logic can be enhanced, and instead of replacing the prices of the basket items, a new column can be added with the promotional prices, and use this column when filled.
