import 'package:flutter/material.dart';

class WeatherIconService extends StatelessWidget {
  final int conditionId;
  final String iconCode;

  const WeatherIconService({
    super.key,
    required this.conditionId,
    required this.iconCode,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the asset filename
    String assetName;

    if (conditionId == 800 || conditionId == 801 || conditionId == 802) {
      // Use iconCode to determine day or night
      if (iconCode.endsWith('d')) {
        assetName =
            '$conditionId'
            'd.png';
      } else if (iconCode.endsWith('n')) {
        assetName =
            '$conditionId'
            'n.png';
      } else {
        // Fallback if iconCode is unexpected
        assetName = 'error.png';
      }
    } else {
      // For other conditionIds, use the id directly
      assetName = '$conditionId.png';
    }

    // Construct the full asset path
    String assetPath = 'assets/icons/$assetName';

    // Display the image
    return Image.asset(
      assetPath,
      width: 256,
      errorBuilder: (context, error, stackTrace) {
        // Deafult icon when the asset is not found
        return Image.asset('assets/icons/error.png', width: 256);
      },
    );
  }
}
