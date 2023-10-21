import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class ReverseGeocodeClient {
  static const String base = 'api.bigdatacloud.net';

  Future<String> postionReverse(XPosition position) async {
    var response = await get(Uri.https(base, '/data/reverse-geocode-client', {
      'latitude': position.latitude,
      'longitude': position.longitude,
    })).onError((error, stackTrace) => Response('', 500));
    var contentType = response.headers['content-type'];
    if (contentType?.contains('application/json') != true ||
        response.statusCode != 200) {
      return 'unknown';
    }
    var data = json.decode(response.body);

    var locality = data['locality'];
    var principalSubdivisionCode = data['principalSubdivisionCode'];

    return [locality, principalSubdivisionCode].join(', ');
  }
}

class XPosition {
  final String longitude;
  final String latitude;

  factory XPosition.fromPosition(Position position) {
    return XPosition(
        longitude: position.longitude.toString(),
        latitude: position.latitude.toString());
  }

  XPosition({required this.longitude, required this.latitude});
}

void main(List<String> args) async {
  await ReverseGeocodeClient().postionReverse(
      XPosition(latitude: '22.98313020546147', longitude: '88.15235403273307'));
}
