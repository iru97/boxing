import 'package:boxing/features/combos/domain/combo_model.dart';

/// Static library of all built-in combos across all supported sports.
///
/// 120 combos total:
///   Boxing:     50 (16 beginner + 18 intermediate + 16 advanced)
///   Muay Thai:  30 (10 beginner + 12 intermediate + 8 advanced)
///   MMA:        10
///   Kickboxing: 10
///   Defense:    10
///   Footwork:   10
class ComboLibrary {
  ComboLibrary._();

  /// All built-in combos.
  static const List<Combo> all = [
    // =================================================================
    // BOXING - BEGINNER (16)
    // =================================================================
    Combo(id: 'B1', techniqueIds: ['1'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B2', techniqueIds: ['1', '1'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B3', techniqueIds: ['1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B4', techniqueIds: ['2', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B5', techniqueIds: ['1', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B6', techniqueIds: ['1', '2', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B7', techniqueIds: ['1', '2', '1'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B8', techniqueIds: ['1', '4'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B9', techniqueIds: ['5', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B10', techniqueIds: ['6', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B11', techniqueIds: ['1', '2b'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B12', techniqueIds: ['1', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B13', techniqueIds: ['1', '6'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B14', techniqueIds: ['2', '1'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B15', techniqueIds: ['1b', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),
    Combo(id: 'B16', techniqueIds: ['3', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.boxing),

    // =================================================================
    // BOXING - INTERMEDIATE (18)
    // =================================================================
    Combo(id: 'I1', techniqueIds: ['1', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I2', techniqueIds: ['1', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I3', techniqueIds: ['2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I4', techniqueIds: ['1', '2', '5', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I5', techniqueIds: ['1', '6', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I6', techniqueIds: ['1', '2', '3b'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I7', techniqueIds: ['3', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I8', techniqueIds: ['5', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I9', techniqueIds: ['1', '2', 'slip_r', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I10', techniqueIds: ['1', '2', 'roll', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I11', techniqueIds: ['6', '5', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I12', techniqueIds: ['1', '2b', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I13', techniqueIds: ['3', '4', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I14', techniqueIds: ['1', '2', '1', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I15', techniqueIds: ['2', '3', '6'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I16', techniqueIds: ['1', 'slip_l', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I17', techniqueIds: ['3b', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),
    Combo(id: 'I18', techniqueIds: ['1', '2', '3', '2b'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.boxing),

    // =================================================================
    // BOXING - ADVANCED (16)
    // =================================================================
    Combo(id: 'A1', techniqueIds: ['1', '1', '2', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A2', techniqueIds: ['1', '2', '3', 'roll', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A3', techniqueIds: ['1', '2', '5', '6', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A4', techniqueIds: ['6', '3', '2', 'slip_r', '2', '3'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A5', techniqueIds: ['1', '2', 'duck', '2', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A6', techniqueIds: ['1', '2', '3b', 'pivot_l', '4', '3'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A7', techniqueIds: ['2', '3', '2', 'duck', '2', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A8', techniqueIds: ['1', '2', '3', '4b', '3b', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A9', techniqueIds: ['5', '4', '3b', 'pivot_r', '1', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A10', techniqueIds: ['1', '2', 'slip_r', '2', 'slip_l', '2', '3'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A11', techniqueIds: ['1', '3b', '3', '6b', '6', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A12', techniqueIds: ['parry', '2', '3', '2', 'roll', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A13', techniqueIds: ['1', '2', '3', '2', 'step_back', '1', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A14', techniqueIds: ['1', '6b', '6', '3', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A15', techniqueIds: ['shoulder_roll', '2', '3', '6', '3'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),
    Combo(id: 'A16', techniqueIds: ['1', '1', '2', '3', '4b', '3b'], difficulty: ComboDifficulty.advanced, sport: ComboSport.boxing),

    // =================================================================
    // MUAY THAI - BEGINNER (10)
    // =================================================================
    Combo(id: 'MT-B1', techniqueIds: ['1', '2', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B2', techniqueIds: ['1', '2', 'bk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B3', techniqueIds: ['1', '2', '3', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B4', techniqueIds: ['teep', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B5', techniqueIds: ['1', '2', 'teep'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B6', techniqueIds: ['lk', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B7', techniqueIds: ['1', '2', 'lead_elbow'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B8', techniqueIds: ['1', '2', 'rear_knee'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B9', techniqueIds: ['1', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),
    Combo(id: 'MT-B10', techniqueIds: ['1', '2', '3', 'bk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.muayThai),

    // =================================================================
    // MUAY THAI - INTERMEDIATE (12)
    // =================================================================
    Combo(id: 'MT-I1', techniqueIds: ['1', '2', '3', '2', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I2', techniqueIds: ['teep', '1', '2', 'lead_elbow', 'rear_elbow'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I3', techniqueIds: ['1', '2', 'switch_kick'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I4', techniqueIds: ['lk', '1', '2', '3', 'hk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I5', techniqueIds: ['1', '2', '3b', 'rear_knee'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I6', techniqueIds: ['1', '2', 'clinch', 'rear_knee', 'rear_knee'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I7', techniqueIds: ['2', '3', 'hk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I8', techniqueIds: ['1', '2', 'lead_elbow', 'rear_elbow', 'rear_knee'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I9', techniqueIds: ['parry', '2', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I10', techniqueIds: ['bk', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I11', techniqueIds: ['1', 'rear_teep', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),
    Combo(id: 'MT-I12', techniqueIds: ['1', '2', 'up_elbow'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.muayThai),

    // =================================================================
    // MUAY THAI - ADVANCED (8)
    // =================================================================
    Combo(id: 'MT-A1', techniqueIds: ['1', '2', '3', 'hk', 'clinch', 'rear_knee', 'lead_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A2', techniqueIds: ['teep', '1', '2', 'switch_kick', '2', '3', 'lk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A3', techniqueIds: ['lk', 'parry', '2', 'lead_elbow', 'rear_knee', 'hk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A4', techniqueIds: ['1', '2', '3', 'rear_elbow', 'lead_knee', 'rear_knee'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A5', techniqueIds: ['switch_kick', '2', '3', '2', 'lk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A6', techniqueIds: ['1', '2', 'clinch', 'rear_knee', 'rear_knee', 'up_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A7', techniqueIds: ['teep', 'catch_t', 'lk', '2', '3', 'rear_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A8', techniqueIds: ['1', '2', 'duck', 'bk', 'lead_elbow', 'rear_knee'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),

    // =================================================================
    // MMA (10)
    // =================================================================
    Combo(id: 'MMA1', techniqueIds: ['1', '2', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA2', techniqueIds: ['1', '2', '3', 'level_change'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA3', techniqueIds: ['1', '2', 'bk', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA4', techniqueIds: ['lk', '1', 'superman'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA5', techniqueIds: ['1', '2', '3', '2', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA6', techniqueIds: ['teep', '1', '2', '3', 'hk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA7', techniqueIds: ['sprawl', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA8', techniqueIds: ['1', '2', 'clinch', 'rear_knee', 'lead_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA9', techniqueIds: ['1', '2', 'duck', '2', 'lk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA10', techniqueIds: ['bk', '2', '3', 'level_change', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),

    // =================================================================
    // KICKBOXING (10)
    // =================================================================
    Combo(id: 'KB1', techniqueIds: ['1', '2', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB2', techniqueIds: ['1', '2', 'hk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB3', techniqueIds: ['1', '2', '3', 'bk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB4', techniqueIds: ['lk', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB5', techniqueIds: ['1', '2', '3', '2', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB6', techniqueIds: ['2', '3', 'hk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB7', techniqueIds: ['switch_kick', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB8', techniqueIds: ['teep', '1', '2', 'bk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB9', techniqueIds: ['1', '2', 'slip_r', '2', 'lk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB10', techniqueIds: ['1', '2', '3', 'switch_kick', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),

    // =================================================================
    // DEFENSE (10)
    // =================================================================
    Combo(id: 'D1', techniqueIds: ['slip_r', 'slip_l'], difficulty: ComboDifficulty.beginner, sport: ComboSport.defense),
    Combo(id: 'D2', techniqueIds: ['slip_r', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.defense),
    Combo(id: 'D3', techniqueIds: ['roll', '3', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.defense),
    Combo(id: 'D4', techniqueIds: ['parry', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.defense),
    Combo(id: 'D5', techniqueIds: ['block', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.defense),
    Combo(id: 'D6', techniqueIds: ['slip_l', 'slip_r', 'roll'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.defense),
    Combo(id: 'D7', techniqueIds: ['pull', '1', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.defense),
    Combo(id: 'D8', techniqueIds: ['duck', '5', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.defense),
    Combo(id: 'D9', techniqueIds: ['parry', 'slip_r', '2', '3'], difficulty: ComboDifficulty.advanced, sport: ComboSport.defense),
    Combo(id: 'D10', techniqueIds: ['shoulder_roll', '2', '3', '6'], difficulty: ComboDifficulty.advanced, sport: ComboSport.defense),

    // =================================================================
    // FOOTWORK (10)
    // =================================================================
    Combo(id: 'F1', techniqueIds: ['pivot_l', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.footwork),
    Combo(id: 'F2', techniqueIds: ['pivot_r', '2', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.footwork),
    Combo(id: 'F3', techniqueIds: ['angle_l', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
    Combo(id: 'F4', techniqueIds: ['step_back', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.footwork),
    Combo(id: 'F5', techniqueIds: ['in_out', '1', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
    Combo(id: 'F6', techniqueIds: ['circle_l', '1', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
    Combo(id: 'F7', techniqueIds: ['circle_r', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
    Combo(id: 'F8', techniqueIds: ['lateral', '1', '1', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
    Combo(id: 'F9', techniqueIds: ['cut_off', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
    Combo(id: 'F10', techniqueIds: ['angle_r', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.footwork),
  ];

  /// All combos for a given sport.
  static List<Combo> forSport(ComboSport sport) {
    return all.where((c) => c.sport == sport).toList();
  }

  /// Filter combos by sport and/or difficulty.
  static List<Combo> filtered({ComboSport? sport, ComboDifficulty? difficulty}) {
    return all.where((c) {
      if (sport != null && c.sport != sport) return false;
      if (difficulty != null && c.difficulty != difficulty) return false;
      return true;
    }).toList();
  }
}
