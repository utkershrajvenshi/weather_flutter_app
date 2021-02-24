# weather_flutter_app
A weather application built with Flutter and Dart.

The app requests location permissions on first boot. Thereafter, gathers weather data at current location and passes the decoded JSON to another screen in the Navigator stack.
The HomeScreen is updated with the given values showing location name, temperature in degree Celsius, a short weather description, sunrise and sunset timings and updates weather icon accordingly. The color scheme also updates depending on if it's currently day or night.
There's also a functionality to view weather data for another city. It also shows hourly forecast for the next 24 hours. Tapping the extended Floating Action Button redirects to 'Next 7 days' screen.

The full user interface in action can be viewed through this video: https://youtu.be/Ma1a_c7n1v0
