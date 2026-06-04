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

import '../../google/protobuf/timestamp.pb.dart' as $1;
import 'common.pb.dart' as $0;
import 'common.pbenum.dart' as $0;
import 'verification.pbenum.dart';

export 'verification.pbenum.dart';

class Verification extends $pb.GeneratedMessage {
  factory Verification({
    $core.String? id,
    $core.String? verificationCode,
    $core.String? organizationId,
    $core.String? appId,
    $core.String? branchId,
    $core.String? appUserId,
    $core.String? locationId,
    VerificationType? type,
    $core.String? provider,
    $core.String? providerReferenceId,
    VerificationStatus? status,
    ReviewState? reviewState,
    $core.double? confidenceScore,
    $1.Timestamp? windowEndsAt,
    $1.Timestamp? resolvedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (verificationCode != null) {
      $result.verificationCode = verificationCode;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (appId != null) {
      $result.appId = appId;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (appUserId != null) {
      $result.appUserId = appUserId;
    }
    if (locationId != null) {
      $result.locationId = locationId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (provider != null) {
      $result.provider = provider;
    }
    if (providerReferenceId != null) {
      $result.providerReferenceId = providerReferenceId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (reviewState != null) {
      $result.reviewState = reviewState;
    }
    if (confidenceScore != null) {
      $result.confidenceScore = confidenceScore;
    }
    if (windowEndsAt != null) {
      $result.windowEndsAt = windowEndsAt;
    }
    if (resolvedAt != null) {
      $result.resolvedAt = resolvedAt;
    }
    return $result;
  }
  Verification._() : super();
  factory Verification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Verification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Verification', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'verificationCode')
    ..aOS(3, _omitFieldNames ? '' : 'organizationId')
    ..aOS(4, _omitFieldNames ? '' : 'appId')
    ..aOS(5, _omitFieldNames ? '' : 'branchId')
    ..aOS(6, _omitFieldNames ? '' : 'appUserId')
    ..aOS(7, _omitFieldNames ? '' : 'locationId')
    ..e<VerificationType>(8, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: VerificationType.VERIFICATION_TYPE_UNSPECIFIED, valueOf: VerificationType.valueOf, enumValues: VerificationType.values)
    ..aOS(9, _omitFieldNames ? '' : 'provider')
    ..aOS(10, _omitFieldNames ? '' : 'providerReferenceId')
    ..e<VerificationStatus>(11, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: VerificationStatus.VERIFICATION_STATUS_UNSPECIFIED, valueOf: VerificationStatus.valueOf, enumValues: VerificationStatus.values)
    ..e<ReviewState>(12, _omitFieldNames ? '' : 'reviewState', $pb.PbFieldType.OE, defaultOrMaker: ReviewState.REVIEW_STATE_UNSPECIFIED, valueOf: ReviewState.valueOf, enumValues: ReviewState.values)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'confidenceScore', $pb.PbFieldType.OD)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'windowEndsAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'resolvedAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Verification clone() => Verification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Verification copyWith(void Function(Verification) updates) => super.copyWith((message) => updates(message as Verification)) as Verification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Verification create() => Verification._();
  Verification createEmptyInstance() => create();
  static $pb.PbList<Verification> createRepeated() => $pb.PbList<Verification>();
  @$core.pragma('dart2js:noInline')
  static Verification getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Verification>(create);
  static Verification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get verificationCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set verificationCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVerificationCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerificationCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get organizationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set organizationId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOrganizationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrganizationId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get appId => $_getSZ(3);
  @$pb.TagNumber(4)
  set appId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAppId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get branchId => $_getSZ(4);
  @$pb.TagNumber(5)
  set branchId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBranchId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBranchId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get appUserId => $_getSZ(5);
  @$pb.TagNumber(6)
  set appUserId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAppUserId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppUserId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get locationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set locationId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLocationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocationId() => clearField(7);

  @$pb.TagNumber(8)
  VerificationType get type => $_getN(7);
  @$pb.TagNumber(8)
  set type(VerificationType v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasType() => $_has(7);
  @$pb.TagNumber(8)
  void clearType() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get provider => $_getSZ(8);
  @$pb.TagNumber(9)
  set provider($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasProvider() => $_has(8);
  @$pb.TagNumber(9)
  void clearProvider() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get providerReferenceId => $_getSZ(9);
  @$pb.TagNumber(10)
  set providerReferenceId($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasProviderReferenceId() => $_has(9);
  @$pb.TagNumber(10)
  void clearProviderReferenceId() => clearField(10);

  @$pb.TagNumber(11)
  VerificationStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(VerificationStatus v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => clearField(11);

  @$pb.TagNumber(12)
  ReviewState get reviewState => $_getN(11);
  @$pb.TagNumber(12)
  set reviewState(ReviewState v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasReviewState() => $_has(11);
  @$pb.TagNumber(12)
  void clearReviewState() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get confidenceScore => $_getN(12);
  @$pb.TagNumber(13)
  set confidenceScore($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasConfidenceScore() => $_has(12);
  @$pb.TagNumber(13)
  void clearConfidenceScore() => clearField(13);

  @$pb.TagNumber(14)
  $1.Timestamp get windowEndsAt => $_getN(13);
  @$pb.TagNumber(14)
  set windowEndsAt($1.Timestamp v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasWindowEndsAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearWindowEndsAt() => clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureWindowEndsAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $1.Timestamp get resolvedAt => $_getN(14);
  @$pb.TagNumber(15)
  set resolvedAt($1.Timestamp v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasResolvedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearResolvedAt() => clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureResolvedAt() => $_ensure(14);
}

class Location extends $pb.GeneratedMessage {
  factory Location({
    $core.String? id,
    $core.String? locationCode,
    $0.GeoPoint? position,
    $core.int? geofenceRadiusM,
    $core.int? adaptiveGeofenceRadiusMeters,
    $0.EnvironmentBucket? environment,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (locationCode != null) {
      $result.locationCode = locationCode;
    }
    if (position != null) {
      $result.position = position;
    }
    if (geofenceRadiusM != null) {
      $result.geofenceRadiusM = geofenceRadiusM;
    }
    if (adaptiveGeofenceRadiusMeters != null) {
      $result.adaptiveGeofenceRadiusMeters = adaptiveGeofenceRadiusMeters;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    return $result;
  }
  Location._() : super();
  factory Location.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Location.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Location', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'locationCode')
    ..aOM<$0.GeoPoint>(3, _omitFieldNames ? '' : 'position', subBuilder: $0.GeoPoint.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'geofenceRadiusM', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'adaptiveGeofenceRadiusMeters', $pb.PbFieldType.O3)
    ..e<$0.EnvironmentBucket>(6, _omitFieldNames ? '' : 'environment', $pb.PbFieldType.OE, defaultOrMaker: $0.EnvironmentBucket.ENVIRONMENT_BUCKET_UNSPECIFIED, valueOf: $0.EnvironmentBucket.valueOf, enumValues: $0.EnvironmentBucket.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Location clone() => Location()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Location copyWith(void Function(Location) updates) => super.copyWith((message) => updates(message as Location)) as Location;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  Location createEmptyInstance() => create();
  static $pb.PbList<Location> createRepeated() => $pb.PbList<Location>();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocationCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationCode() => clearField(2);

  @$pb.TagNumber(3)
  $0.GeoPoint get position => $_getN(2);
  @$pb.TagNumber(3)
  set position($0.GeoPoint v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => clearField(3);
  @$pb.TagNumber(3)
  $0.GeoPoint ensurePosition() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get geofenceRadiusM => $_getIZ(3);
  @$pb.TagNumber(4)
  set geofenceRadiusM($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGeofenceRadiusM() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeofenceRadiusM() => clearField(4);

  /// Phase 3 — adaptive radius the SDK MUST honor when registering OS geofences.
  @$pb.TagNumber(5)
  $core.int get adaptiveGeofenceRadiusMeters => $_getIZ(4);
  @$pb.TagNumber(5)
  set adaptiveGeofenceRadiusMeters($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAdaptiveGeofenceRadiusMeters() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdaptiveGeofenceRadiusMeters() => clearField(5);

  @$pb.TagNumber(6)
  $0.EnvironmentBucket get environment => $_getN(5);
  @$pb.TagNumber(6)
  set environment($0.EnvironmentBucket v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasEnvironment() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnvironment() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
