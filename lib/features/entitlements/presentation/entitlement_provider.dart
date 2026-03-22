import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/entitlements/domain/entitlement_status.dart';
import 'package:boxing/features/entitlements/data/entitlement_service.dart';

/// Provides the EntitlementService instance (overridden in main.dart).
final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  throw UnimplementedError('entitlementServiceProvider must be overridden');
});

/// Reactive entitlement status — updated by EntitlementService callback.
final entitlementStatusProvider = StateProvider<EntitlementStatus>((ref) {
  return EntitlementStatus.empty;
});
