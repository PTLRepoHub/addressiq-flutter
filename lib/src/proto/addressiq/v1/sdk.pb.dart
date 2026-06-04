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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'sdk.pbenum.dart';

export 'sdk.pbenum.dart';

class SdkUser extends $pb.GeneratedMessage {
  factory SdkUser({
    $core.String? appUserId,
    $core.String? phone,
    $core.String? email,
    $core.String? firstName,
    $core.String? lastName,
  }) {
    final $result = create();
    if (appUserId != null) {
      $result.appUserId = appUserId;
    }
    if (phone != null) {
      $result.phone = phone;
    }
    if (email != null) {
      $result.email = email;
    }
    if (firstName != null) {
      $result.firstName = firstName;
    }
    if (lastName != null) {
      $result.lastName = lastName;
    }
    return $result;
  }
  SdkUser._() : super();
  factory SdkUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SdkUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SdkUser', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appUserId')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOS(4, _omitFieldNames ? '' : 'firstName')
    ..aOS(5, _omitFieldNames ? '' : 'lastName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SdkUser clone() => SdkUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SdkUser copyWith(void Function(SdkUser) updates) => super.copyWith((message) => updates(message as SdkUser)) as SdkUser;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SdkUser create() => SdkUser._();
  SdkUser createEmptyInstance() => create();
  static $pb.PbList<SdkUser> createRepeated() => $pb.PbList<SdkUser>();
  @$core.pragma('dart2js:noInline')
  static SdkUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SdkUser>(create);
  static SdkUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appUserId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get firstName => $_getSZ(3);
  @$pb.TagNumber(4)
  set firstName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFirstName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFirstName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get lastName => $_getSZ(4);
  @$pb.TagNumber(5)
  set lastName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLastName() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastName() => clearField(5);
}

class VerificationLifecycleState extends $pb.GeneratedMessage {
  factory VerificationLifecycleState({
    LifecycleState? state,
    $core.String? appUserId,
    $core.String? verificationId,
    $core.String? locationCode,
    $fixnum.Int64? pausedForMs,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (appUserId != null) {
      $result.appUserId = appUserId;
    }
    if (verificationId != null) {
      $result.verificationId = verificationId;
    }
    if (locationCode != null) {
      $result.locationCode = locationCode;
    }
    if (pausedForMs != null) {
      $result.pausedForMs = pausedForMs;
    }
    return $result;
  }
  VerificationLifecycleState._() : super();
  factory VerificationLifecycleState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationLifecycleState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationLifecycleState', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..e<LifecycleState>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: LifecycleState.LIFECYCLE_STATE_UNSPECIFIED, valueOf: LifecycleState.valueOf, enumValues: LifecycleState.values)
    ..aOS(2, _omitFieldNames ? '' : 'appUserId')
    ..aOS(3, _omitFieldNames ? '' : 'verificationId')
    ..aOS(4, _omitFieldNames ? '' : 'locationCode')
    ..aInt64(5, _omitFieldNames ? '' : 'pausedForMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationLifecycleState clone() => VerificationLifecycleState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationLifecycleState copyWith(void Function(VerificationLifecycleState) updates) => super.copyWith((message) => updates(message as VerificationLifecycleState)) as VerificationLifecycleState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationLifecycleState create() => VerificationLifecycleState._();
  VerificationLifecycleState createEmptyInstance() => create();
  static $pb.PbList<VerificationLifecycleState> createRepeated() => $pb.PbList<VerificationLifecycleState>();
  @$core.pragma('dart2js:noInline')
  static VerificationLifecycleState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationLifecycleState>(create);
  static VerificationLifecycleState? _defaultInstance;

  @$pb.TagNumber(1)
  LifecycleState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(LifecycleState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get appUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set appUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAppUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get verificationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set verificationId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVerificationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerificationId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationCode($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLocationCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationCode() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get pausedForMs => $_getI64(4);
  @$pb.TagNumber(5)
  set pausedForMs($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPausedForMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearPausedForMs() => clearField(5);
}

class PermissionState extends $pb.GeneratedMessage {
  factory PermissionState({
    PermissionStatus? foregroundLocation,
    PermissionStatus? backgroundLocation,
    PermissionStatus? notifications,
  }) {
    final $result = create();
    if (foregroundLocation != null) {
      $result.foregroundLocation = foregroundLocation;
    }
    if (backgroundLocation != null) {
      $result.backgroundLocation = backgroundLocation;
    }
    if (notifications != null) {
      $result.notifications = notifications;
    }
    return $result;
  }
  PermissionState._() : super();
  factory PermissionState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PermissionState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PermissionState', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..e<PermissionStatus>(1, _omitFieldNames ? '' : 'foregroundLocation', $pb.PbFieldType.OE, defaultOrMaker: PermissionStatus.PERMISSION_STATUS_UNSPECIFIED, valueOf: PermissionStatus.valueOf, enumValues: PermissionStatus.values)
    ..e<PermissionStatus>(2, _omitFieldNames ? '' : 'backgroundLocation', $pb.PbFieldType.OE, defaultOrMaker: PermissionStatus.PERMISSION_STATUS_UNSPECIFIED, valueOf: PermissionStatus.valueOf, enumValues: PermissionStatus.values)
    ..e<PermissionStatus>(3, _omitFieldNames ? '' : 'notifications', $pb.PbFieldType.OE, defaultOrMaker: PermissionStatus.PERMISSION_STATUS_UNSPECIFIED, valueOf: PermissionStatus.valueOf, enumValues: PermissionStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PermissionState clone() => PermissionState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PermissionState copyWith(void Function(PermissionState) updates) => super.copyWith((message) => updates(message as PermissionState)) as PermissionState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionState create() => PermissionState._();
  PermissionState createEmptyInstance() => create();
  static $pb.PbList<PermissionState> createRepeated() => $pb.PbList<PermissionState>();
  @$core.pragma('dart2js:noInline')
  static PermissionState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PermissionState>(create);
  static PermissionState? _defaultInstance;

  @$pb.TagNumber(1)
  PermissionStatus get foregroundLocation => $_getN(0);
  @$pb.TagNumber(1)
  set foregroundLocation(PermissionStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasForegroundLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearForegroundLocation() => clearField(1);

  @$pb.TagNumber(2)
  PermissionStatus get backgroundLocation => $_getN(1);
  @$pb.TagNumber(2)
  set backgroundLocation(PermissionStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBackgroundLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackgroundLocation() => clearField(2);

  @$pb.TagNumber(3)
  PermissionStatus get notifications => $_getN(2);
  @$pb.TagNumber(3)
  set notifications(PermissionStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotifications() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotifications() => clearField(3);
}

class InvalidateSessionRequest extends $pb.GeneratedMessage {
  factory InvalidateSessionRequest({
    $core.String? appUserId,
    $core.String? verificationCode,
  }) {
    final $result = create();
    if (appUserId != null) {
      $result.appUserId = appUserId;
    }
    if (verificationCode != null) {
      $result.verificationCode = verificationCode;
    }
    return $result;
  }
  InvalidateSessionRequest._() : super();
  factory InvalidateSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvalidateSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InvalidateSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appUserId')
    ..aOS(2, _omitFieldNames ? '' : 'verificationCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvalidateSessionRequest clone() => InvalidateSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvalidateSessionRequest copyWith(void Function(InvalidateSessionRequest) updates) => super.copyWith((message) => updates(message as InvalidateSessionRequest)) as InvalidateSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvalidateSessionRequest create() => InvalidateSessionRequest._();
  InvalidateSessionRequest createEmptyInstance() => create();
  static $pb.PbList<InvalidateSessionRequest> createRepeated() => $pb.PbList<InvalidateSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static InvalidateSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvalidateSessionRequest>(create);
  static InvalidateSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appUserId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get verificationCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set verificationCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVerificationCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerificationCode() => clearField(2);
}

class InvalidateSessionResponse extends $pb.GeneratedMessage {
  factory InvalidateSessionResponse({
    $core.bool? revoked,
  }) {
    final $result = create();
    if (revoked != null) {
      $result.revoked = revoked;
    }
    return $result;
  }
  InvalidateSessionResponse._() : super();
  factory InvalidateSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvalidateSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InvalidateSessionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'addressiq.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'revoked')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvalidateSessionResponse clone() => InvalidateSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvalidateSessionResponse copyWith(void Function(InvalidateSessionResponse) updates) => super.copyWith((message) => updates(message as InvalidateSessionResponse)) as InvalidateSessionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvalidateSessionResponse create() => InvalidateSessionResponse._();
  InvalidateSessionResponse createEmptyInstance() => create();
  static $pb.PbList<InvalidateSessionResponse> createRepeated() => $pb.PbList<InvalidateSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static InvalidateSessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvalidateSessionResponse>(create);
  static InvalidateSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get revoked => $_getBF(0);
  @$pb.TagNumber(1)
  set revoked($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRevoked() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevoked() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
