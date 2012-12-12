class UsState
  NAMES = [
    [ "Alabama", "AL" ],
    [ "Alaska", "AK" ],
    [ "Arizona", "AZ" ],
    [ "Arkansas", "AR" ],
    [ "California", "CA" ],
    [ "Colorado", "CO" ],
    [ "Connecticut", "CT" ],
    [ "Delaware", "DE" ],
    [ "District Of Columbia", "DC" ],
    [ "Florida", "FL" ],
    [ "Georgia", "GA" ],
    [ "Hawaii", "HI" ],
    [ "Idaho", "ID" ],
    [ "Illinois", "IL" ],
    [ "Indiana", "IN" ],
    [ "Iowa", "IA" ],
    [ "Kansas", "KS" ],
    [ "Kentucky", "KY" ],
    [ "Louisiana", "LA" ],
    [ "Maine", "ME" ],
    [ "Maryland", "MD" ],
    [ "Massachusetts", "MA" ],
    [ "Michigan", "MI" ],
    [ "Minnesota", "MN" ],
    [ "Mississippi", "MS" ],
    [ "Missouri", "MO" ],
    [ "Montana", "MT" ],
    [ "Nebraska", "NE" ],
    [ "Nevada", "NV" ],
    [ "New Hampshire", "NH" ],
    [ "New Jersey", "NJ" ],
    [ "New Mexico", "NM" ],
    [ "New York", "NY" ],
    [ "North Carolina", "NC" ],
    [ "North Dakota", "ND" ],
    [ "Ohio", "OH" ],
    [ "Oklahoma", "OK" ],
    [ "Oregon", "OR" ],
    [ "Pennsylvania", "PA" ],
    [ "Rhode Island", "RI" ],
    [ "South Carolina", "SC" ],
    [ "South Dakota", "SD" ],
    [ "Tennessee", "TN" ],
    [ "Texas", "TX" ],
    [ "Utah", "UT" ],
    [ "Vermont", "VT" ],
    [ "Virginia", "VA" ],
    [ "Washington", "WA" ],
    [ "West Virginia", "WV" ],
    [ "Wisconsin", "WI" ],
    [ "Wyoming", "WY" ]
  ]

  TIME_ZONES = [
    ['Eastern Time (US & Canada)'],
    ['Central Time (US & Canada)'],
    ['Mountain Time (US & Canada)'],
    ['Pacific Time (US & Canada)'],
    ['Arizona'],
    ['Indiana (East)'],
    ['Hawaii'],
    ['Alaska'],
    ['America/Juneau'],
    ['Pacific/Honolulu']
  ]

  def self.state_expansion(state)
    state_exp = UsState::NAMES.find {|n| n.include? state}
    return state_exp.first if state_exp.present?
    return nil
  end

  def self.get_time_zone(state)
    case state
    when "AL" ; "Central Time (US & Canada)"
    when "AK" ; "America/Juneau"
    when "AZ" ; "Mountain Time (US & Canada)"
    when "AR" ; "Central Time (US & Canada)"
    when "CA" ; "Pacific Time (US & Canada)"
    when "CO" ; "Mountain Time (US & Canada)"
    when "CT" ; "Eastern Time (US & Canada)"
    when "DE" ; "Eastern Time (US & Canada)"
    when "DC" ; "Eastern Time (US & Canada)"
    when "FL" ; "Eastern Time (US & Canada)"
    when "GA" ; "Eastern Time (US & Canada)"
    when "HI" ; "Pacific/Honolulu"
    when "ID" ; "Mountain Time (US & Canada)"
    when "IL" ; "Central Time (US & Canada)"
    when "IN" ; "Eastern Time (US & Canada)"
    when "IA" ; "Central Time (US & Canada)"
    when "KS" ; "Central Time (US & Canada)"
    when "KY" ; "Central Time (US & Canada)"
    when "LA" ; "Central Time (US & Canada)"
    when "ME" ; "Eastern Time (US & Canada)"
    when "MD" ; "Eastern Time (US & Canada)"
    when "MA" ; "Eastern Time (US & Canada)"
    when "MI" ; "Eastern Time (US & Canada)"
    when "MN" ; "Central Time (US & Canada)"
    when "MS" ; "Central Time (US & Canada)"
    when "MO" ; "Central Time (US & Canada)"
    when "MT" ; "Mountain Time (US & Canada)"
    when "NE" ; "Central Time (US & Canada)"
    when "NV" ; "Pacific Time (US & Canada)"
    when "NH" ; "Eastern Time (US & Canada)"
    when "NJ" ; "Eastern Time (US & Canada)"
    when "NM" ; "Mountain Time (US & Canada)"
    when "NY" ; "Eastern Time (US & Canada)"
    when "NC" ; "Eastern Time (US & Canada)"
    when "ND" ; "Central Time (US & Canada)"
    when "OH" ; "Eastern Time (US & Canada)"
    when "OK" ; "Central Time (US & Canada)"
    when "OR" ; "Pacific Time (US & Canada)"
    when "PA" ; "Eastern Time (US & Canada)"
    when "RI" ; "Eastern Time (US & Canada)"
    when "SC" ; "Eastern Time (US & Canada)"
    when "SD" ; "Mountain Time (US & Canada)"
    when "TN" ; "Central Time (US & Canada)"
    when "TX" ; "Central Time (US & Canada)"
    when "UT" ; "Mountain Time (US & Canada)"
    when "VT" ; "Eastern Time (US & Canada)"
    when "VA" ; "Eastern Time (US & Canada)"
    when "WA" ; "Pacific Time (US & Canada)"
    when "WV" ; "Eastern Time (US & Canada)"
    when "WI" ; "Central Time (US & Canada)"
    when "WY" ; "Mountain Time (US & Canada)"
    else ; "Eastern Time (US & Canada)"
    end
  end
end