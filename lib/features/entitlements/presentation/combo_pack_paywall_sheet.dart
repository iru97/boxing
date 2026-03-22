import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:boxing/features/entitlements/data/entitlement_config.dart';
import 'package:boxing/features/entitlements/presentation/entitlement_provider.dart';
import 'package:boxing/l10n/app_localizations.dart';

/// Bottom sheet paywall for the Combo Callouts Pack.
///
/// Shows feature comparison, price, and purchase/restore buttons.
/// Never shown if pack already owned (caller must check before calling [show]).
///
/// Usage:
/// ```dart
/// if (!entitlementStatus.hasComboAccess) {
///   ComboPackPaywallSheet.show(context);
/// }
/// ```
///
/// The [hasAccess] parameter is a defense-in-depth guard — callers should
/// already be gating on entitlement state, but passing `true` prevents an
/// accidental double-show if call sites change in the future.
class ComboPackPaywallSheet extends ConsumerStatefulWidget {
  const ComboPackPaywallSheet({super.key});

  /// Show the paywall as a modal bottom sheet.
  ///
  /// Returns immediately (no-op) when [hasAccess] is true — the user
  /// already owns the pack, so there is nothing to show.
  ///
  /// Caller is still responsible for the primary ownership guard; [hasAccess]
  /// is defense-in-depth only.
  static Future<void> show(BuildContext context, {bool hasAccess = false}) {
    if (hasAccess) return Future.value();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF111111), // AppColors.cardSurface
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ComboPackPaywallSheet(),
    );
  }

  @override
  ConsumerState<ComboPackPaywallSheet> createState() =>
      _ComboPackPaywallSheetState();
}

class _ComboPackPaywallSheetState extends ConsumerState<ComboPackPaywallSheet> {
  ProductDetails? _product;
  bool _loading = true;
  bool _purchasing = false;
  bool _storeError = false;
  bool _autoClosePending = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final response = await InAppPurchase.instance.queryProductDetails(
        {EntitlementConfig.comboPack},
      );
      if (response.productDetails.isNotEmpty) {
        _product = response.productDetails.first;
      } else {
        _storeError = true;
      }
    } catch (_) {
      _storeError = true;
    }
    if (mounted) setState(() => _loading = false);
  }

  // H2 fix: do NOT pop after initiating purchase. The purchase result arrives
  // via InAppPurchase.instance.purchaseStream → EntitlementService. The sheet
  // stays open so the user can see the system purchase dialog and try again if
  // it fails. The sheet only closes when the user dismisses it manually.
  Future<void> _purchase() async {
    if (_product == null || _purchasing) return;
    setState(() => _purchasing = true);
    try {
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: _product!),
      );
      // buyNonConsumable returns after initiating the OS purchase dialog.
      // Keep sheet open — the result arrives asynchronously via purchaseStream.
    } catch (e) {
      // Synchronous errors (e.g. another purchase already in progress).
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).purchaseError)),
        );
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
    // Do NOT pop here. User can dismiss manually or the parent rebuilds.
  }

  // H4 fix: show loading state and wait briefly for the stream to process
  // any restored purchases before closing the sheet.
  Future<void> _restore() async {
    setState(() => _purchasing = true);
    try {
      await InAppPurchase.instance.restorePurchases();
      // Brief wait for EntitlementService to process the restore stream event.
      await Future.delayed(const Duration(seconds: 2));
    } catch (_) {
      // Ignore — EntitlementService handles stream errors.
    }
    if (mounted) {
      setState(() => _purchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).paywallRestoreChecking)),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final price = _product?.price ?? '\$3.99';

    // Auto-close and confirm when purchase completes successfully.
    // Guard with _autoClosePending to prevent double-pop on repeated rebuilds.
    final hasAccess = ref.watch(entitlementStatusProvider).hasComboAccess;
    if (hasAccess && !_autoClosePending) {
      _autoClosePending = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.paywallPurchaseSuccess)),
          );
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DragHandle(),
          const SizedBox(height: 20),
          _Header(theme: theme, s: s),
          const SizedBox(height: 24),
          _FeatureList(s: s),
          const SizedBox(height: 28),
          // M3 fix: show retry button when the store query failed instead of
          // a silently-dead purchase button.
          if (_storeError)
            _RetryButton(
              onTap: () {
                setState(() {
                  _storeError = false;
                  _loading = true;
                });
                _loadProduct();
              },
            )
          else
            _PurchaseButton(
              price: price,
              loading: _loading,
              purchasing: _purchasing,
              unlockLabel: s.paywallUnlockButton,
              onTap: _purchase,
            ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: _purchasing ? null : _restore,
            child: Text(
              s.paywallRestorePurchases,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drag handle
// ---------------------------------------------------------------------------

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(77),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header: icon, title, subtitle
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final ThemeData theme;
  final S s;

  const _Header({required this.theme, required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.record_voice_over_rounded,
            size: 32,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          s.paywallComboTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          s.paywallComboSubtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(179),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Feature comparison list
// ---------------------------------------------------------------------------

class _FeatureList extends StatelessWidget {
  final S s;

  const _FeatureList({required this.s});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final freeItems = [
      s.paywallFreeItem1,
      s.paywallFreeItem2,
    ];
    final paidItems = [
      s.paywallPaidItem1,
      s.paywallPaidItem2,
      s.paywallPaidItem3,
      s.paywallPaidItem4,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // AppColors.raisedSurface
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in freeItems) ...[
            _FeatureRow(
              icon: Icons.check_circle_rounded,
              iconColor: const Color(0xFF00C853), // TimerColors.work
              text: item,
              theme: theme,
              semanticPrefix: s.paywallSemanticFree,
            ),
            const SizedBox(height: 10),
          ],
          const Divider(height: 16, color: Color(0xFF2A2A2A)),
          Text(
            s.paywallUnlockLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary.withAlpha(204),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < paidItems.length; i++) ...[
            _FeatureRow(
              icon: Icons.lock_open_rounded,
              iconColor: theme.colorScheme.primary,
              text: paidItems[i],
              theme: theme,
              semanticPrefix: s.paywallSemanticPaid,
            ),
            if (i < paidItems.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single feature row
// ---------------------------------------------------------------------------

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final ThemeData theme;
  final String? semanticPrefix;

  const _FeatureRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.theme,
    this.semanticPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticPrefix != null ? '$semanticPrefix: $text' : text,
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Purchase button
// ---------------------------------------------------------------------------

class _PurchaseButton extends StatelessWidget {
  final String price;
  final bool loading;
  final bool purchasing;
  final String unlockLabel;
  final VoidCallback onTap;

  const _PurchaseButton({
    required this.price,
    required this.loading,
    required this.purchasing,
    required this.unlockLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = loading || purchasing;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: isDisabled ? null : onTap,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isDisabled
            ? Semantics(
                label: S.of(context).paywallSemanticLoading,
                child: const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              )
            : Text(
                '$price  \u2014  $unlockLabel',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      letterSpacing: 0.5,
                    ),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Store unavailable / retry button (M3)
// ---------------------------------------------------------------------------

class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Semantics(
        label: s.paywallSemanticStoreUnavailable,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.refresh_rounded, size: 20),
          label: Text(s.storeRetry),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: theme.colorScheme.onSurface.withAlpha(77),
            ),
          ),
        ),
      ),
    );
  }
}
