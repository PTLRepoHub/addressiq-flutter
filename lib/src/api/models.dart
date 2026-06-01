class AddressIQConfig {
  final String apiKey;
  final String apiUrl;
  final String sessionToken;
  final String? mapboxToken;
  final String? googleMapsApiKey;

  const AddressIQConfig({
    required this.apiKey,
    required this.apiUrl,
    required this.sessionToken,
    this.mapboxToken,
    this.googleMapsApiKey,
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
    'propertyNumber': propertyNumber,
    'streetName': streetName,
    'buildingColor': buildingColor,
    'propertyName': propertyName,
    'directions': directions,
    'plusCode': plusCode,
  };
}

class VerifyResult {
  final String verificationId;
  final String locationId;
  final String status;

  const VerifyResult({
    required this.verificationId,
    required this.locationId,
    required this.status,
  });

  factory VerifyResult.fromJson(Map<String, dynamic> json) => VerifyResult(
    verificationId: json['verificationId'] as String,
    locationId: json['locationId'] as String,
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
