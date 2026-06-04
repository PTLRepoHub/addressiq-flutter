//
//  Generated code. Do not modify.
//  source: addressiq/v1/sdk.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LifecycleState extends $pb.ProtobufEnum {
  static const LifecycleState LIFECYCLE_STATE_UNSPECIFIED = LifecycleState._(0, _omitEnumNames ? '' : 'LIFECYCLE_STATE_UNSPECIFIED');
  static const LifecycleState UNINITIALIZED = LifecycleState._(1, _omitEnumNames ? '' : 'UNINITIALIZED');
  static const LifecycleState IDLE = LifecycleState._(2, _omitEnumNames ? '' : 'IDLE');
  static const LifecycleState COLLECTING = LifecycleState._(3, _omitEnumNames ? '' : 'COLLECTING');
  static const LifecycleState PAUSED = LifecycleState._(4, _omitEnumNames ? '' : 'PAUSED');
  static const LifecycleState TERMINATED = LifecycleState._(5, _omitEnumNames ? '' : 'TERMINATED');

  static const $core.List<LifecycleState> values = <LifecycleState> [
    LIFECYCLE_STATE_UNSPECIFIED,
    UNINITIALIZED,
    IDLE,
    COLLECTING,
    PAUSED,
    TERMINATED,
  ];

  static final $core.Map<$core.int, LifecycleState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LifecycleState? valueOf($core.int value) => _byValue[value];

  const LifecycleState._($core.int v, $core.String n) : super(v, n);
}

class PermissionStatus extends $pb.ProtobufEnum {
  static const PermissionStatus PERMISSION_STATUS_UNSPECIFIED = PermissionStatus._(0, _omitEnumNames ? '' : 'PERMISSION_STATUS_UNSPECIFIED');
  static const PermissionStatus GRANTED = PermissionStatus._(1, _omitEnumNames ? '' : 'GRANTED');
  static const PermissionStatus DENIED = PermissionStatus._(2, _omitEnumNames ? '' : 'DENIED');
  static const PermissionStatus NOT_DETERMINED = PermissionStatus._(3, _omitEnumNames ? '' : 'NOT_DETERMINED');
  static const PermissionStatus BLOCKED = PermissionStatus._(4, _omitEnumNames ? '' : 'BLOCKED');
  static const PermissionStatus PERMISSION_UNAVAILABLE = PermissionStatus._(5, _omitEnumNames ? '' : 'PERMISSION_UNAVAILABLE');

  static const $core.List<PermissionStatus> values = <PermissionStatus> [
    PERMISSION_STATUS_UNSPECIFIED,
    GRANTED,
    DENIED,
    NOT_DETERMINED,
    BLOCKED,
    PERMISSION_UNAVAILABLE,
  ];

  static final $core.Map<$core.int, PermissionStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PermissionStatus? valueOf($core.int value) => _byValue[value];

  const PermissionStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
