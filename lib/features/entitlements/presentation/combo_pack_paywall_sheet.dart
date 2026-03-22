import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:boxing/features/entitlements/data/entitlement_config.dart';

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
class ComboPackPaywallSheet extends StatefulWidget {
  const ComboPackPaywallSheet({super.key});

  /// Show the paywall as a modal bottom sheet.
  ///
  /// Caller is responsible for the ownership guard — this sheet does not
  /// check entitlements itself, it only handles store interaction.
  static Future<void> show(BuildContext context) {
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
  State<ComboPackPaywallSheet> createState() => _ComboPackPaywallSheetState();
}

class _ComboPackPaywallSheetState extends State<ComboPackPaywallSheet> {
  ProductDetails? _product;
  bool _loading = true;
  bool _purchasing = false;

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
      }
    } catch (_) {
      // Store unavailable — fall back to hardcoded price string.
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _purchase() async {
    if (_product == null || _purchasing) return;
    setState(() => _purchasing = true);
    try {
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: _product!),
      );
    } catch (_) {
      // Purchase errors surface via the InAppPurchase.instance.purchaseStream.
      // The EntitlementService listener handles final state updates.
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _restore() async {
    await InAppPurchase.instance.restorePurchases();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checking for previous purchases...')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = _product?.price ?? '\$3.99';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DragHandle(),
          const SizedBox(height: 20),
          _Header(theme: theme),
          const SizedBox(height: 24),
          const _FeatureList(),
          const SizedBox(height: 28),
          _PurchaseButton(
            price: price,
            loading: _loading,
            purchasing: _purchasing,
            onTap: _purchase,
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: _restore,
            child: Text(
              'Restore Purchases',
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

  const _Header({required this.theme});

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
          'Combo Callouts Pack',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Train like you have a coach',
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
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    const freeItems = [
      'Beginner combos (free forever)',
      'Basic boxing punch numbers',
    ];
    const paidItems = [
      '120+ intermediate & advanced combos',
      'Muay Thai, MMA & kickboxing technique callouts',
      'Defense & footwork cues',
      'Coach encouragement phrases',
    ];

    final theme = Theme.of(context);

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
            ),
            const SizedBox(height: 10),
          ],
          const Divider(height: 16, color: Color(0xFF2A2A2A)),
          Text(
            'Unlock with pack',
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

  const _FeatureRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
  final VoidCallback onTap;

  const _PurchaseButton({
    required this.price,
    required this.loading,
    required this.purchasing,
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
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(
                '$price  —  Unlock Now',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      letterSpacing: 0.5,
                    ),
              ),
      ),
    );
  }
}
