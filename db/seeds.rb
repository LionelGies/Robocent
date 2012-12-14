# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# bronze silver gold platinum diamond

Plan.create([
  {stripe_id: "bronze", amount: "500", currency: "usd", interval: "month",
    name: "Bronze", trial_period_days: "30", minimum_numbers: "0",
    maximum_numbers: "500", price_per_call_or_text: "2"},
  {stripe_id: "silver", amount: "900", currency: "usd", interval: "month",
    name: "Silver", trial_period_days: "30", minimum_numbers: "501",
    maximum_numbers: "1000", price_per_call_or_text: "1.9"},
  {stripe_id: "gold", amount: "1900", currency: "usd", interval: "month",
    name: "Gold", trial_period_days: "30", minimum_numbers: "1001",
    maximum_numbers: "10000", price_per_call_or_text: "1.7"},
  {stripe_id: "platinum", amount: "3900", currency: "usd", interval: "month",
    name: "Platinum", trial_period_days: "30", minimum_numbers: "10001",
    maximum_numbers: "24500", price_per_call_or_text: "1.5"},
  {stripe_id: "diamond", amount: "5900", currency: "usd", interval: "month",
    name: "Diamond", trial_period_days: "30", minimum_numbers: "24501",
    maximum_numbers: "50000", price_per_call_or_text: "1.3"}
  ])