//
//  Generated code. Do not modify.
//  source: addressiq/v1/common.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use environmentBucketDescriptor instead')
const EnvironmentBucket$json = {
  '1': 'EnvironmentBucket',
  '2': [
    {'1': 'ENVIRONMENT_BUCKET_UNSPECIFIED', '2': 0},
    {'1': 'DENSE_URBAN', '2': 1},
    {'1': 'URBAN', '2': 2},
    {'1': 'SUBURBAN', '2': 3},
    {'1': 'RURAL', '2': 4},
    {'1': 'SPARSE_RURAL', '2': 5},
  ],
};

/// Descriptor for `EnvironmentBucket`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List environmentBucketDescriptor = $convert.base64Decode(
    'ChFFbnZpcm9ubWVudEJ1Y2tldBIiCh5FTlZJUk9OTUVOVF9CVUNLRVRfVU5TUEVDSUZJRUQQAB'
    'IPCgtERU5TRV9VUkJBThABEgkKBVVSQkFOEAISDAoIU1VCVVJCQU4QAxIJCgVSVVJBTBAEEhAK'
    'DFNQQVJTRV9SVVJBTBAF');

@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'SDK_NOT_INITIALIZED', '2': 1},
    {'1': 'INVALID_CONFIG', '2': 2},
    {'1': 'INVALID_USER', '2': 3},
    {'1': 'NO_ACTIVE_SESSION', '2': 4},
    {'1': 'IDEMPOTENCY_KEY_REQUIRED', '2': 5},
    {'1': 'IDEMPOTENCY_KEY_INVALID', '2': 6},
    {'1': 'IDEMPOTENCY_KEY_REUSED_WITH_DIFFERENT_PAYLOAD', '2': 7},
    {'1': 'PROVIDER_NOT_FOUND', '2': 8},
    {'1': 'PROVIDER_DISABLED_FOR_ORG', '2': 9},
    {'1': 'PROVIDER_TYPE_MISMATCH', '2': 10},
    {'1': 'PRODUCT_NOT_SUBSCRIBED', '2': 11},
    {'1': 'PHOTO_HASH_REUSED', '2': 12},
    {'1': 'VERIFICATION_ILLEGAL_TRANSITION', '2': 13},
    {'1': 'BROWSER_VERIFICATION_NOT_SUPPORTED', '2': 14},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode(
    'CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEhcKE1NES19OT1RfSU5JVE'
    'lBTElaRUQQARISCg5JTlZBTElEX0NPTkZJRxACEhAKDElOVkFMSURfVVNFUhADEhUKEU5PX0FD'
    'VElWRV9TRVNTSU9OEAQSHAoYSURFTVBPVEVOQ1lfS0VZX1JFUVVJUkVEEAUSGwoXSURFTVBPVE'
    'VOQ1lfS0VZX0lOVkFMSUQQBhIxCi1JREVNUE9URU5DWV9LRVlfUkVVU0VEX1dJVEhfRElGRkVS'
    'RU5UX1BBWUxPQUQQBxIWChJQUk9WSURFUl9OT1RfRk9VTkQQCBIdChlQUk9WSURFUl9ESVNBQk'
    'xFRF9GT1JfT1JHEAkSGgoWUFJPVklERVJfVFlQRV9NSVNNQVRDSBAKEhoKFlBST0RVQ1RfTk9U'
    'X1NVQlNDUklCRUQQCxIVChFQSE9UT19IQVNIX1JFVVNFRBAMEiMKH1ZFUklGSUNBVElPTl9JTE'
    'xFR0FMX1RSQU5TSVRJT04QDRImCiJCUk9XU0VSX1ZFUklGSUNBVElPTl9OT1RfU1VQUE9SVEVE'
    'EA4=');

@$core.Deprecated('Use organizationDescriptor instead')
const Organization$json = {
  '1': 'Organization',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'country', '3': 4, '4': 1, '5': 9, '10': 'country'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `Organization`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationDescriptor = $convert.base64Decode(
    'CgxPcmdhbml6YXRpb24SDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEc2'
    'x1ZxgDIAEoCVIEc2x1ZxIYCgdjb3VudHJ5GAQgASgJUgdjb3VudHJ5EhYKBnN0YXR1cxgFIAEo'
    'CVIGc3RhdHVz');

@$core.Deprecated('Use appUserDescriptor instead')
const AppUser$json = {
  '1': 'AppUser',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'organization_id', '3': 2, '4': 1, '5': 9, '10': 'organizationId'},
    {'1': 'app_id', '3': 3, '4': 1, '5': 9, '10': 'appId'},
    {'1': 'app_user_id', '3': 4, '4': 1, '5': 9, '10': 'appUserId'},
    {'1': 'phone_hash', '3': 5, '4': 1, '5': 9, '10': 'phoneHash'},
    {'1': 'email_hash', '3': 6, '4': 1, '5': 9, '10': 'emailHash'},
    {'1': 'identity_source', '3': 7, '4': 1, '5': 9, '10': 'identitySource'},
  ],
};

/// Descriptor for `AppUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appUserDescriptor = $convert.base64Decode(
    'CgdBcHBVc2VyEg4KAmlkGAEgASgJUgJpZBInCg9vcmdhbml6YXRpb25faWQYAiABKAlSDm9yZ2'
    'FuaXphdGlvbklkEhUKBmFwcF9pZBgDIAEoCVIFYXBwSWQSHgoLYXBwX3VzZXJfaWQYBCABKAlS'
    'CWFwcFVzZXJJZBIdCgpwaG9uZV9oYXNoGAUgASgJUglwaG9uZUhhc2gSHQoKZW1haWxfaGFzaB'
    'gGIAEoCVIJZW1haWxIYXNoEicKD2lkZW50aXR5X3NvdXJjZRgHIAEoCVIOaWRlbnRpdHlTb3Vy'
    'Y2U=');

@$core.Deprecated('Use geoPointDescriptor instead')
const GeoPoint$json = {
  '1': 'GeoPoint',
  '2': [
    {'1': 'lat', '3': 1, '4': 1, '5': 1, '10': 'lat'},
    {'1': 'lon', '3': 2, '4': 1, '5': 1, '10': 'lon'},
  ],
};

/// Descriptor for `GeoPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoPointDescriptor = $convert.base64Decode(
    'CghHZW9Qb2ludBIQCgNsYXQYASABKAFSA2xhdBIQCgNsb24YAiABKAFSA2xvbg==');

@$core.Deprecated('Use sdkErrorDescriptor instead')
const SdkError$json = {
  '1': 'SdkError',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 14, '6': '.addressiq.v1.ErrorCode', '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'docs_url', '3': 3, '4': 1, '5': 9, '10': 'docsUrl'},
  ],
};

/// Descriptor for `SdkError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sdkErrorDescriptor = $convert.base64Decode(
    'CghTZGtFcnJvchIrCgRjb2RlGAEgASgOMhcuYWRkcmVzc2lxLnYxLkVycm9yQ29kZVIEY29kZR'
    'IYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdlEhkKCGRvY3NfdXJsGAMgASgJUgdkb2NzVXJs');

