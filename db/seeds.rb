# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# bronze silver gold platinum diamond

#Plan.all.each{ |p| p.destroy }

Plan.create([
    {stripe_id: "pay_as_you_go", amount: "0", currency: "usd", interval: "month",
      name: "Pay As You Go", trial_period_days: "7", minimum_numbers: "0",
      maximum_numbers: "50000", price_per_call_or_text: "2", free_credit: "5",
      default: true, max_keywords: 1},

    {stripe_id: "basic", amount: "500", currency: "usd", interval: "month",
      name: "Basic", trial_period_days: "7", minimum_numbers: "0",
      maximum_numbers: "50000", price_per_call_or_text: "1.5", free_credit: "7.5",
      monthly_free_credit: "5.25", recurring: true, max_keywords: 3, card_required: true},

    {stripe_id: "advance", amount: "1900", currency: "usd", interval: "month",
      name: "Advance", trial_period_days: "7", minimum_numbers: "0",
      maximum_numbers: "50000", price_per_call_or_text: "1.4", free_credit: "10.50",
      monthly_free_credit: "24.50", recurring: true, max_keywords: 5, card_required: true},
        
    {stripe_id: "elite", amount: "4900", currency: "usd", interval: "month",
      name: "Elite", trial_period_days: "7", minimum_numbers: "0",
      maximum_numbers: "50000", price_per_call_or_text: "1.3", free_credit: "13.00",
      monthly_free_credit: "52.00", recurring: true, max_keywords: 10, card_required: true},
        
    {stripe_id: "high-usage", amount: "9900", currency: "usd", interval: "month",
      name: "High-Usage", trial_period_days: "7", minimum_numbers: "0",
      maximum_numbers: "50000", price_per_call_or_text: "1.2", free_credit: "18.00",
      monthly_free_credit: "102.00", recurring: true, max_keywords: 20, card_required: true}
  ])