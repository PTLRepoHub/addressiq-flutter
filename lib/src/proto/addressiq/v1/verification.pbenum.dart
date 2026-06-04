//
//  Generated code. Do not modify.
//  source: addressiq/v1/verification.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class VerificationType extends $pb.ProtobufEnum {
  static const VerificationType VERIFICATION_TYPE_UNSPECIFIED = VerificationType._(0, _omitEnumNames ? '' : 'VERIFICATION_TYPE_UNSPECIFIED');
  static const VerificationType DIGITAL = VerificationType._(1, _omitEnumNames ? '' : 'DIGITAL');
  static const VerificationType PHYSICAL = VerificationType._(2, _omitEnumNames ? '' : 'PHYSICAL');
  static const VerificationType COMBINED = VerificationType._(3, _omitEnumNames ? '' : 'COMBINED');

  static const $core.List<VerificationType> values = <VerificationType> [
    VERIFICATION_TYPE_UNSPECIFIED,
    DIGITAL,
    PHYSICAL,
    COMBINED,
  ];

  static final $core.Map<$core.int, VerificationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VerificationType? valueOf($core.int value) => _byValue[value];

  const VerificationType._($core.int v, $core.String n) : super(v, n);
}

class VerificationStatus extends $pb.ProtobufEnum {
  static const VerificationStatus VERIFICATION_STATUS_UNSPECIFIED = VerificationStatus._(0, _omitEnumNames ? '' : 'VERIFICATION_STATUS_UNSPECIFIED');
  static const VerificationStatus PENDING = VerificationStatus._(1, _omitEnumNames ? '' : 'PENDING');
  static const VerificationStatus ASSIGNED = VerificationStatus._(2, _omitEnumNames ? '' : 'ASSIGNED');
  static const VerificationStatus IN_PROGRESS = VerificationStatus._(3, _omitEnumNames ? '' : 'IN_PROGRESS');
  static const VerificationStatus VERIFIED = VerificationStatus._(4, _omitEnumNames ? '' : 'VERIFIED');
  static const VerificationStatus NOT_AT_ADDRESS = VerificationStatus._(5, _omitEnumNames ? '' : 'NOT_AT_ADDRESS');
  static const VerificationStatus STATUS_UNKNOWN = VerificationStatus._(6, _omitEnumNames ? '' : 'STATUS_UNKNOWN');
  static const VerificationStatus FAILED = VerificationStatus._(7, _omitEnumNames ? '' : 'FAILED');
  static const VerificationStatus EXPIRED = VerificationStatus._(8, _omitEnumNames ? '' : 'EXPIRED');
  static const VerificationStatus CANCELLED = VerificationStatus._(9, _omitEnumNames ? '' : 'CANCELLED');
  static const VerificationStatus UNDER_REVIEW = VerificationStatus._(10, _omitEnumNames ? '' : 'UNDER_REVIEW');

  static const $core.List<VerificationStatus> values = <VerificationStatus> [
    VERIFICATION_STATUS_UNSPECIFIED,
    PENDING,
    ASSIGNED,
    IN_PROGRESS,
    VERIFIED,
    NOT_AT_ADDRESS,
    STATUS_UNKNOWN,
    FAILED,
    EXPIRED,
    CANCELLED,
    UNDER_REVIEW,
  ];

  static final $core.Map<$core.int, VerificationStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VerificationStatus? valueOf($core.int value) => _byValue[value];

  const VerificationStatus._($core.int v, $core.String n) : super(v, n);
}

class ReviewState extends $pb.ProtobufEnum {
  static const ReviewState REVIEW_STATE_UNSPECIFIED = ReviewState._(0, _omitEnumNames ? '' : 'REVIEW_STATE_UNSPECIFIED');
  static const ReviewState NONE = ReviewState._(1, _omitEnumNames ? '' : 'NONE');
  static const ReviewState FLAGGED = ReviewState._(2, _omitEnumNames ? '' : 'FLAGGED');
  static const ReviewState MANUAL_REVIEW = ReviewState._(3, _omitEnumNames ? '' : 'MANUAL_REVIEW');
  static const ReviewState ESCALATED = ReviewState._(4, _omitEnumNames ? '' : 'ESCALATED');
  static const ReviewState RESOLVED = ReviewState._(5, _omitEnumNames ? '' : 'RESOLVED');

  static const $core.List<ReviewState> values = <ReviewState> [
    REVIEW_STATE_UNSPECIFIED,
    NONE,
    FLAGGED,
    MANUAL_REVIEW,
    ESCALATED,
    RESOLVED,
  ];

  static final $core.Map<$core.int, ReviewState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReviewState? valueOf($core.int value) => _byValue[value];

  const ReviewState._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
