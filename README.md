# Weather App

A beautiful Flutter application that provides real-time weather information for locations around the world.

## Features

 -  Real-Time Weather Data: Display current temperature, weather conditions, and atmospheric details
 - Location Search: Search for any location worldwide to get weather information
 - Saved Locations: Automatically remembers your last viewed location
 - Offline Support: Checks for internet connectivity and provides appropriate feedback
 - Beautiful UI: Dynamic backgrounds that change based on weather conditions
 - Loading Animations: Shimmer effect animations during data loading

## Screenshots

<table> 
<tr>
<td><img src="assets/screenshots/welcome_screen.jpg" width=270 alt="Welcome Screen"></td>  <td><img src="assets/screenshots/search_screen.jpg" width=270 alt="Search Screen"></td>
<td><img src="assets/screenshots/loading_screen.jpg" width=270 alt="Loading Screen"></td>
</tr>
<tr>
<td><img src="assets/screenshots/location1.jpg" width=270 alt="Weather Screen1"></td> 
<td><img src="assets/screenshots/location2.jpg" width=270 alt="Weather Screen2"></td> 
<td><img src="assets/screenshots/no_internet.jpg" width=270 alt="No Internet Screen"></td> </tr> </table>

## Technologies Used
 - Flutter: Cross-platform UI framework
 - BLoC Pattern: State management using the BLoC architecture
 - OpenWeatherMap API: Weather data source
 - Shimmer: Loading animation effects
 - Shared Preferences: Local storage for saved locations
 - Connectivity Plus: Internet connection detection

## Getting Started

### Prerequisites
 - Flutter SDK (3.0 or later)
 - Dart SDK
 - OpenWeatherMap API key

### Installation

1. Clone the repository:
```bash
   git clone https://github.com/Ramith-Gunawardana/weather-app.git
```
2. Navigate to the project directory:
```bash
    cd weather-app
```
3. Create a `.env` file in the root directory and add your OpenWeatherMap API key:
```
    API_KEY=your_api_key_here
```
4. Install dependencies:
```bash
    flutter pub get
```
5. Run the app:
```bash
    flutter run
```
## Project Structure
```
lib/ 
│── blocs/ # BLoC state management files 
│   │── location_bloc/ # Handles location search functionality 
│   │── storage_bloc/ # Manages saved location data 
│   └── weather_bloc/ # Handles weather data fetching and states 
│── models/ # Data models for locations and weather 
│── repository/ # API communication and data handling 
│── screens/ # UI screens 
│── services/ # Utility services for connectivity, storage, etc. 
│── utils/ # Helper utilities and constants 
│── widgets/ # Reusable UI components 
└── main.dart # Application entry point
```

## State Management

The app uses the BLoC pattern with several state classes:
 - WeatherState: Initial, Loading, Loaded, Error
 - StorageState: Initial, Loading, Loaded, Saved, Error
 - LocationState: Initial, Loading, Loaded, Error

## Acknowledgements

 - [OpenWeatherMap](https://openweathermap.org/) for the weather data API
 - [Flutter](https://flutter.dev/) and its community for the amazing framework
 - [Glassmorphism Weather Icnons](https://www.figma.com/community/file/1283826005232351466) by Ilyas Mrayan
 - Icons made by [Icons8](https://icons8.com/)

 ## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.
