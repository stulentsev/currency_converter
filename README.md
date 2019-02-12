# What is it?

A small experiment with building DSL in ruby. 

# Why is it?

Once, after a business trip, I got super-bored while calculating proper amounts of 
work-related expenses (so that they can be put in an invoice for reimbursement). 
Here's what came out of that boredom.

# The problem

International business trips can involve expenses in different currencies. But for the purposes of accounting,
we need to convert them all to one currency. 

# The solution

Infuse ruby's numeric classes with additional methods, just like rails does with `60.minutes`.
So we can now do this:

``` ruby 
20.usd
10.50.eur
```

Plus, we add corresponding converter methods, `to_XXX`.

``` ruby 
20.usd.to_eur # => (17.7 eur)
```

Full example:

``` ruby 
require './converter.rb'

# currently, currencies are hardcoded and there are only three of them: usd, eur, rub.

# set up conversion rates. This can be fetched from the internet
ExchangeRate.add_rate(:usd, :rub, 68.7448)
ExchangeRate.add_rate(:eur, :rub, 78.4309)
ExchangeRate.add_rate(:eur, :usd, 1.13)

expenses = 11.eur + 1600.rub # => (11 eur, 1600 rub)
expenses += 2.5.eur
expenses += 30.usd
expenses # => (13.5 eur, 1600 rub, 30 usd)
expenses.to_usd # => (68.53 usd)
```
