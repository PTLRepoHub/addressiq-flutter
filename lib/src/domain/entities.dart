// Domain layer — pure value types. No Flutter imports, no HTTP, no SQLite.
// Conforms to docs/sdk-contract.md §1-§3.

enum SdkLifecycleState { uninitialized, idle, collecting, paused, terminated }

class SdkUser {
  final String appUserId;
  final String? phone;
  final String? email;
  final String? firstName;
  final String? lastName;

  const SdkUser({
    required this.appUserId,
    this.phone,
    this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'appUserId': appUserId,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
      };
}

class VerificationLifecycleState {
  final SdkLifecycleState state;
  final String? appUserId;
  final String? verificationId;
  final String? locationCode;
  final Duration? pausedFor;

  const VerificationLifecycleState({
    required this.state,
    this.appUserId,
    this.verificationId,
    this.locationCode,
    this.pausedFor,
  });
}

class StartPhysicalArgs {
  final String locationCode;
  final String provider;
  final String? agentId;
  final int? slaHours;
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final String? branchId;

  const StartPhysicalArgs({
    required this.locationCode,
    required this.provider,
    this.agentId,
    this.slaHours,
    this.metadata,
    this.idempotencyKey,
    this.branchId,
  });
}

class StartCombinedArgs {
  final String locationCode;
  final String physicalProvider;
  final String? digitalProvider;
  final bool startDigital;
  final String? agentId;
  final int? slaHours;
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final String? branchId;

  const StartCombinedArgs({
    required this.locationCode,
    required this.physicalProvider,
    this.digitalProvider,
    this.startDigital = true,
    this.agentId,
    this.slaHours,
    this.metadata,
    this.idempotencyKey,
    this.branchId,
  });
}

class LocationEnvelope {
  final String locationCode;
  final double lat;
  final double lon;
  final int geofenceRadiusM;
  final int adaptiveGeofenceRadiusMeters;
  final String? environmentBucket;
  final String status;

  const LocationEnvelope({
    required this.locationCode,
    required this.lat,
    required this.lon,
    required this.geofenceRadiusM,
    required this.adaptiveGeofenceRadiusMeters,
    this.environmentBucket,
    required this.status,
  });

  factory LocationEnvelope.fromJson(Map<String, dynamic> json) => LocationEnvelope(
        locationCode: json['locationCode'] as String,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        geofenceRadiusM: (json['geofenceRadiusM'] as num).toInt(),
        adaptiveGeofenceRadiusMeters: (json['adaptiveGeofenceRadiusMeters'] as num).toInt(),
        environmentBucket: json['environmentBucket'] as String?,
        status: json['status'] as String,
      );
}

class SdkError implements Exception {
  final String code;
  final String message;
  final String? docsUrl;
  const SdkError(this.code, this.message, {this.docsUrl});
  @override
  String toString() => 'SdkError($code): $message';
}
