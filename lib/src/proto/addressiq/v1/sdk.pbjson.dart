//
//  Generated code. Do not modify.
//  source: addressiq/v1/sdk.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use lifecycleStateDescriptor instead')
const LifecycleState$json = {
  '1': 'LifecycleState',
  '2': [
    {'1': 'LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'UNINITIALIZED', '2': 1},
    {'1': 'IDLE', '2': 2},
    {'1': 'COLLECTING', '2': 3},
    {'1': 'PAUSED', '2': 4},
    {'1': 'TERMINATED', '2': 5},
  ],
};

/// Descriptor for `LifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lifecycleStateDescriptor = $convert.base64Decode(
    'Cg5MaWZlY3ljbGVTdGF0ZRIfChtMSUZFQ1lDTEVfU1RBVEVfVU5TUEVDSUZJRUQQABIRCg1VTk'
    'lOSVRJQUxJWkVEEAESCAoESURMRRACEg4KCkNPTExFQ1RJTkcQAxIKCgZQQVVTRUQQBBIOCgpU'
    'RVJNSU5BVEVEEAU=');

@$core.Deprecated('Use permissionStatusDescriptor instead')
const PermissionStatus$json = {
  '1': 'PermissionStatus',
  '2': [
    {'1': 'PERMISSION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'GRANTED', '2': 1},
    {'1': 'DENIED', '2': 2},
    {'1': 'NOT_DETERMINED', '2': 3},
    {'1': 'BLOCKED', '2': 4},
    {'1': 'PERMISSION_UNAVAILABLE', '2': 5},
  ],
};

/// Descriptor for `PermissionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List permissionStatusDescriptor = $convert.base64Decode(
    'ChBQZXJtaXNzaW9uU3RhdHVzEiEKHVBFUk1JU1NJT05fU1RBVFVTX1VOU1BFQ0lGSUVEEAASCw'
    'oHR1JBTlRFRBABEgoKBkRFTklFRBACEhIKDk5PVF9ERVRFUk1JTkVEEAMSCwoHQkxPQ0tFRBAE'
    'EhoKFlBFUk1JU1NJT05fVU5BVkFJTEFCTEUQBQ==');

@$core.Deprecated('Use sdkUserDescriptor instead')
const SdkUser$json = {
  '1': 'SdkUser',
  '2': [
    {'1': 'app_user_id', '3': 1, '4': 1, '5': 9, '10': 'appUserId'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'first_name', '3': 4, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'last_name', '3': 5, '4': 1, '5': 9, '10': 'lastName'},
  ],
};

/// Descriptor for `SdkUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sdkUserDescriptor = $convert.base64Decode(
    'CgdTZGtVc2VyEh4KC2FwcF91c2VyX2lkGAEgASgJUglhcHBVc2VySWQSFAoFcGhvbmUYAiABKA'
    'lSBXBob25lEhQKBWVtYWlsGAMgASgJUgVlbWFpbBIdCgpmaXJzdF9uYW1lGAQgASgJUglmaXJz'
    'dE5hbWUSGwoJbGFzdF9uYW1lGAUgASgJUghsYXN0TmFtZQ==');

@$core.Deprecated('Use verificationLifecycleStateDescriptor instead')
const VerificationLifecycleState$json = {
  '1': 'VerificationLifecycleState',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.addressiq.v1.LifecycleState', '10': 'state'},
    {'1': 'app_user_id', '3': 2, '4': 1, '5': 9, '10': 'appUserId'},
    {'1': 'verification_id', '3': 3, '4': 1, '5': 9, '10': 'verificationId'},
    {'1': 'location_code', '3': 4, '4': 1, '5': 9, '10': 'locationCode'},
    {'1': 'paused_for_ms', '3': 5, '4': 1, '5': 3, '10': 'pausedForMs'},
  ],
};

/// Descriptor for `VerificationLifecycleState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationLifecycleStateDescriptor = $convert.base64Decode(
    'ChpWZXJpZmljYXRpb25MaWZlY3ljbGVTdGF0ZRIyCgVzdGF0ZRgBIAEoDjIcLmFkZHJlc3NpcS'
    '52MS5MaWZlY3ljbGVTdGF0ZVIFc3RhdGUSHgoLYXBwX3VzZXJfaWQYAiABKAlSCWFwcFVzZXJJ'
    'ZBInCg92ZXJpZmljYXRpb25faWQYAyABKAlSDnZlcmlmaWNhdGlvbklkEiMKDWxvY2F0aW9uX2'
    'NvZGUYBCABKAlSDGxvY2F0aW9uQ29kZRIiCg1wYXVzZWRfZm9yX21zGAUgASgDUgtwYXVzZWRG'
    'b3JNcw==');

@$core.Deprecated('Use permissionStateDescriptor instead')
const PermissionState$json = {
  '1': 'PermissionState',
  '2': [
    {'1': 'foreground_location', '3': 1, '4': 1, '5': 14, '6': '.addressiq.v1.PermissionStatus', '10': 'foregroundLocation'},
    {'1': 'background_location', '3': 2, '4': 1, '5': 14, '6': '.addressiq.v1.PermissionStatus', '10': 'backgroundLocation'},
    {'1': 'notifications', '3': 3, '4': 1, '5': 14, '6': '.addressiq.v1.PermissionStatus', '10': 'notifications'},
  ],
};

/// Descriptor for `PermissionState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionStateDescriptor = $convert.base64Decode(
    'Cg9QZXJtaXNzaW9uU3RhdGUSTwoTZm9yZWdyb3VuZF9sb2NhdGlvbhgBIAEoDjIeLmFkZHJlc3'
    'NpcS52MS5QZXJtaXNzaW9uU3RhdHVzUhJmb3JlZ3JvdW5kTG9jYXRpb24STwoTYmFja2dyb3Vu'
    'ZF9sb2NhdGlvbhgCIAEoDjIeLmFkZHJlc3NpcS52MS5QZXJtaXNzaW9uU3RhdHVzUhJiYWNrZ3'
    'JvdW5kTG9jYXRpb24SRAoNbm90aWZpY2F0aW9ucxgDIAEoDjIeLmFkZHJlc3NpcS52MS5QZXJt'
    'aXNzaW9uU3RhdHVzUg1ub3RpZmljYXRpb25z');

@$core.Deprecated('Use invalidateSessionRequestDescriptor instead')
const InvalidateSessionRequest$json = {
  '1': 'InvalidateSessionRequest',
  '2': [
    {'1': 'app_user_id', '3': 1, '4': 1, '5': 9, '10': 'appUserId'},
    {'1': 'verification_code', '3': 2, '4': 1, '5': 9, '10': 'verificationCode'},
  ],
};

/// Descriptor for `InvalidateSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invalidateSessionRequestDescriptor = $convert.base64Decode(
    'ChhJbnZhbGlkYXRlU2Vzc2lvblJlcXVlc3QSHgoLYXBwX3VzZXJfaWQYASABKAlSCWFwcFVzZX'
    'JJZBIrChF2ZXJpZmljYXRpb25fY29kZRgCIAEoCVIQdmVyaWZpY2F0aW9uQ29kZQ==');

@$core.Deprecated('Use invalidateSessionResponseDescriptor instead')
const InvalidateSessionResponse$json = {
  '1': 'InvalidateSessionResponse',
  '2': [
    {'1': 'revoked', '3': 1, '4': 1, '5': 8, '10': 'revoked'},
  ],
};

/// Descriptor for `InvalidateSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invalidateSessionResponseDescriptor = $convert.base64Decode(
    'ChlJbnZhbGlkYXRlU2Vzc2lvblJlc3BvbnNlEhgKB3Jldm9rZWQYASABKAhSB3Jldm9rZWQ=');

