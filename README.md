# OpenWeatherIOS

This project aims at fetching data from the OpenWeather API to show the location input by the user on a map. In addition to that, we need to show 4 locations (north, south, west and east) with 200 km distance from the input location. We need to compare the collected data and to analyze it in order to know details such as what is the windiest or the hottest location.

## Technical details
- Made with UIKit
- Use of MapKit to display the map and MKAnnotation to pin the location on the map.
- URLSession for fetching the data from the API.

## Todo  
- The 4 cities are yet to be determined.
- Once we know the cities, we need to compare their data and show the user a pop-up to display the data.
