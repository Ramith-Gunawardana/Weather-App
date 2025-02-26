import 'package:flutter/material.dart';

class WeatherGradients {
  static List<Color> getGradientsByWeatherId(int id, String iconCode) {
    // Thunderstorm (200-299)
    if (id >= 200 && id < 300) {
      return [
        const Color.fromARGB(255, 82, 87, 133),
        const Color.fromARGB(255, 26, 15, 56),
      ];
    }
    // Rain (300-399 and 500-599)
    else if ((id >= 300 && id < 400) || (id >= 500 && id < 600)) {
      return [
        const Color.fromARGB(255, 94, 100, 121),
        const Color.fromARGB(255, 22, 38, 54),
      ];
    }
    // Snow (600-699)
    else if (id >= 600 && id < 700) {
      return [
        const Color.fromARGB(255, 97, 121, 115),
        const Color.fromARGB(255, 26, 43, 48),
      ];
    }
    // Atmosphere/Fog (700-799)
    else if (id >= 700 && id < 800) {
      return [
        const Color.fromARGB(255, 111, 116, 126),
        const Color.fromARGB(255, 40, 41, 46),
      ];
    }
    // Clear (800)
    else if (id == 800) {
      // night
      if (iconCode.endsWith('n')) {
        return [
          const Color.fromARGB(255, 27, 36, 117),
          const Color.fromARGB(255, 43, 13, 92),
        ];
      }
      return [
        const Color.fromARGB(255, 42, 142, 240),
        const Color.fromARGB(255, 0, 69, 138),
      ];
    }
    // Clouds (801-899)
    else if (id > 800 && id < 900) {
      // night
      if (iconCode.endsWith('n')) {
        return [
          const Color.fromARGB(255, 27, 36, 117),
          const Color.fromARGB(255, 27, 4, 63),
        ];
      }
      return [
        const Color.fromARGB(255, 42, 142, 240),
        const Color.fromARGB(255, 0, 69, 138),
      ];
    }
    // Default gradient
    return [
      const Color.fromARGB(255, 42, 142, 240),
      const Color.fromARGB(255, 0, 69, 138),
    ];
  }
}
