import 'dart:math' as math;

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const int earthRadius = 6371; // Radius of the earth in kilometers
  double latDistance = _toRadians(lat2 - lat1);
  double lonDistance = _toRadians(lon2 - lon1);
  double a = math.sin(latDistance / 2) * math.sin(latDistance / 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.sin(lonDistance / 2) *
          math.sin(lonDistance / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

double _toRadians(double degree) {
  return degree * (math.pi / 180);
}
