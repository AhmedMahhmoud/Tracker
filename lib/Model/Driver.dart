import 'package:geolocator/geolocator.dart';

class Driver {
  late String email, phone, status, username;
  late double latitude, longitude;
  Driver(
      {required this.email,
      required this.latitude,
      required this.longitude,
      required this.phone,
      required this.status,
      required this.username});
}
