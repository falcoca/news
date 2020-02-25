require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "08648ef4aff8fe4c83ffc7d9ed45ffd4"




get "/" do
#   # show a view that asks for the location
#   # lat: ± 90.0
#   # long: ± 180.0
#   @lat = rand(-90.0..90.0)
#   @long = rand(-180.0..180.0)
#   @lat_long = "#{@lat},#{@long}"
view "ask"
end

get "/news" do
  # do everything else
    @location = params["location"]
    # puts @location
    geocode = Geocoder.search(@location)
    # puts geocode
    lat_long = geocode.first.coordinates # => [lat, long]
    lat = lat_long[0]
    long = lat_long[1]
    "#{lat_long[0]} #{lat_long[1]}"
    @forecast = ForecastIO.forecast(lat,long).to_hash
    puts @forecast
   
    
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=4f241391ea354482876ecca4e5bc2a5b"
    @headlines = HTTParty.get(url).parsed_response.to_hash
   puts @headlines
    #news is now a Hash you can pretty print (pp) and parse for your output

     view "news"
end