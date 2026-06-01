import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../api/addressiq_api.dart';
import '../api/models.dart';
import 'storage.dart';

class LocationCollector {
  final AddressIQApi api;
  final String locationId;
  final String verificationId;

  StreamSubscription<Position>? _positionStream;
  Timer? _flushTimer;
  Timer? _heartbeatTimer;
  bool _optedOut = false;

  LocationCollector({
    required this.api,
    required this.locationId,
    required this.verificationId,
  });

  bool get isOptedOut => _optedOut;

  /// Check and request location permissions.
  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Start collecting location.
  Future<bool> start() async {
    if (_optedOut) return false;

    final granted = await requestPermissions();
    if (!granted) return false;

    // Save config for persistence
    await AddressIQStorage.saveConfig({
      'apiUrl': api.apiUrl,
      'apiKey': api.apiKey,
      'locationId': locationId,
      'verificationId': verificationId,
    });

    // Take immediate high-accuracy reading
    try {
      final position = await Geolocator.getCurrentPosition();
      await _processPosition(position, 'APP_OPEN');
      await _flushQueue();
    } catch (_) {}

    // Start continuous position stream
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
        timeLimit: Duration(minutes: 15),
      ),
    ).listen(
      (position) => _processPosition(position, 'BACKGROUND_CHECK'),
      onError: (_) {},
    );

    // Periodic flush (every 60s)
    _flushTimer = Timer.periodic(const Duration(seconds: 60), (_) => _flushQueue());

    // Heartbeat (every 45 min)
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 45), (_) {
      api.heartbeat(locationId).catchError((_) {});
    });

    return true;
  }

  /// Stop collecting and flush remaining events.
  Future<void> stop() async {
    await _positionStream?.cancel();
    _positionStream = null;
    _flushTimer?.cancel();
    _flushTimer = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    await _flushQueue();
    await AddressIQStorage.clearConfig();
  }

  /// Opt out — stop + clear all data.
  Future<void> optOut() async {
    _optedOut = true;
    await stop();
    await AddressIQStorage.clearAll();
  }

  /// Opt back in.
  void optIn() => _optedOut = false;

  Future<void> _processPosition(Position pos, String eventType) async {
    final event = LocationEvent(
      lat: pos.latitude,
      lon: pos.longitude,
      accuracyM: pos.accuracy,
      deviceTs: DateTime.now().toUtc().toIso8601String(),
      eventType: eventType,
    );
    await AddressIQStorage.pushEvents([event]);
  }

  Future<void> _flushQueue() async {
    final size = await AddressIQStorage.queueSize();
    if (size == 0) return;

    final batch = await AddressIQStorage.popEvents(10);
    if (batch.isEmpty) return;

    try {
      final events = batch.map((json) => LocationEvent(
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        accuracyM: (json['accuracyM'] as num).toDouble(),
        deviceTs: json['deviceTs'] as String,
        eventType: json['eventType'] as String? ?? 'BACKGROUND_CHECK',
      )).toList();

      await api.sendEvents(locationId, events);
    } catch (_) {
      await AddressIQStorage.returnEvents(batch);
    }
  }
}
