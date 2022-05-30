# OpenWeatherIOS

This app fetches data from the OpenWeather API to show the location input by the user on a map. In addition to that, we need to show 4 locations (north, south, west and east) with 200 km distance from the input location. We need to compare the collected data and to analyze it in order to know details such as what is the windiest or the hottest location.

The user can search a town by its name or its ZIP code. When searching by the ZIP code, the user will be asked to pick the country of the town.

## Technical details
- Made with UIKit
- Use of MapKit to display the map and MKAnnotation to pin the location on the map.
- URLSession for fetching the data from the API.
- MVVM pattern
- 3rd party libraries:
    - [Alerts and Pickers](https://github.com/MahmoudMMB/MMBAlertsPickers)

