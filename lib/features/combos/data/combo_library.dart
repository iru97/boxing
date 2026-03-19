import 'package:boxing/features/combos/domain/combo_model.dart';

/// Static library of all built-in combos across all supported sports.
///
/// 190 combos total:
///   Boxing:     50 (16 beginner + 18 intermediate + 16 advanced)
///   Muay Thai:  34 (10 beginner + 12 intermediate + 12 advanced)
///   MMA:        30 (8 beginner + 12 intermediate + 10 advanced)
///   Kickboxing: 28 (8 beginner + 12 intermediate + 8 advanced)
///   Wrestling:  26 (8 beginner + 10 intermediate + 8 advanced)
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
    // MMA - BEGINNER (8)
    // =================================================================
    Combo(id: 'MMA-B1', techniqueIds: ['1', '2', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B2', techniqueIds: ['1', '2', '3', 'level_change'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B3', techniqueIds: ['1', '2', 'teep'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B4', techniqueIds: ['lk', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B5', techniqueIds: ['1', '2', 'bk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B6', techniqueIds: ['teep', '2', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B7', techniqueIds: ['1', '2', '3', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),
    Combo(id: 'MMA-B8', techniqueIds: ['1', 'overhand'], difficulty: ComboDifficulty.beginner, sport: ComboSport.mma),

    // =================================================================
    // MMA - INTERMEDIATE (12)
    // =================================================================
    Combo(id: 'MMA-I1', techniqueIds: ['1', '2', 'bk', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I2', techniqueIds: ['lk', '1', 'superman'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I3', techniqueIds: ['1', '2', '3', '2', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I4', techniqueIds: ['teep', '1', '2', '3', 'hk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I5', techniqueIds: ['sprawl', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I6', techniqueIds: ['1', '2', 'level_change', 'takedown'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I7', techniqueIds: ['overhand', '3', 'clinch', 'rear_knee'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I8', techniqueIds: ['1', '2', 'bk', 'level_change'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I9', techniqueIds: ['lk', '2', '3', 'teep'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I10', techniqueIds: ['1', 'overhand', 'clinch'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I11', techniqueIds: ['sprawl', 'overhand', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),
    Combo(id: 'MMA-I12', techniqueIds: ['1', '2', 'duck', 'bk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.mma),

    // =================================================================
    // MMA - ADVANCED (10)
    // =================================================================
    Combo(id: 'MMA-A1', techniqueIds: ['1', '2', 'clinch', 'rear_knee', 'lead_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A2', techniqueIds: ['1', '2', 'duck', '2', 'lk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A3', techniqueIds: ['bk', '2', '3', 'level_change', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A4', techniqueIds: ['sprawl', '2', '3', 'overhand', 'clinch', 'rear_knee'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A5', techniqueIds: ['1', '2', '3', 'bk', 'level_change', 'ground_strike'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A6', techniqueIds: ['teep', 'overhand', '3', 'clinch', 'lead_knee', 'lead_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A7', techniqueIds: ['lk', '1', '2', 'duck', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A8', techniqueIds: ['1', '2', '3', '2', 'bk', 'clinch_break', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A9', techniqueIds: ['superman', '2', '3', 'level_change', 'single_leg'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),
    Combo(id: 'MMA-A10', techniqueIds: ['1', '2', 'sprawl', '2', '3', 'hk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.mma),

    // =================================================================
    // KICKBOXING - BEGINNER (8)
    // =================================================================
    Combo(id: 'KB-B1', techniqueIds: ['1', '2', 'lk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B2', techniqueIds: ['1', '2', 'hk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B3', techniqueIds: ['1', '2', '3', 'bk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B4', techniqueIds: ['teep', '1', '2'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B5', techniqueIds: ['lk', '2', '3'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B6', techniqueIds: ['1', '2', 'teep'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B7', techniqueIds: ['1', 'bk'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),
    Combo(id: 'KB-B8', techniqueIds: ['1', '2', 'switch_kick'], difficulty: ComboDifficulty.beginner, sport: ComboSport.kickboxing),

    // =================================================================
    // KICKBOXING - INTERMEDIATE (12)
    // =================================================================
    Combo(id: 'KB-I1', techniqueIds: ['lk', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I2', techniqueIds: ['1', '2', '3', '2', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I3', techniqueIds: ['2', '3', 'hk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I4', techniqueIds: ['switch_kick', '2', '3', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I5', techniqueIds: ['teep', '1', '2', 'bk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I6', techniqueIds: ['1', '2', '3', 'bk', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I7', techniqueIds: ['lk', 'lk', '1', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I8', techniqueIds: ['check', '2', '3', 'lk'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I9', techniqueIds: ['1', '2', 'hk', '2'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I10', techniqueIds: ['bk', '2', '3', 'teep'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I11', techniqueIds: ['1', '2', 'switch_kick', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),
    Combo(id: 'KB-I12', techniqueIds: ['teep', 'lk', '1', '2', '3'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.kickboxing),

    // =================================================================
    // KICKBOXING - ADVANCED (8)
    // =================================================================
    Combo(id: 'KB-A1', techniqueIds: ['1', '2', 'slip_r', '2', 'lk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A2', techniqueIds: ['1', '2', '3', 'switch_kick', '2'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A3', techniqueIds: ['lk', '1', '2', '3', 'hk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A4', techniqueIds: ['teep', '2', '3', 'spinning_back_kick'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A5', techniqueIds: ['1', '2', 'duck', 'bk', '2', '3'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A6', techniqueIds: ['check', 'lk', '1', '2', '3', 'hk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A7', techniqueIds: ['switch_kick', '1', '2', '3', 'axe_kick'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),
    Combo(id: 'KB-A8', techniqueIds: ['1', '2', '3', 'bk', 'slip_l', '2', 'hk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.kickboxing),

    // =================================================================
    // WRESTLING - BEGINNER (8)
    // =================================================================
    Combo(id: 'WR-B1', techniqueIds: ['shot'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B2', techniqueIds: ['snap_down'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B3', techniqueIds: ['stand_up'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B4', techniqueIds: ['switch_wr'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B5', techniqueIds: ['sit_out'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B6', techniqueIds: ['single_leg'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B7', techniqueIds: ['double_leg'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),
    Combo(id: 'WR-B8', techniqueIds: ['sprawl'], difficulty: ComboDifficulty.beginner, sport: ComboSport.wrestling),

    // =================================================================
    // WRESTLING - INTERMEDIATE (10)
    // =================================================================
    Combo(id: 'WR-I1', techniqueIds: ['shot', 'single_leg'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I2', techniqueIds: ['snap_down', 'front_headlock'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I3', techniqueIds: ['arm_drag', 'single_leg'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I4', techniqueIds: ['duck_under', 'takedown'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I5', techniqueIds: ['sprawl', 'front_headlock'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I6', techniqueIds: ['sit_out', 'stand_up'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I7', techniqueIds: ['ankle_pick', 'takedown'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I8', techniqueIds: ['snap_down', 'shot'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I9', techniqueIds: ['switch_wr', 'stand_up'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),
    Combo(id: 'WR-I10', techniqueIds: ['arm_drag', 'double_leg'], difficulty: ComboDifficulty.intermediate, sport: ComboSport.wrestling),

    // =================================================================
    // WRESTLING - ADVANCED (8)
    // =================================================================
    Combo(id: 'WR-A1', techniqueIds: ['single_leg', 'double_leg', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A2', techniqueIds: ['snap_down', 'front_headlock', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A3', techniqueIds: ['arm_drag', 'duck_under', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A4', techniqueIds: ['shot', 'sprawl', 'front_headlock', 'snap_down'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A5', techniqueIds: ['sit_out', 'switch_wr', 'stand_up'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A6', techniqueIds: ['ankle_pick', 'single_leg', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A7', techniqueIds: ['snap_down', 'arm_drag', 'double_leg'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),
    Combo(id: 'WR-A8', techniqueIds: ['duck_under', 'snap_down', 'front_headlock', 'takedown'], difficulty: ComboDifficulty.advanced, sport: ComboSport.wrestling),

    // =================================================================
    // MUAY THAI - ADVANCED (extra 4 to fill gap)
    // =================================================================
    Combo(id: 'MT-A9', techniqueIds: ['1', '2', 'clinch', 'diagonal_knee', 'spinning_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A10', techniqueIds: ['lk', 'lk', '2', '3', 'hk'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A11', techniqueIds: ['teep', '1', '2', '3', 'spinning_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),
    Combo(id: 'MT-A12', techniqueIds: ['bk', 'clinch', 'diagonal_knee', 'lead_elbow', 'rear_elbow'], difficulty: ComboDifficulty.advanced, sport: ComboSport.muayThai),

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

  /// Filter combos by sport and/or difficulty (exact match).
  static List<Combo> filtered({ComboSport? sport, ComboDifficulty? difficulty}) {
    return all.where((c) {
      if (sport != null && c.sport != sport) return false;
      if (difficulty != null && c.difficulty != difficulty) return false;
      return true;
    }).toList();
  }

  /// Filter combos with cumulative difficulty: selecting intermediate
  /// includes beginner + intermediate, advanced includes all levels.
  /// This gives larger pools at higher difficulties.
  static List<Combo> filteredCumulative({
    required ComboSport sport,
    required ComboDifficulty maxDifficulty,
  }) {
    return all.where((c) {
      if (c.sport != sport) return false;
      return c.difficulty.index <= maxDifficulty.index;
    }).toList();
  }

  /// Filter combos whose techniques all belong to the given categories.
  /// Used for segment-aware combo callouts (e.g., kick-only segments).
  static List<Combo> filteredByCategories({
    required List<Combo> pool,
    required List<String> categories,
    required Map<String, dynamic> techniques,
  }) {
    if (categories.isEmpty) return pool;
    return pool.where((combo) {
      return combo.techniqueIds.every((id) {
        final technique = techniques[id];
        if (technique == null) return false;
        return categories.contains(technique.category.name);
      });
    }).toList();
  }
}
