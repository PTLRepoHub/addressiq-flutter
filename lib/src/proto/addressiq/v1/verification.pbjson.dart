//
//  Generated code. Do not modify.
//  source: addressiq/v1/verification.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use verificationTypeDescriptor instead')
const VerificationType$json = {
  '1': 'VerificationType',
  '2': [
    {'1': 'VERIFICATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DIGITAL', '2': 1},
    {'1': 'PHYSICAL', '2': 2},
    {'1': 'COMBINED', '2': 3},
  ],
};

/// Descriptor for `VerificationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List verificationTypeDescriptor = $convert.base64Decode(
    'ChBWZXJpZmljYXRpb25UeXBlEiEKHVZFUklGSUNBVElPTl9UWVBFX1VOU1BFQ0lGSUVEEAASCw'
    'oHRElHSVRBTBABEgwKCFBIWVNJQ0FMEAISDAoIQ09NQklORUQQAw==');

@$core.Deprecated('Use verificationStatusDescriptor instead')
const VerificationStatus$json = {
  '1': 'VerificationStatus',
  '2': [
    {'1': 'VERIFICATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PENDING', '2': 1},
    {'1': 'ASSIGNED', '2': 2},
    {'1': 'IN_PROGRESS', '2': 3},
    {'1': 'VERIFIED', '2': 4},
    {'1': 'NOT_AT_ADDRESS', '2': 5},
    {'1': 'STATUS_UNKNOWN', '2': 6},
    {'1': 'FAILED', '2': 7},
    {'1': 'EXPIRED', '2': 8},
    {'1': 'CANCELLED', '2': 9},
    {'1': 'UNDER_REVIEW', '2': 10},
  ],
};

/// Descriptor for `VerificationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List verificationStatusDescriptor = $convert.base64Decode(
    'ChJWZXJpZmljYXRpb25TdGF0dXMSIwofVkVSSUZJQ0FUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEgsKB1BFTkRJTkcQARIMCghBU1NJR05FRBACEg8KC0lOX1BST0dSRVNTEAMSDAoIVkVSSUZJ'
    'RUQQBBISCg5OT1RfQVRfQUREUkVTUxAFEhIKDlNUQVRVU19VTktOT1dOEAYSCgoGRkFJTEVEEA'
    'cSCwoHRVhQSVJFRBAIEg0KCUNBTkNFTExFRBAJEhAKDFVOREVSX1JFVklFVxAK');

@$core.Deprecated('Use reviewStateDescriptor instead')
const ReviewState$json = {
  '1': 'ReviewState',
  '2': [
    {'1': 'REVIEW_STATE_UNSPECIFIED', '2': 0},
    {'1': 'NONE', '2': 1},
    {'1': 'FLAGGED', '2': 2},
    {'1': 'MANUAL_REVIEW', '2': 3},
    {'1': 'ESCALATED', '2': 4},
    {'1': 'RESOLVED', '2': 5},
  ],
};

/// Descriptor for `ReviewState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStateDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdTdGF0ZRIcChhSRVZJRVdfU1RBVEVfVU5TUEVDSUZJRUQQABIICgROT05FEAESCw'
    'oHRkxBR0dFRBACEhEKDU1BTlVBTF9SRVZJRVcQAxINCglFU0NBTEFURUQQBBIMCghSRVNPTFZF'
    'RBAF');

@$core.Deprecated('Use verificationDescriptor instead')
const Verification$json = {
  '1': 'Verification',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'verification_code', '3': 2, '4': 1, '5': 9, '10': 'verificationCode'},
    {'1': 'organization_id', '3': 3, '4': 1, '5': 9, '10': 'organizationId'},
    {'1': 'app_id', '3': 4, '4': 1, '5': 9, '10': 'appId'},
    {'1': 'branch_id', '3': 5, '4': 1, '5': 9, '10': 'branchId'},
    {'1': 'app_user_id', '3': 6, '4': 1, '5': 9, '10': 'appUserId'},
    {'1': 'location_id', '3': 7, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'type', '3': 8, '4': 1, '5': 14, '6': '.addressiq.v1.VerificationType', '10': 'type'},
    {'1': 'provider', '3': 9, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'provider_reference_id', '3': 10, '4': 1, '5': 9, '10': 'providerReferenceId'},
    {'1': 'status', '3': 11, '4': 1, '5': 14, '6': '.addressiq.v1.VerificationStatus', '10': 'status'},
    {'1': 'review_state', '3': 12, '4': 1, '5': 14, '6': '.addressiq.v1.ReviewState', '10': 'reviewState'},
    {'1': 'confidence_score', '3': 13, '4': 1, '5': 1, '10': 'confidenceScore'},
    {'1': 'window_ends_at', '3': 14, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowEndsAt'},
    {'1': 'resolved_at', '3': 15, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'resolvedAt'},
  ],
};

/// Descriptor for `Verification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationDescriptor = $convert.base64Decode(
    'CgxWZXJpZmljYXRpb24SDgoCaWQYASABKAlSAmlkEisKEXZlcmlmaWNhdGlvbl9jb2RlGAIgAS'
    'gJUhB2ZXJpZmljYXRpb25Db2RlEicKD29yZ2FuaXphdGlvbl9pZBgDIAEoCVIOb3JnYW5pemF0'
    'aW9uSWQSFQoGYXBwX2lkGAQgASgJUgVhcHBJZBIbCglicmFuY2hfaWQYBSABKAlSCGJyYW5jaE'
    'lkEh4KC2FwcF91c2VyX2lkGAYgASgJUglhcHBVc2VySWQSHwoLbG9jYXRpb25faWQYByABKAlS'
    'CmxvY2F0aW9uSWQSMgoEdHlwZRgIIAEoDjIeLmFkZHJlc3NpcS52MS5WZXJpZmljYXRpb25UeX'
    'BlUgR0eXBlEhoKCHByb3ZpZGVyGAkgASgJUghwcm92aWRlchIyChVwcm92aWRlcl9yZWZlcmVu'
    'Y2VfaWQYCiABKAlSE3Byb3ZpZGVyUmVmZXJlbmNlSWQSOAoGc3RhdHVzGAsgASgOMiAuYWRkcm'
    'Vzc2lxLnYxLlZlcmlmaWNhdGlvblN0YXR1c1IGc3RhdHVzEjwKDHJldmlld19zdGF0ZRgMIAEo'
    'DjIZLmFkZHJlc3NpcS52MS5SZXZpZXdTdGF0ZVILcmV2aWV3U3RhdGUSKQoQY29uZmlkZW5jZV'
    '9zY29yZRgNIAEoAVIPY29uZmlkZW5jZVNjb3JlEkAKDndpbmRvd19lbmRzX2F0GA4gASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMd2luZG93RW5kc0F0EjsKC3Jlc29sdmVkX2F0GA'
    '8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVzb2x2ZWRBdA==');

@$core.Deprecated('Use locationDescriptor instead')
const Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'location_code', '3': 2, '4': 1, '5': 9, '10': 'locationCode'},
    {'1': 'position', '3': 3, '4': 1, '5': 11, '6': '.addressiq.v1.GeoPoint', '10': 'position'},
    {'1': 'geofence_radius_m', '3': 4, '4': 1, '5': 5, '10': 'geofenceRadiusM'},
    {'1': 'adaptive_geofence_radius_meters', '3': 5, '4': 1, '5': 5, '10': 'adaptiveGeofenceRadiusMeters'},
    {'1': 'environment', '3': 6, '4': 1, '5': 14, '6': '.addressiq.v1.EnvironmentBucket', '10': 'environment'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode(
    'CghMb2NhdGlvbhIOCgJpZBgBIAEoCVICaWQSIwoNbG9jYXRpb25fY29kZRgCIAEoCVIMbG9jYX'
    'Rpb25Db2RlEjIKCHBvc2l0aW9uGAMgASgLMhYuYWRkcmVzc2lxLnYxLkdlb1BvaW50Ughwb3Np'
    'dGlvbhIqChFnZW9mZW5jZV9yYWRpdXNfbRgEIAEoBVIPZ2VvZmVuY2VSYWRpdXNNEkUKH2FkYX'
    'B0aXZlX2dlb2ZlbmNlX3JhZGl1c19tZXRlcnMYBSABKAVSHGFkYXB0aXZlR2VvZmVuY2VSYWRp'
    'dXNNZXRlcnMSQQoLZW52aXJvbm1lbnQYBiABKA4yHy5hZGRyZXNzaXEudjEuRW52aXJvbm1lbn'
    'RCdWNrZXRSC2Vudmlyb25tZW50');

