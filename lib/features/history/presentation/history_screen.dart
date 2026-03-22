import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/history/domain/training_record.dart';
import 'package:boxing/features/history/presentation/history_controller.dart';
import 'package:boxing/l10n/app_localizations.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final records = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.historyScreenTitle),
        actions: [
          if (records.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear_all') {
                  _confirmClearAll(context, ref);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'clear_all',
                  child: Text(s.historyClearAll),
                ),
              ],
            ),
        ],
      ),
      body: records.isEmpty
          ? _EmptyState(s: s)
          : _RecordList(records: records),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.historyClearAllTitle),
        content: Text(s.historyClearAllMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.buttonCancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyControllerProvider).clearAll();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.historyAllCleared)),
              );
            },
            child: Text(s.historyClearAll),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final S s;

  const _EmptyState({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            s.historyEmpty,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            s.historyEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4),
                ),
          ),
        ],
      ),
    );
  }
}

class _RecordList extends ConsumerWidget {
  final List<TrainingRecord> records;

  const _RecordList({required this.records});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final grouped = _groupByDate(records, s);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final group = grouped[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                group.label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            ...group.records.map(
              (record) => _RecordCard(record: record),
            ),
          ],
        );
      },
    );
  }

  List<_DateGroup> _groupByDate(List<TrainingRecord> records, S s) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<TrainingRecord>>{};
    final groupLabels = <String, String>{};

    for (final record in records) {
      final recordDate =
          DateTime(record.date.year, record.date.month, record.date.day);

      String key;
      String label;

      if (recordDate == today) {
        key = 'today';
        label = s.historyToday;
      } else if (recordDate == yesterday) {
        key = 'yesterday';
        label = s.historyYesterday;
      } else {
        key = recordDate.toIso8601String();
        label = DateFormat.yMMMd().format(record.date);
      }

      groups.putIfAbsent(key, () => []).add(record);
      groupLabels[key] = label;
    }

    return groups.entries
        .map((e) => _DateGroup(label: groupLabels[e.key]!, records: e.value))
        .toList();
  }
}

class _DateGroup {
  final String label;
  final List<TrainingRecord> records;

  const _DateGroup({required this.label, required this.records});
}

class _RecordCard extends ConsumerWidget {
  final TrainingRecord record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(
          record.sessionName,
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Row(
          children: [
            Text(
              s.historyRecordRounds(record.roundsCompleted, record.totalRounds),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            Text(
              DurationFormatter.formatSeconds(record.durationCompletedSec),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            _StatusBadge(
              label: record.completedFully
                  ? s.historyRecordCompleted
                  : s.historyRecordStopped,
              isCompleted: record.completedFully,
            ),
            if (record.combosCompleted != null && record.combosCompleted! > 0) ...[
              const SizedBox(width: 12),
              const Icon(
                Icons.record_voice_over,
                size: 14,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                s.historyRecordCombos(record.combosCompleted!),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => _confirmDelete(context, ref),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.historyDeleteTitle),
        content: Text(s.historyDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.buttonCancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyControllerProvider).deleteRecord(record.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.historyRecordDeleted)),
              );
            },
            child: Text(s.actionDelete),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isCompleted;

  const _StatusBadge({required this.label, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
