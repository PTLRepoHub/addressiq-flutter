//
//  Generated code. Do not modify.
//  source: addressiq/v1/telemetry.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use transitEventTypeDescriptor instead')
const TransitEventType$json = {
  '1': 'TransitEventType',
  '2': [
    {'1': 'TRANSIT_EVENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'GEOFENCE_ENTER', '2': 1},
    {'1': 'GEOFENCE_EXIT', '2': 2},
    {'1': 'DWELL', '2': 3},
    {'1': 'APP_OPEN', '2': 4},
    {'1': 'BACKGROUND_CHECK', '2': 5},
    {'1': 'ACTIVITY_UPDATE', '2': 6},
  ],
};

/// Descriptor for `TransitEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transitEventTypeDescriptor = $convert.base64Decode(
    'ChBUcmFuc2l0RXZlbnRUeXBlEiIKHlRSQU5TSVRfRVZFTlRfVFlQRV9VTlNQRUNJRklFRBAAEh'
    'IKDkdFT0ZFTkNFX0VOVEVSEAESEQoNR0VPRkVOQ0VfRVhJVBACEgkKBURXRUxMEAMSDAoIQVBQ'
    'X09QRU4QBBIUChBCQUNLR1JPVU5EX0NIRUNLEAUSEwoPQUNUSVZJVFlfVVBEQVRFEAY=');

@$core.Deprecated('Use activityTypeDescriptor instead')
const ActivityType$json = {
  '1': 'ActivityType',
  '2': [
    {'1': 'ACTIVITY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'STILL', '2': 1},
    {'1': 'WALKING', '2': 2},
    {'1': 'RUNNING', '2': 3},
    {'1': 'IN_VEHICLE', '2': 4},
    {'1': 'ACTIVITY_UNKNOWN', '2': 5},
  ],
};

/// Descriptor for `ActivityType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List activityTypeDescriptor = $convert.base64Decode(
    'CgxBY3Rpdml0eVR5cGUSHQoZQUNUSVZJVFlfVFlQRV9VTlNQRUNJRklFRBAAEgkKBVNUSUxMEA'
    'ESCwoHV0FMS0lORxACEgsKB1JVTk5JTkcQAxIOCgpJTl9WRUhJQ0xFEAQSFAoQQUNUSVZJVFlf'
    'VU5LTk9XThAF');

@$core.Deprecated('Use deviceOsDescriptor instead')
const DeviceOs$json = {
  '1': 'DeviceOs',
  '2': [
    {'1': 'DEVICE_OS_UNSPECIFIED', '2': 0},
    {'1': 'IOS', '2': 1},
    {'1': 'ANDROID', '2': 2},
  ],
};

/// Descriptor for `DeviceOs`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceOsDescriptor = $convert.base64Decode(
    'CghEZXZpY2VPcxIZChVERVZJQ0VfT1NfVU5TUEVDSUZJRUQQABIHCgNJT1MQARILCgdBTkRST0'
    'lEEAI=');

@$core.Deprecated('Use integrityVerdictDescriptor instead')
const IntegrityVerdict$json = {
  '1': 'IntegrityVerdict',
  '2': [
    {'1': 'INTEGRITY_VERDICT_UNSPECIFIED', '2': 0},
    {'1': 'MEETS_BASIC', '2': 1},
    {'1': 'MEETS_DEVICE', '2': 2},
    {'1': 'MEETS_STRONG', '2': 3},
    {'1': 'UNAVAILABLE', '2': 4},
  ],
};

/// Descriptor for `IntegrityVerdict`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List integrityVerdictDescriptor = $convert.base64Decode(
    'ChBJbnRlZ3JpdHlWZXJkaWN0EiEKHUlOVEVHUklUWV9WRVJESUNUX1VOU1BFQ0lGSUVEEAASDw'
    'oLTUVFVFNfQkFTSUMQARIQCgxNRUVUU19ERVZJQ0UQAhIQCgxNRUVUU19TVFJPTkcQAxIPCgtV'
    'TkFWQUlMQUJMRRAE');

@$core.Deprecated('Use securityEnvelopeDescriptor instead')
const SecurityEnvelope$json = {
  '1': 'SecurityEnvelope',
  '2': [
    {'1': 'device_fingerprint_hash', '3': 1, '4': 1, '5': 9, '10': 'deviceFingerprintHash'},
    {'1': 'attestation_token', '3': 2, '4': 1, '5': 9, '10': 'attestationToken'},
    {'1': 'integrity_verdict', '3': 3, '4': 1, '5': 14, '6': '.addressiq.v1.IntegrityVerdict', '10': 'integrityVerdict'},
  ],
};

/// Descriptor for `SecurityEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List securityEnvelopeDescriptor = $convert.base64Decode(
    'ChBTZWN1cml0eUVudmVsb3BlEjYKF2RldmljZV9maW5nZXJwcmludF9oYXNoGAEgASgJUhVkZX'
    'ZpY2VGaW5nZXJwcmludEhhc2gSKwoRYXR0ZXN0YXRpb25fdG9rZW4YAiABKAlSEGF0dGVzdGF0'
    'aW9uVG9rZW4SSwoRaW50ZWdyaXR5X3ZlcmRpY3QYAyABKA4yHi5hZGRyZXNzaXEudjEuSW50ZW'
    'dyaXR5VmVyZGljdFIQaW50ZWdyaXR5VmVyZGljdA==');

@$core.Deprecated('Use transitEventDescriptor instead')
const TransitEvent$json = {
  '1': 'TransitEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'event_type', '3': 3, '4': 1, '5': 14, '6': '.addressiq.v1.TransitEventType', '10': 'eventType'},
    {'1': 'position', '3': 4, '4': 1, '5': 11, '6': '.addressiq.v1.GeoPoint', '10': 'position'},
    {'1': 'accuracy_m', '3': 5, '4': 1, '5': 1, '10': 'accuracyM'},
    {'1': 'distance_from_pin_m', '3': 6, '4': 1, '5': 1, '10': 'distanceFromPinM'},
    {'1': 'activity_type', '3': 7, '4': 1, '5': 14, '6': '.addressiq.v1.ActivityType', '10': 'activityType'},
    {'1': 'activity_confidence', '3': 8, '4': 1, '5': 5, '10': 'activityConfidence'},
    {'1': 'battery_level', '3': 9, '4': 1, '5': 5, '10': 'batteryLevel'},
    {'1': 'is_charging', '3': 10, '4': 1, '5': 8, '10': 'isCharging'},
    {'1': 'device_os', '3': 11, '4': 1, '5': 14, '6': '.addressiq.v1.DeviceOs', '10': 'deviceOs'},
    {'1': 'sdk_version', '3': 12, '4': 1, '5': 9, '10': 'sdkVersion'},
    {'1': 'device_timestamp', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'deviceTimestamp'},
    {'1': 'security', '3': 14, '4': 1, '5': 11, '6': '.addressiq.v1.SecurityEnvelope', '10': 'security'},
  ],
};

/// Descriptor for `TransitEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitEventDescriptor = $convert.base64Decode(
    'CgxUcmFuc2l0RXZlbnQSGQoIZXZlbnRfaWQYASABKAlSB2V2ZW50SWQSHwoLbG9jYXRpb25faW'
    'QYAiABKAlSCmxvY2F0aW9uSWQSPQoKZXZlbnRfdHlwZRgDIAEoDjIeLmFkZHJlc3NpcS52MS5U'
    'cmFuc2l0RXZlbnRUeXBlUglldmVudFR5cGUSMgoIcG9zaXRpb24YBCABKAsyFi5hZGRyZXNzaX'
    'EudjEuR2VvUG9pbnRSCHBvc2l0aW9uEh0KCmFjY3VyYWN5X20YBSABKAFSCWFjY3VyYWN5TRIt'
    'ChNkaXN0YW5jZV9mcm9tX3Bpbl9tGAYgASgBUhBkaXN0YW5jZUZyb21QaW5NEj8KDWFjdGl2aX'
    'R5X3R5cGUYByABKA4yGi5hZGRyZXNzaXEudjEuQWN0aXZpdHlUeXBlUgxhY3Rpdml0eVR5cGUS'
    'LwoTYWN0aXZpdHlfY29uZmlkZW5jZRgIIAEoBVISYWN0aXZpdHlDb25maWRlbmNlEiMKDWJhdH'
    'RlcnlfbGV2ZWwYCSABKAVSDGJhdHRlcnlMZXZlbBIfCgtpc19jaGFyZ2luZxgKIAEoCFIKaXND'
    'aGFyZ2luZxIzCglkZXZpY2Vfb3MYCyABKA4yFi5hZGRyZXNzaXEudjEuRGV2aWNlT3NSCGRldm'
    'ljZU9zEh8KC3Nka192ZXJzaW9uGAwgASgJUgpzZGtWZXJzaW9uEkUKEGRldmljZV90aW1lc3Rh'
    'bXAYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg9kZXZpY2VUaW1lc3RhbXASOg'
    'oIc2VjdXJpdHkYDiABKAsyHi5hZGRyZXNzaXEudjEuU2VjdXJpdHlFbnZlbG9wZVIIc2VjdXJp'
    'dHk=');

@$core.Deprecated('Use transitEventBatchDescriptor instead')
const TransitEventBatch$json = {
  '1': 'TransitEventBatch',
  '2': [
    {'1': 'events', '3': 1, '4': 3, '5': 11, '6': '.addressiq.v1.TransitEvent', '10': 'events'},
  ],
};

/// Descriptor for `TransitEventBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitEventBatchDescriptor = $convert.base64Decode(
    'ChFUcmFuc2l0RXZlbnRCYXRjaBIyCgZldmVudHMYASADKAsyGi5hZGRyZXNzaXEudjEuVHJhbn'
    'NpdEV2ZW50UgZldmVudHM=');

@$core.Deprecated('Use transitEventBatchAckDescriptor instead')
const TransitEventBatchAck$json = {
  '1': 'TransitEventBatchAck',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 5, '10': 'accepted'},
    {'1': 'deduplicated', '3': 2, '4': 1, '5': 5, '10': 'deduplicated'},
  ],
};

/// Descriptor for `TransitEventBatchAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitEventBatchAckDescriptor = $convert.base64Decode(
    'ChRUcmFuc2l0RXZlbnRCYXRjaEFjaxIaCghhY2NlcHRlZBgBIAEoBVIIYWNjZXB0ZWQSIgoMZG'
    'VkdXBsaWNhdGVkGAIgASgFUgxkZWR1cGxpY2F0ZWQ=');

