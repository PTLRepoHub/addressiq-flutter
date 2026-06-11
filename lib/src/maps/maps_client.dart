import 'dart:convert';
import 'package:http/http.dart' as http;

/// A Places Autocomplete suggestion.
class PlaceSuggestion {
  final String placeId;
  final String primaryText;
  final String? secondaryText;
  const PlaceSuggestion({required this.placeId, required this.primaryText, this.secondaryText});
}

/// A place resolved to a canonical formatted address + coordinates.
class ResolvedPlace {
  final String formattedAddress;
  final double lat;
  final double lon;
  const ResolvedPlace({required this.formattedAddress, required this.lat, required this.lon});
}

/// Street View coverage from the (free) metadata endpoint.
class StreetViewCoverage {
  final bool available;
  final String? panoId;
  const StreetViewCoverage({required this.available, this.panoId});
}

/// Google Maps Platform REST clients for the Collect UI map flow.
///
/// Pure `http` — no native maps SDK (the map + Street View render in a WebView).
/// Every call is best-effort: on any error it resolves to an empty/null result
/// so the address step degrades to manual entry rather than throwing.
class MapsClient {
  final String apiKey;
  const MapsClient(this.apiKey);

  static const _placesBase = 'https://places.googleapis.com/v1';
  static const _mapsBase = 'https://maps.googleapis.com/maps/api';

  Future<List<PlaceSuggestion>> autocomplete(String input, {String? sessionToken}) async {
    if (input.isEmpty || apiKey.isEmpty) return const [];
    try {
      final res = await http.post(
        Uri.parse('$_placesBase/places:autocomplete'),
        headers: {'Content-Type': 'application/json', 'X-Goog-Api-Key': apiKey},
        body: jsonEncode({'input': input, if (sessionToken != null) 'sessionToken': sessionToken}),
      );
      if (res.statusCode != 200) return const [];
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final suggestions = (json['suggestions'] as List?) ?? const [];
      return suggestions
          .map((s) => (s as Map<String, dynamic>)['placePrediction'] as Map<String, dynamic>?)
          .where((p) => p != null && p['placeId'] is String)
          .map((p) {
        final sf = p!['structuredFormat'] as Map<String, dynamic>?;
        final main = (sf?['mainText'] as Map<String, dynamic>?)?['text'] as String?;
        final sec = (sf?['secondaryText'] as Map<String, dynamic>?)?['text'] as String?;
        final text = (p['text'] as Map<String, dynamic>?)?['text'] as String?;
        return PlaceSuggestion(placeId: p['placeId'] as String, primaryText: main ?? text ?? '', secondaryText: sec);
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<ResolvedPlace?> placeDetails(String placeId, {String? sessionToken}) async {
    if (placeId.isEmpty || apiKey.isEmpty) return null;
    try {
      final uri = Uri.parse('$_placesBase/places/$placeId')
          .replace(queryParameters: sessionToken != null ? {'sessionToken': sessionToken} : null);
      final res = await http.get(uri, headers: {'X-Goog-Api-Key': apiKey, 'X-Goog-FieldMask': 'formattedAddress,location'});
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final loc = json['location'] as Map<String, dynamic>?;
      final lat = loc?['latitude'] as double?;
      final lon = loc?['longitude'] as double?;
      if (lat == null || lon == null) return null;
      return ResolvedPlace(formattedAddress: json['formattedAddress'] as String? ?? '', lat: lat, lon: lon);
    } catch (_) {
      return null;
    }
  }

  Future<String?> reverseGeocode(double lat, double lon) async {
    if (apiKey.isEmpty) return null;
    try {
      final res = await http.get(Uri.parse('$_mapsBase/geocode/json?latlng=$lat,$lon&key=$apiKey'));
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['status'] != 'OK') return null;
      final results = (json['results'] as List?) ?? const [];
      if (results.isEmpty) return null;
      return (results.first as Map<String, dynamic>)['formatted_address'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<StreetViewCoverage> streetViewCoverage(double lat, double lon) async {
    if (apiKey.isEmpty) return const StreetViewCoverage(available: false);
    try {
      final res = await http.get(Uri.parse('$_mapsBase/streetview/metadata?location=$lat,$lon&key=$apiKey'));
      if (res.statusCode != 200) return const StreetViewCoverage(available: false);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['status'] != 'OK') return const StreetViewCoverage(available: false);
      return StreetViewCoverage(available: true, panoId: json['pano_id'] as String?);
    } catch (_) {
      return const StreetViewCoverage(available: false);
    }
  }
}
