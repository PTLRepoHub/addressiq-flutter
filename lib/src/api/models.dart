class AddressIQConfig {
  final String apiKey;
  final String apiUrl;
  final String sessionToken;
  final String? mapboxToken;
  final String? googleMapsApiKey;
  /// Stable end-user identifier passed to the widget. Falls back to the
  /// session token when omitted (the token already binds identity server-side).
  final String? appUserId;
  /// Business display name shown on the widget's intro/consent screens.
  final String? businessName;
  /// Override the hosted widget bundle URL (for local development).
  final String? widgetUrl;

  const AddressIQConfig({
    required this.apiKey,
    required this.apiUrl,
    required this.sessionToken,
    this.mapboxToken,
    this.googleMapsApiKey,
    this.appUserId,
    this.businessName,
    this.widgetUrl,
  });
}

class AddressData {
  double? lat;
  double? lon;
  String? placeId;
  String? formattedAddress;
  String propertyNumber;
  String? propertyName;
  String streetName;
  String buildingColor;
  String? directions;
  String? plusCode;
  List<String> photos;

  AddressData({
    this.lat,
    this.lon,
    this.placeId,
    this.formattedAddress,
    this.propertyNumber = '',
    this.propertyName,
    this.streetName = '',
    this.buildingColor = '',
    this.directions,
    this.plusCode,
    this.photos = const [],
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lon': lon,
    'placeId': placeId ?? 'sdk_manual',
    'formattedAddress': formattedAddress,
    'propertyNumber': propertyNumber,
    'streetName': streetName,
    'buildingColor': buildingColor,
    'propertyName': propertyName,
    'directions': directions,
    'plusCode': plusCode,
  };
}

/// Result of the Collect UI. The widget **collects only** — it saves the address
/// and returns its [locationCode]; it does NOT start a verification. Start
/// verification from the `onComplete` callback with
/// `AddressIQ.instance.startVerification(locationCode: ...)`.
class CollectResult {
  final String locationCode;
  final String? formattedAddress;
  final double? lat;
  final double? lon;
  final String? placeId;
  final bool isExisting;

  const CollectResult({
    required this.locationCode,
    this.formattedAddress,
    this.lat,
    this.lon,
    this.placeId,
    this.isExisting = false,
  });

  factory CollectResult.fromJson(Map<String, dynamic> json) => CollectResult(
    locationCode: json['locationCode'] as String,
    formattedAddress: json['formattedAddress'] as String?,
    isExisting: json['isExisting'] as bool? ?? false,
  );
}

class VerifyResult {
  final String verificationCode;
  final String locationCode;
  final String status;

  const VerifyResult({
    required this.verificationCode,
    required this.locationCode,
    required this.status,
  });

  factory VerifyResult.fromJson(Map<String, dynamic> json) => VerifyResult(
    verificationCode: json['verificationCode'] as String,
    locationCode: json['locationCode'] as String,
    status: json['status'] as String,
  );
}

class VerificationStatus {
  final String verificationId;
  final String status;
  final double? confidenceScore;
  final String? dataQuality;
  final int eventsCollected;

  const VerificationStatus({
    required this.verificationId,
    required this.status,
    this.confidenceScore,
    this.dataQuality,
    this.eventsCollected = 0,
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) => VerificationStatus(
    verificationId: json['verificationId'] as String,
    status: json['status'] as String,
    confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
    dataQuality: json['dataQuality'] as String?,
    eventsCollected: json['eventCount'] as int? ?? 0,
  );
}

class LocationEvent {
  final double lat;
  final double lon;
  final double accuracyM;
  final String deviceTs;
  final String eventType;
  final String? activityType;
  final int? batteryLevel;
  final bool? isCharging;

  const LocationEvent({
    required this.lat,
    required this.lon,
    required this.accuracyM,
    required this.deviceTs,
    this.eventType = 'BACKGROUND_CHECK',
    this.activityType,
    this.batteryLevel,
    this.isCharging,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lon': lon,
    'accuracyM': accuracyM,
    'deviceTs': deviceTs,
    'eventType': eventType,
    'activityType': activityType,
    'batteryLevel': batteryLevel,
    'isCharging': isCharging,
    'deviceOs': 'ANDROID', // Detected at runtime
    'sdkVersion': '0.3.0',
  };
}
