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

import '../../google/protobuf/timestamp.pb.dart' as $1;
import 'common.pb.dart' as $0;
import 'telemetry.pbenum.dart';

export 'telemetry.pbenum.dart';

class SecurityEnvelope extends $pb.GeneratedMessage {
  factory SecurityEnvelope({
    $core.String? deviceFingerprintHash,
    $core.String? attestationToken,
    IntegrityVerdict? integrityVerdict,
  }) {
    final $result = create();
    if (deviceFingerprintHash != null) {
      $result.deviceFingerprintHash = deviceFingerprintHash;
    }
    if (attestationToken != null) {
      $result.attestationToken = attestationToken;
    }
    if (integrityVerdict != null) {
      $result.integrityVerdict = integrityVerdict;
    }
    return $result;
  }
  SecurityEnvelope._() : super();
  factory SecurityEnvelope.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SecurityEnvelope.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecurityEnvelope', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceFingerprintHash')
    ..aOS(2, _omitFieldNames ? '' : 'attestationToken')
    ..e<IntegrityVerdict>(3, _omitFieldNames ? '' : 'integrityVerdict', $pb.PbFieldType.OE, defaultOrMaker: IntegrityVerdict.INTEGRITY_VERDICT_UNSPECIFIED, valueOf: IntegrityVerdict.valueOf, enumValues: IntegrityVerdict.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SecurityEnvelope clone() => SecurityEnvelope()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SecurityEnvelope copyWith(void Function(SecurityEnvelope) updates) => super.copyWith((message) => updates(message as SecurityEnvelope)) as SecurityEnvelope;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecurityEnvelope create() => SecurityEnvelope._();
  SecurityEnvelope createEmptyInstance() => create();
  static $pb.PbList<SecurityEnvelope> createRepeated() => $pb.PbList<SecurityEnvelope>();
  @$core.pragma('dart2js:noInline')
  static SecurityEnvelope getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecurityEnvelope>(create);
  static SecurityEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceFingerprintHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceFingerprintHash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceFingerprintHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceFingerprintHash() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get attestationToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set attestationToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAttestationToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttestationToken() => clearField(2);

  @$pb.TagNumber(3)
  IntegrityVerdict get integrityVerdict => $_getN(2);
  @$pb.TagNumber(3)
  set integrityVerdict(IntegrityVerdict v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasIntegrityVerdict() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntegrityVerdict() => clearField(3);
}

class TransitEvent extends $pb.GeneratedMessage {
  factory TransitEvent({
    $core.String? eventId,
    $core.String? locationId,
    TransitEventType? eventType,
    $0.GeoPoint? position,
    $core.double? accuracyM,
    $core.double? distanceFromPinM,
    ActivityType? activityType,
    $core.int? activityConfidence,
    $core.int? batteryLevel,
    $core.bool? isCharging,
    DeviceOs? deviceOs,
    $core.String? sdkVersion,
    $1.Timestamp? deviceTimestamp,
    SecurityEnvelope? security,
  }) {
    final $result = create();
    if (eventId != null) {
      $result.eventId = eventId;
    }
    if (locationId != null) {
      $result.locationId = locationId;
    }
    if (eventType != null) {
      $result.eventType = eventType;
    }
    if (position != null) {
      $result.position = position;
    }
    if (accuracyM != null) {
      $result.accuracyM = accuracyM;
    }
    if (distanceFromPinM != null) {
      $result.distanceFromPinM = distanceFromPinM;
    }
    if (activityType != null) {
      $result.activityType = activityType;
    }
    if (activityConfidence != null) {
      $result.activityConfidence = activityConfidence;
    }
    if (batteryLevel != null) {
      $result.batteryLevel = batteryLevel;
    }
    if (isCharging != null) {
      $result.isCharging = isCharging;
    }
    if (deviceOs != null) {
      $result.deviceOs = deviceOs;
    }
    if (sdkVersion != null) {
      $result.sdkVersion = sdkVersion;
    }
    if (deviceTimestamp != null) {
      $result.deviceTimestamp = deviceTimestamp;
    }
    if (security != null) {
      $result.security = security;
    }
    return $result;
  }
  TransitEvent._() : super();
  factory TransitEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransitEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..e<TransitEventType>(3, _omitFieldNames ? '' : 'eventType', $pb.PbFieldType.OE, defaultOrMaker: TransitEventType.TRANSIT_EVENT_TYPE_UNSPECIFIED, valueOf: TransitEventType.valueOf, enumValues: TransitEventType.values)
    ..aOM<$0.GeoPoint>(4, _omitFieldNames ? '' : 'position', subBuilder: $0.GeoPoint.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'accuracyM', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'distanceFromPinM', $pb.PbFieldType.OD)
    ..e<ActivityType>(7, _omitFieldNames ? '' : 'activityType', $pb.PbFieldType.OE, defaultOrMaker: ActivityType.ACTIVITY_TYPE_UNSPECIFIED, valueOf: ActivityType.valueOf, enumValues: ActivityType.values)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'activityConfidence', $pb.PbFieldType.O3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'batteryLevel', $pb.PbFieldType.O3)
    ..aOB(10, _omitFieldNames ? '' : 'isCharging')
    ..e<DeviceOs>(11, _omitFieldNames ? '' : 'deviceOs', $pb.PbFieldType.OE, defaultOrMaker: DeviceOs.DEVICE_OS_UNSPECIFIED, valueOf: DeviceOs.valueOf, enumValues: DeviceOs.values)
    ..aOS(12, _omitFieldNames ? '' : 'sdkVersion')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'deviceTimestamp', subBuilder: $1.Timestamp.create)
    ..aOM<SecurityEnvelope>(14, _omitFieldNames ? '' : 'security', subBuilder: SecurityEnvelope.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransitEvent clone() => TransitEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransitEvent copyWith(void Function(TransitEvent) updates) => super.copyWith((message) => updates(message as TransitEvent)) as TransitEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransitEvent create() => TransitEvent._();
  TransitEvent createEmptyInstance() => create();
  static $pb.PbList<TransitEvent> createRepeated() => $pb.PbList<TransitEvent>();
  @$core.pragma('dart2js:noInline')
  static TransitEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransitEvent>(create);
  static TransitEvent? _defaultInstance;

  /// UUID v4 generated client-side. Server dedups via 24h Redis SETNX.
  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => clearField(2);

  @$pb.TagNumber(3)
  TransitEventType get eventType => $_getN(2);
  @$pb.TagNumber(3)
  set eventType(TransitEventType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEventType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventType() => clearField(3);

  @$pb.TagNumber(4)
  $0.GeoPoint get position => $_getN(3);
  @$pb.TagNumber(4)
  set position($0.GeoPoint v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => clearField(4);
  @$pb.TagNumber(4)
  $0.GeoPoint ensurePosition() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get accuracyM => $_getN(4);
  @$pb.TagNumber(5)
  set accuracyM($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAccuracyM() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccuracyM() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get distanceFromPinM => $_getN(5);
  @$pb.TagNumber(6)
  set distanceFromPinM($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDistanceFromPinM() => $_has(5);
  @$pb.TagNumber(6)
  void clearDistanceFromPinM() => clearField(6);

  @$pb.TagNumber(7)
  ActivityType get activityType => $_getN(6);
  @$pb.TagNumber(7)
  set activityType(ActivityType v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasActivityType() => $_has(6);
  @$pb.TagNumber(7)
  void clearActivityType() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get activityConfidence => $_getIZ(7);
  @$pb.TagNumber(8)
  set activityConfidence($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasActivityConfidence() => $_has(7);
  @$pb.TagNumber(8)
  void clearActivityConfidence() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get batteryLevel => $_getIZ(8);
  @$pb.TagNumber(9)
  set batteryLevel($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasBatteryLevel() => $_has(8);
  @$pb.TagNumber(9)
  void clearBatteryLevel() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isCharging => $_getBF(9);
  @$pb.TagNumber(10)
  set isCharging($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasIsCharging() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsCharging() => clearField(10);

  @$pb.TagNumber(11)
  DeviceOs get deviceOs => $_getN(10);
  @$pb.TagNumber(11)
  set deviceOs(DeviceOs v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDeviceOs() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeviceOs() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get sdkVersion => $_getSZ(11);
  @$pb.TagNumber(12)
  set sdkVersion($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSdkVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearSdkVersion() => clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get deviceTimestamp => $_getN(12);
  @$pb.TagNumber(13)
  set deviceTimestamp($1.Timestamp v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasDeviceTimestamp() => $_has(12);
  @$pb.TagNumber(13)
  void clearDeviceTimestamp() => clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureDeviceTimestamp() => $_ensure(12);

  @$pb.TagNumber(14)
  SecurityEnvelope get security => $_getN(13);
  @$pb.TagNumber(14)
  set security(SecurityEnvelope v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasSecurity() => $_has(13);
  @$pb.TagNumber(14)
  void clearSecurity() => clearField(14);
  @$pb.TagNumber(14)
  SecurityEnvelope ensureSecurity() => $_ensure(13);
}

class TransitEventBatch extends $pb.GeneratedMessage {
  factory TransitEventBatch({
    $core.Iterable<TransitEvent>? events,
  }) {
    final $result = create();
    if (events != null) {
      $result.events.addAll(events);
    }
    return $result;
  }
  TransitEventBatch._() : super();
  factory TransitEventBatch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransitEventBatch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitEventBatch', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..pc<TransitEvent>(1, _omitFieldNames ? '' : 'events', $pb.PbFieldType.PM, subBuilder: TransitEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransitEventBatch clone() => TransitEventBatch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransitEventBatch copyWith(void Function(TransitEventBatch) updates) => super.copyWith((message) => updates(message as TransitEventBatch)) as TransitEventBatch;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransitEventBatch create() => TransitEventBatch._();
  TransitEventBatch createEmptyInstance() => create();
  static $pb.PbList<TransitEventBatch> createRepeated() => $pb.PbList<TransitEventBatch>();
  @$core.pragma('dart2js:noInline')
  static TransitEventBatch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransitEventBatch>(create);
  static TransitEventBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TransitEvent> get events => $_getList(0);
}

class TransitEventBatchAck extends $pb.GeneratedMessage {
  factory TransitEventBatchAck({
    $core.int? accepted,
    $core.int? deduplicated,
  }) {
    final $result = create();
    if (accepted != null) {
      $result.accepted = accepted;
    }
    if (deduplicated != null) {
      $result.deduplicated = deduplicated;
    }
    return $result;
  }
  TransitEventBatchAck._() : super();
  factory TransitEventBatchAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransitEventBatchAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransitEventBatchAck', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'accepted', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'deduplicated', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransitEventBatchAck clone() => TransitEventBatchAck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransitEventBatchAck copyWith(void Function(TransitEventBatchAck) updates) => super.copyWith((message) => updates(message as TransitEventBatchAck)) as TransitEventBatchAck;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransitEventBatchAck create() => TransitEventBatchAck._();
  TransitEventBatchAck createEmptyInstance() => create();
  static $pb.PbList<TransitEventBatchAck> createRepeated() => $pb.PbList<TransitEventBatchAck>();
  @$core.pragma('dart2js:noInline')
  static TransitEventBatchAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransitEventBatchAck>(create);
  static TransitEventBatchAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get accepted => $_getIZ(0);
  @$pb.TagNumber(1)
  set accepted($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get deduplicated => $_getIZ(1);
  @$pb.TagNumber(2)
  set deduplicated($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeduplicated() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeduplicated() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
