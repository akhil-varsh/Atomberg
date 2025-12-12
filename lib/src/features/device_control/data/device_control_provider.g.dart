// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_control_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceControlNotifier)
const deviceControlProvider = DeviceControlNotifierFamily._();

final class DeviceControlNotifierProvider
    extends $NotifierProvider<DeviceControlNotifier, Device> {
  const DeviceControlNotifierProvider._({
    required DeviceControlNotifierFamily super.from,
    required Device super.argument,
  }) : super(
         retry: null,
         name: r'deviceControlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deviceControlNotifierHash();

  @override
  String toString() {
    return r'deviceControlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DeviceControlNotifier create() => DeviceControlNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Device value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Device>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceControlNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deviceControlNotifierHash() =>
    r'a17674d55968355b4d45200a7e6eeb5c0e765945';

final class DeviceControlNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DeviceControlNotifier,
          Device,
          Device,
          Device,
          Device
        > {
  const DeviceControlNotifierFamily._()
    : super(
        retry: null,
        name: r'deviceControlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeviceControlNotifierProvider call(Device device) =>
      DeviceControlNotifierProvider._(argument: device, from: this);

  @override
  String toString() => r'deviceControlProvider';
}

abstract class _$DeviceControlNotifier extends $Notifier<Device> {
  late final _$args = ref.$arg as Device;
  Device get device => _$args;

  Device build(Device device);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<Device, Device>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Device, Device>,
              Device,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
