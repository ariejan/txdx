import 'dart:io';

final fIsDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
final fIsMobile = Platform.isIOS || Platform.isAndroid;
final fSupportBadgeCount = Platform.isMacOS || Platform.isAndroid || Platform.isIOS;