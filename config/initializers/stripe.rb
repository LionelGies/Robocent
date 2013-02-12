if Rails.env.development?
  Stripe.api_key = "51pTllkUL4pYgbtvTgIKB1w9jmwB5rlc"     # test account
  STRIPE_PUBLIC_KEY = "pk_DweGs4CpPKKqpqowljPmTDHspqLiK"  # test account
elsif Rails.env.staging?
  Stripe.api_key = "51pTllkUL4pYgbtvTgIKB1w9jmwB5rlc"     # test account
  STRIPE_PUBLIC_KEY = "pk_DweGs4CpPKKqpqowljPmTDHspqLiK"  # test account
elsif Rails.env.production?
  Stripe.api_key = "f9PAGhXrJshG4poSeahhKWsMJYCdnJJy"     # Live account
  STRIPE_PUBLIC_KEY = "pk_7m20ihxDRnHWpCL5Dpl8KyCulHe8J"  # Live account
end