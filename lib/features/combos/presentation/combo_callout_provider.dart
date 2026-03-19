import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/combos/domain/combo_callout_engine.dart';
import 'package:boxing/features/combos/data/combo_library.dart';
import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/timer/presentation/timer_controller.dart';

/// Provides the filtered combo pool based on the active session's config.
final filteredCombosProvider = Provider.family<List<Combo>, ComboCalloutConfig>((ref, config) {
  final sport = ComboSport.values.firstWhere(
    (s) => s.name == config.sport,
    orElse: () => ComboSport.boxing,
  );
  final difficulty = ComboDifficulty.values.firstWhere(
    (d) => d.name == config.difficulty,
    orElse: () => ComboDifficulty.beginner,
  );

  var combos = ComboLibrary.filtered(sport: sport, difficulty: difficulty);

  // Add defense combos if enabled
  if (config.includeDefense) {
    combos = [...combos, ...ComboLibrary.forSport(ComboSport.defense)];
  }

  // Add footwork combos if enabled
  if (config.includeFootwork) {
    combos = [...combos, ...ComboLibrary.forSport(ComboSport.footwork)];
  }

  return combos;
});

/// Provides the combo callout engine for the active session.
/// Returns null if combos are disabled.
final comboCalloutEngineProvider = Provider<ComboCalloutEngine?>((ref) {
  final session = ref.watch(activeSessionProvider);
  if (session == null) return null;

  final config = session.comboConfig;
  if (config == null || !config.enabled) return null;

  final comboPool = ref.watch(filteredCombosProvider(config));

  final engine = ComboCalloutEngine(techniques: TechniqueLibrary.all);
  engine.configure(config, comboPool);
  ref.onDispose(() => engine.dispose());
  return engine;
});

/// Stream of active combo callout for UI display.
final activeComboProvider = StreamProvider<ComboCallout?>((ref) {
  final engine = ref.watch(comboCalloutEngineProvider);
  if (engine == null) return Stream.value(null);
  return engine.comboStream;
});
