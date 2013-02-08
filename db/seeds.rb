# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# bronze silver gold platinum diamond

Plan.all.each{ |p| p.destroy }

Plan.create([
    {stripe_id: "robocent_temp", amount: "500", currency: "usd", interval: "month",
      name: "Basic", trial_period_days: "14", minimum_numbers: "0",
      maximum_numbers: "500", price_per_call_or_text: "1.5", free_credit: "7.5"}
  ])

#Plan.create([
#  {stripe_id: "plan_1", amount: "500", currency: "usd", interval: "month",
#    name: "Basic", trial_period_days: "14", minimum_numbers: "0",
#    maximum_numbers: "500", price_per_call_or_text: "2", free_credit: "10"},
#  {stripe_id: "plan_2", amount: "900", currency: "usd", interval: "month",
#    name: "Bronze", trial_period_days: "14", minimum_numbers: "501",
#    maximum_numbers: "1000", price_per_call_or_text: "1.9", free_credit: "10"},
#  {stripe_id: "plan_3", amount: "1900", currency: "usd", interval: "month",
#    name: "Silver", trial_period_days: "14", minimum_numbers: "1001",
#    maximum_numbers: "10000", price_per_call_or_text: "1.7", free_credit: "10"},
#  {stripe_id: "plan_4", amount: "3900", currency: "usd", interval: "month",
#    name: "Gold", trial_period_days: "14", minimum_numbers: "10001",
#    maximum_numbers: "25000", price_per_call_or_text: "1.5", free_credit: "10"},
#  {stripe_id: "plan_5", amount: "5900", currency: "usd", interval: "month",
#    name: "Platinum", trial_period_days: "14", minimum_numbers: "25001",
#    maximum_numbers: "50000", price_per_call_or_text: "1.3", free_credit: "10"}
#  ])