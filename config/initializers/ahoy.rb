class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false
Ahoy.visit_duration = 1.minutes
Ahoy.visitor_duration = 1.minutes

# botのアクセスを記録(テスト用)
# Ahoy.track_bots = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false
