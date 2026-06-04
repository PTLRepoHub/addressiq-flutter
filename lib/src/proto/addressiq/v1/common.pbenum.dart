//
//  Generated code. Do not modify.
//  source: addressiq/v1/common.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EnvironmentBucket extends $pb.ProtobufEnum {
  static const EnvironmentBucket ENVIRONMENT_BUCKET_UNSPECIFIED = EnvironmentBucket._(0, _omitEnumNames ? '' : 'ENVIRONMENT_BUCKET_UNSPECIFIED');
  static const EnvironmentBucket DENSE_URBAN = EnvironmentBucket._(1, _omitEnumNames ? '' : 'DENSE_URBAN');
  static const EnvironmentBucket URBAN = EnvironmentBucket._(2, _omitEnumNames ? '' : 'URBAN');
  static const EnvironmentBucket SUBURBAN = EnvironmentBucket._(3, _omitEnumNames ? '' : 'SUBURBAN');
  static const EnvironmentBucket RURAL = EnvironmentBucket._(4, _omitEnumNames ? '' : 'RURAL');
  static const EnvironmentBucket SPARSE_RURAL = EnvironmentBucket._(5, _omitEnumNames ? '' : 'SPARSE_RURAL');

  static const $core.List<EnvironmentBucket> values = <EnvironmentBucket> [
    ENVIRONMENT_BUCKET_UNSPECIFIED,
    DENSE_URBAN,
    URBAN,
    SUBURBAN,
    RURAL,
    SPARSE_RURAL,
  ];

  static final $core.Map<$core.int, EnvironmentBucket> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EnvironmentBucket? valueOf($core.int value) => _byValue[value];

  const EnvironmentBucket._($core.int v, $core.String n) : super(v, n);
}

/// The single closed set of error codes every SDK must carry. New entries
/// require a spec change in docs/sdk-contract.md §3.
class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode ERROR_CODE_UNSPECIFIED = ErrorCode._(0, _omitEnumNames ? '' : 'ERROR_CODE_UNSPECIFIED');
  static const ErrorCode SDK_NOT_INITIALIZED = ErrorCode._(1, _omitEnumNames ? '' : 'SDK_NOT_INITIALIZED');
  static const ErrorCode INVALID_CONFIG = ErrorCode._(2, _omitEnumNames ? '' : 'INVALID_CONFIG');
  static const ErrorCode INVALID_USER = ErrorCode._(3, _omitEnumNames ? '' : 'INVALID_USER');
  static const ErrorCode NO_ACTIVE_SESSION = ErrorCode._(4, _omitEnumNames ? '' : 'NO_ACTIVE_SESSION');
  static const ErrorCode IDEMPOTENCY_KEY_REQUIRED = ErrorCode._(5, _omitEnumNames ? '' : 'IDEMPOTENCY_KEY_REQUIRED');
  static const ErrorCode IDEMPOTENCY_KEY_INVALID = ErrorCode._(6, _omitEnumNames ? '' : 'IDEMPOTENCY_KEY_INVALID');
  static const ErrorCode IDEMPOTENCY_KEY_REUSED_WITH_DIFFERENT_PAYLOAD = ErrorCode._(7, _omitEnumNames ? '' : 'IDEMPOTENCY_KEY_REUSED_WITH_DIFFERENT_PAYLOAD');
  static const ErrorCode PROVIDER_NOT_FOUND = ErrorCode._(8, _omitEnumNames ? '' : 'PROVIDER_NOT_FOUND');
  static const ErrorCode PROVIDER_DISABLED_FOR_ORG = ErrorCode._(9, _omitEnumNames ? '' : 'PROVIDER_DISABLED_FOR_ORG');
  static const ErrorCode PROVIDER_TYPE_MISMATCH = ErrorCode._(10, _omitEnumNames ? '' : 'PROVIDER_TYPE_MISMATCH');
  static const ErrorCode PRODUCT_NOT_SUBSCRIBED = ErrorCode._(11, _omitEnumNames ? '' : 'PRODUCT_NOT_SUBSCRIBED');
  static const ErrorCode PHOTO_HASH_REUSED = ErrorCode._(12, _omitEnumNames ? '' : 'PHOTO_HASH_REUSED');
  static const ErrorCode VERIFICATION_ILLEGAL_TRANSITION = ErrorCode._(13, _omitEnumNames ? '' : 'VERIFICATION_ILLEGAL_TRANSITION');
  static const ErrorCode BROWSER_VERIFICATION_NOT_SUPPORTED = ErrorCode._(14, _omitEnumNames ? '' : 'BROWSER_VERIFICATION_NOT_SUPPORTED');

  static const $core.List<ErrorCode> values = <ErrorCode> [
    ERROR_CODE_UNSPECIFIED,
    SDK_NOT_INITIALIZED,
    INVALID_CONFIG,
    INVALID_USER,
    NO_ACTIVE_SESSION,
    IDEMPOTENCY_KEY_REQUIRED,
    IDEMPOTENCY_KEY_INVALID,
    IDEMPOTENCY_KEY_REUSED_WITH_DIFFERENT_PAYLOAD,
    PROVIDER_NOT_FOUND,
    PROVIDER_DISABLED_FOR_ORG,
    PROVIDER_TYPE_MISMATCH,
    PRODUCT_NOT_SUBSCRIBED,
    PHOTO_HASH_REUSED,
    VERIFICATION_ILLEGAL_TRANSITION,
    BROWSER_VERIFICATION_NOT_SUPPORTED,
  ];

  static final $core.Map<$core.int, ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ErrorCode? valueOf($core.int value) => _byValue[value];

  const ErrorCode._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
