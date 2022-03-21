import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final platformInfoProvider = FutureProvider(
    (ref) async => PackageInfo.fromPlatform()
);

final appVersionProvider = Provider<String>((ref) {
  final platformInfo = ref.watch(platformInfoProvider);

  return platformInfo.when(
      data: (info) {
        return '${info.version}+${info.buildNumber}';
      },
      error: (_, __) => '',
      loading: () => '',
  );
});