//
//  Generated code. Do not modify.
//  source: addressiq/v1/telemetry.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TransitEventType extends $pb.ProtobufEnum {
  static const TransitEventType TRANSIT_EVENT_TYPE_UNSPECIFIED = TransitEventType._(0, _omitEnumNames ? '' : 'TRANSIT_EVENT_TYPE_UNSPECIFIED');
  static const TransitEventType GEOFENCE_ENTER = TransitEventType._(1, _omitEnumNames ? '' : 'GEOFENCE_ENTER');
  static const TransitEventType GEOFENCE_EXIT = TransitEventType._(2, _omitEnumNames ? '' : 'GEOFENCE_EXIT');
  static const TransitEventType DWELL = TransitEventType._(3, _omitEnumNames ? '' : 'DWELL');
  static const TransitEventType APP_OPEN = TransitEventType._(4, _omitEnumNames ? '' : 'APP_OPEN');
  static const TransitEventType BACKGROUND_CHECK = TransitEventType._(5, _omitEnumNames ? '' : 'BACKGROUND_CHECK');
  static const TransitEventType ACTIVITY_UPDATE = TransitEventType._(6, _omitEnumNames ? '' : 'ACTIVITY_UPDATE');

  static const $core.List<TransitEventType> values = <TransitEventType> [
    TRANSIT_EVENT_TYPE_UNSPECIFIED,
    GEOFENCE_ENTER,
    GEOFENCE_EXIT,
    DWELL,
    APP_OPEN,
    BACKGROUND_CHECK,
    ACTIVITY_UPDATE,
  ];

  static final $core.Map<$core.int, TransitEventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TransitEventType? valueOf($core.int value) => _byValue[value];

  const TransitEventType._($core.int v, $core.String n) : super(v, n);
}

class ActivityType extends $pb.ProtobufEnum {
  static const ActivityType ACTIVITY_TYPE_UNSPECIFIED = ActivityType._(0, _omitEnumNames ? '' : 'ACTIVITY_TYPE_UNSPECIFIED');
  static const ActivityType STILL = ActivityType._(1, _omitEnumNames ? '' : 'STILL');
  static const ActivityType WALKING = ActivityType._(2, _omitEnumNames ? '' : 'WALKING');
  static const ActivityType RUNNING = ActivityType._(3, _omitEnumNames ? '' : 'RUNNING');
  static const ActivityType IN_VEHICLE = ActivityType._(4, _omitEnumNames ? '' : 'IN_VEHICLE');
  static const ActivityType ACTIVITY_UNKNOWN = ActivityType._(5, _omitEnumNames ? '' : 'ACTIVITY_UNKNOWN');

  static const $core.List<ActivityType> values = <ActivityType> [
    ACTIVITY_TYPE_UNSPECIFIED,
    STILL,
    WALKING,
    RUNNING,
    IN_VEHICLE,
    ACTIVITY_UNKNOWN,
  ];

  static final $core.Map<$core.int, ActivityType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ActivityType? valueOf($core.int value) => _byValue[value];

  const ActivityType._($core.int v, $core.String n) : super(v, n);
}

class DeviceOs extends $pb.ProtobufEnum {
  static const DeviceOs DEVICE_OS_UNSPECIFIED = DeviceOs._(0, _omitEnumNames ? '' : 'DEVICE_OS_UNSPECIFIED');
  static const DeviceOs IOS = DeviceOs._(1, _omitEnumNames ? '' : 'IOS');
  static const DeviceOs ANDROID = DeviceOs._(2, _omitEnumNames ? '' : 'ANDROID');

  static const $core.List<DeviceOs> values = <DeviceOs> [
    DEVICE_OS_UNSPECIFIED,
    IOS,
    ANDROID,
  ];

  static final $core.Map<$core.int, DeviceOs> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeviceOs? valueOf($core.int value) => _byValue[value];

  const DeviceOs._($core.int v, $core.String n) : super(v, n);
}

class IntegrityVerdict extends $pb.ProtobufEnum {
  static const IntegrityVerdict INTEGRITY_VERDICT_UNSPECIFIED = IntegrityVerdict._(0, _omitEnumNames ? '' : 'INTEGRITY_VERDICT_UNSPECIFIED');
  static const IntegrityVerdict MEETS_BASIC = IntegrityVerdict._(1, _omitEnumNames ? '' : 'MEETS_BASIC');
  static const IntegrityVerdict MEETS_DEVICE = IntegrityVerdict._(2, _omitEnumNames ? '' : 'MEETS_DEVICE');
  static const IntegrityVerdict MEETS_STRONG = IntegrityVerdict._(3, _omitEnumNames ? '' : 'MEETS_STRONG');
  static const IntegrityVerdict UNAVAILABLE = IntegrityVerdict._(4, _omitEnumNames ? '' : 'UNAVAILABLE');

  static const $core.List<IntegrityVerdict> values = <IntegrityVerdict> [
    INTEGRITY_VERDICT_UNSPECIFIED,
    MEETS_BASIC,
    MEETS_DEVICE,
    MEETS_STRONG,
    UNAVAILABLE,
  ];

  static final $core.Map<$core.int, IntegrityVerdict> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IntegrityVerdict? valueOf($core.int value) => _byValue[value];

  const IntegrityVerdict._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
