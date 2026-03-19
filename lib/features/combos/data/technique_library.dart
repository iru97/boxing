import 'package:boxing/features/combos/domain/technique.dart';

/// Static library of all combat techniques across all supported sports.
///
/// 47 techniques total: 12 punches, 10 defense, 10 footwork, 12 Muay Thai, 3 MMA.
class TechniqueLibrary {
  TechniqueLibrary._();

  /// Lookup a technique by ID. Returns null if not found.
  static Technique? byId(String id) => all[id];

  /// All techniques indexed by their ID.
  static const Map<String, Technique> all = {
    // ---------------------------------------------------------------
    // Punches (12)
    // ---------------------------------------------------------------
    '1': Technique(
      id: '1',
      displayText: '1',
      ttsText: {'en': 'Jab', 'es': 'Jab', 'pt': 'Jab'},
      category: TechniqueCategory.punch,
    ),
    '2': Technique(
      id: '2',
      displayText: '2',
      ttsText: {'en': 'Cross', 'es': 'Cross', 'pt': 'Cross'},
      category: TechniqueCategory.punch,
    ),
    '3': Technique(
      id: '3',
      displayText: '3',
      ttsText: {'en': 'Hook', 'es': 'Gancho', 'pt': 'Gancho'},
      category: TechniqueCategory.punch,
    ),
    '4': Technique(
      id: '4',
      displayText: '4',
      ttsText: {'en': 'Rear hook', 'es': 'Gancho trasero', 'pt': 'Gancho traseiro'},
      category: TechniqueCategory.punch,
    ),
    '5': Technique(
      id: '5',
      displayText: '5',
      ttsText: {'en': 'Uppercut', 'es': 'Uppercut', 'pt': 'Uppercut'},
      category: TechniqueCategory.punch,
    ),
    '6': Technique(
      id: '6',
      displayText: '6',
      ttsText: {'en': 'Rear uppercut', 'es': 'Uppercut trasero', 'pt': 'Uppercut traseiro'},
      category: TechniqueCategory.punch,
    ),
    '1b': Technique(
      id: '1b',
      displayText: '1b',
      ttsText: {'en': 'Jab body', 'es': 'Jab cuerpo', 'pt': 'Jab corpo'},
      category: TechniqueCategory.punch,
    ),
    '2b': Technique(
      id: '2b',
      displayText: '2b',
      ttsText: {'en': 'Cross body', 'es': 'Cross cuerpo', 'pt': 'Cross corpo'},
      category: TechniqueCategory.punch,
    ),
    '3b': Technique(
      id: '3b',
      displayText: '3b',
      ttsText: {'en': 'Hook body', 'es': 'Gancho cuerpo', 'pt': 'Gancho corpo'},
      category: TechniqueCategory.punch,
    ),
    '4b': Technique(
      id: '4b',
      displayText: '4b',
      ttsText: {'en': 'Rear hook body', 'es': 'Gancho trasero cuerpo', 'pt': 'Gancho traseiro corpo'},
      category: TechniqueCategory.punch,
    ),
    '5b': Technique(
      id: '5b',
      displayText: '5b',
      ttsText: {'en': 'Uppercut body', 'es': 'Uppercut cuerpo', 'pt': 'Uppercut corpo'},
      category: TechniqueCategory.punch,
    ),
    '6b': Technique(
      id: '6b',
      displayText: '6b',
      ttsText: {'en': 'Rear uppercut body', 'es': 'Uppercut trasero cuerpo', 'pt': 'Uppercut traseiro corpo'},
      category: TechniqueCategory.punch,
    ),

    // ---------------------------------------------------------------
    // Defense (10)
    // ---------------------------------------------------------------
    'slip_l': Technique(
      id: 'slip_l',
      displayText: 'SL',
      ttsText: {'en': 'Slip left', 'es': 'Esquiva izquierda', 'pt': 'Esquiva esquerda'},
      category: TechniqueCategory.defense,
    ),
    'slip_r': Technique(
      id: 'slip_r',
      displayText: 'SR',
      ttsText: {'en': 'Slip right', 'es': 'Esquiva derecha', 'pt': 'Esquiva direita'},
      category: TechniqueCategory.defense,
    ),
    'roll': Technique(
      id: 'roll',
      displayText: 'R',
      ttsText: {'en': 'Roll', 'es': 'Rolar', 'pt': 'Rolar'},
      category: TechniqueCategory.defense,
    ),
    'block': Technique(
      id: 'block',
      displayText: 'B',
      ttsText: {'en': 'Block', 'es': 'Bloquear', 'pt': 'Bloquear'},
      category: TechniqueCategory.defense,
    ),
    'parry': Technique(
      id: 'parry',
      displayText: 'P',
      ttsText: {'en': 'Parry', 'es': 'Desviar', 'pt': 'Defletir'},
      category: TechniqueCategory.defense,
    ),
    'pull': Technique(
      id: 'pull',
      displayText: 'PB',
      ttsText: {'en': 'Pull back', 'es': 'Retroceder', 'pt': 'Recuar'},
      category: TechniqueCategory.defense,
    ),
    'catch_t': Technique(
      id: 'catch_t',
      displayText: 'C',
      ttsText: {'en': 'Catch', 'es': 'Atrapar', 'pt': 'Pegar'},
      category: TechniqueCategory.defense,
    ),
    'duck': Technique(
      id: 'duck',
      displayText: 'D',
      ttsText: {'en': 'Duck', 'es': 'Agacharse', 'pt': 'Agachar'},
      category: TechniqueCategory.defense,
    ),
    'cover': Technique(
      id: 'cover',
      displayText: 'CV',
      ttsText: {'en': 'Cover', 'es': 'Cubrirse', 'pt': 'Cobrir'},
      category: TechniqueCategory.defense,
    ),
    'shoulder_roll': Technique(
      id: 'shoulder_roll',
      displayText: 'ShR',
      ttsText: {'en': 'Shoulder roll', 'es': 'Shoulder roll', 'pt': 'Shoulder roll'},
      category: TechniqueCategory.defense,
    ),

    // ---------------------------------------------------------------
    // Footwork (10)
    // ---------------------------------------------------------------
    'pivot_l': Technique(
      id: 'pivot_l',
      displayText: 'PvL',
      ttsText: {'en': 'Pivot left', 'es': 'Pivote izquierda', 'pt': 'Pivo esquerda'},
      category: TechniqueCategory.footwork,
    ),
    'pivot_r': Technique(
      id: 'pivot_r',
      displayText: 'PvR',
      ttsText: {'en': 'Pivot right', 'es': 'Pivote derecha', 'pt': 'Pivo direita'},
      category: TechniqueCategory.footwork,
    ),
    'angle_l': Technique(
      id: 'angle_l',
      displayText: 'AL',
      ttsText: {'en': 'Angle left', 'es': 'Angulo izquierda', 'pt': 'Angulo esquerda'},
      category: TechniqueCategory.footwork,
    ),
    'angle_r': Technique(
      id: 'angle_r',
      displayText: 'AR',
      ttsText: {'en': 'Angle right', 'es': 'Angulo derecha', 'pt': 'Angulo direita'},
      category: TechniqueCategory.footwork,
    ),
    'step_back': Technique(
      id: 'step_back',
      displayText: 'SB',
      ttsText: {'en': 'Step back', 'es': 'Paso atras', 'pt': 'Passo atras'},
      category: TechniqueCategory.footwork,
    ),
    'cut_off': Technique(
      id: 'cut_off',
      displayText: 'CO',
      ttsText: {'en': 'Cut off', 'es': 'Cortar', 'pt': 'Cortar'},
      category: TechniqueCategory.footwork,
    ),
    'circle_l': Technique(
      id: 'circle_l',
      displayText: 'CiL',
      ttsText: {'en': 'Circle left', 'es': 'Circular izquierda', 'pt': 'Circular esquerda'},
      category: TechniqueCategory.footwork,
    ),
    'circle_r': Technique(
      id: 'circle_r',
      displayText: 'CiR',
      ttsText: {'en': 'Circle right', 'es': 'Circular derecha', 'pt': 'Circular direita'},
      category: TechniqueCategory.footwork,
    ),
    'in_out': Technique(
      id: 'in_out',
      displayText: 'IO',
      ttsText: {'en': 'In and out', 'es': 'Entrar y salir', 'pt': 'Entrar e sair'},
      category: TechniqueCategory.footwork,
    ),
    'lateral': Technique(
      id: 'lateral',
      displayText: 'LT',
      ttsText: {'en': 'Lateral', 'es': 'Lateral', 'pt': 'Lateral'},
      category: TechniqueCategory.footwork,
    ),

    // ---------------------------------------------------------------
    // Muay Thai - Kicks (6)
    // ---------------------------------------------------------------
    'lk': Technique(
      id: 'lk',
      displayText: 'LK',
      ttsText: {'en': 'Low kick', 'es': 'Patada baja', 'pt': 'Chute baixo'},
      category: TechniqueCategory.kick,
    ),
    'hk': Technique(
      id: 'hk',
      displayText: 'HK',
      ttsText: {'en': 'High kick', 'es': 'Patada alta', 'pt': 'Chute alto'},
      category: TechniqueCategory.kick,
    ),
    'bk': Technique(
      id: 'bk',
      displayText: 'BK',
      ttsText: {'en': 'Body kick', 'es': 'Patada cuerpo', 'pt': 'Chute corpo'},
      category: TechniqueCategory.kick,
    ),
    'switch_kick': Technique(
      id: 'switch_kick',
      displayText: 'SK',
      ttsText: {'en': 'Switch kick', 'es': 'Patada switch', 'pt': 'Chute switch'},
      category: TechniqueCategory.kick,
    ),
    'teep': Technique(
      id: 'teep',
      displayText: 'T',
      ttsText: {'en': 'Teep', 'es': 'Teep', 'pt': 'Teep'},
      category: TechniqueCategory.kick,
    ),
    'rear_teep': Technique(
      id: 'rear_teep',
      displayText: 'RT',
      ttsText: {'en': 'Rear teep', 'es': 'Teep trasero', 'pt': 'Teep traseiro'},
      category: TechniqueCategory.kick,
    ),

    // ---------------------------------------------------------------
    // Muay Thai - Elbows (3)
    // ---------------------------------------------------------------
    'lead_elbow': Technique(
      id: 'lead_elbow',
      displayText: 'E',
      ttsText: {'en': 'Elbow', 'es': 'Codo', 'pt': 'Cotovelada'},
      category: TechniqueCategory.elbow,
    ),
    'rear_elbow': Technique(
      id: 'rear_elbow',
      displayText: 'RE',
      ttsText: {'en': 'Rear elbow', 'es': 'Codo trasero', 'pt': 'Cotovelada traseira'},
      category: TechniqueCategory.elbow,
    ),
    'up_elbow': Technique(
      id: 'up_elbow',
      displayText: 'UE',
      ttsText: {'en': 'Up elbow', 'es': 'Codo ascendente', 'pt': 'Cotovelada ascendente'},
      category: TechniqueCategory.elbow,
    ),

    // ---------------------------------------------------------------
    // Muay Thai - Knees & Clinch (3)
    // ---------------------------------------------------------------
    'lead_knee': Technique(
      id: 'lead_knee',
      displayText: 'K',
      ttsText: {'en': 'Knee', 'es': 'Rodilla', 'pt': 'Joelhada'},
      category: TechniqueCategory.knee,
    ),
    'rear_knee': Technique(
      id: 'rear_knee',
      displayText: 'RK',
      ttsText: {'en': 'Rear knee', 'es': 'Rodilla trasera', 'pt': 'Joelhada traseira'},
      category: TechniqueCategory.knee,
    ),
    'clinch': Technique(
      id: 'clinch',
      displayText: 'CL',
      ttsText: {'en': 'Clinch', 'es': 'Clinch', 'pt': 'Clinch'},
      category: TechniqueCategory.grappling,
    ),

    // ---------------------------------------------------------------
    // MMA / Grappling
    // ---------------------------------------------------------------
    'level_change': Technique(
      id: 'level_change',
      displayText: 'LC',
      ttsText: {'en': 'Level change', 'es': 'Cambio de nivel', 'pt': 'Mudanca de nivel'},
      category: TechniqueCategory.grappling,
    ),
    'sprawl': Technique(
      id: 'sprawl',
      displayText: 'SP',
      ttsText: {'en': 'Sprawl', 'es': 'Sprawl', 'pt': 'Sprawl'},
      category: TechniqueCategory.grappling,
    ),
    'superman': Technique(
      id: 'superman',
      displayText: 'SM',
      ttsText: {'en': 'Superman punch', 'es': 'Golpe superman', 'pt': 'Soco superman'},
      category: TechniqueCategory.punch,
    ),
    'takedown': Technique(
      id: 'takedown',
      displayText: 'TD',
      ttsText: {'en': 'Takedown', 'es': 'Derribo', 'pt': 'Queda'},
      category: TechniqueCategory.grappling,
    ),
    'single_leg': Technique(
      id: 'single_leg',
      displayText: 'SL',
      ttsText: {'en': 'Single leg', 'es': 'Una pierna', 'pt': 'Uma perna'},
      category: TechniqueCategory.grappling,
    ),
    'double_leg': Technique(
      id: 'double_leg',
      displayText: 'DL',
      ttsText: {'en': 'Double leg', 'es': 'Dos piernas', 'pt': 'Duas pernas'},
      category: TechniqueCategory.grappling,
    ),
    'clinch_break': Technique(
      id: 'clinch_break',
      displayText: 'CB',
      ttsText: {'en': 'Break clinch', 'es': 'Romper clinch', 'pt': 'Quebrar clinch'},
      category: TechniqueCategory.grappling,
    ),
    'overhand': Technique(
      id: 'overhand',
      displayText: 'OH',
      ttsText: {'en': 'Overhand', 'es': 'Overhand', 'pt': 'Overhand'},
      category: TechniqueCategory.punch,
    ),
    'ground_strike': Technique(
      id: 'ground_strike',
      displayText: 'GS',
      ttsText: {'en': 'Ground strikes', 'es': 'Golpes al suelo', 'pt': 'Golpes no chao'},
      category: TechniqueCategory.punch,
    ),

    // ---------------------------------------------------------------
    // Kickboxing extras
    // ---------------------------------------------------------------
    'spinning_back_kick': Technique(
      id: 'spinning_back_kick',
      displayText: 'SBK',
      ttsText: {'en': 'Spinning back kick', 'es': 'Patada giratoria', 'pt': 'Chute giratório'},
      category: TechniqueCategory.kick,
    ),
    'axe_kick': Technique(
      id: 'axe_kick',
      displayText: 'AK',
      ttsText: {'en': 'Axe kick', 'es': 'Patada hacha', 'pt': 'Chute machado'},
      category: TechniqueCategory.kick,
    ),
    'check': Technique(
      id: 'check',
      displayText: 'CK',
      ttsText: {'en': 'Check', 'es': 'Bloquear patada', 'pt': 'Checar chute'},
      category: TechniqueCategory.defense,
    ),

    // ---------------------------------------------------------------
    // Muay Thai extras
    // ---------------------------------------------------------------
    'spinning_elbow': Technique(
      id: 'spinning_elbow',
      displayText: 'SE',
      ttsText: {'en': 'Spinning elbow', 'es': 'Codo giratorio', 'pt': 'Cotovelada giratória'},
      category: TechniqueCategory.elbow,
    ),
    'diagonal_knee': Technique(
      id: 'diagonal_knee',
      displayText: 'DK',
      ttsText: {'en': 'Diagonal knee', 'es': 'Rodilla diagonal', 'pt': 'Joelhada diagonal'},
      category: TechniqueCategory.knee,
    ),

    // ---------------------------------------------------------------
    // Wrestling
    // ---------------------------------------------------------------
    'shot': Technique(
      id: 'shot',
      displayText: 'SH',
      ttsText: {'en': 'Shoot', 'es': 'Entrada', 'pt': 'Entrada'},
      category: TechniqueCategory.grappling,
    ),
    'snap_down': Technique(
      id: 'snap_down',
      displayText: 'SD',
      ttsText: {'en': 'Snap down', 'es': 'Tirar abajo', 'pt': 'Puxar para baixo'},
      category: TechniqueCategory.grappling,
    ),
    'duck_under': Technique(
      id: 'duck_under',
      displayText: 'DU',
      ttsText: {'en': 'Duck under', 'es': 'Pasar por debajo', 'pt': 'Passar por baixo'},
      category: TechniqueCategory.grappling,
    ),
    'front_headlock': Technique(
      id: 'front_headlock',
      displayText: 'FH',
      ttsText: {'en': 'Front headlock', 'es': 'Guillotina frontal', 'pt': 'Guilhotina frontal'},
      category: TechniqueCategory.grappling,
    ),
    'stand_up': Technique(
      id: 'stand_up',
      displayText: 'SU',
      ttsText: {'en': 'Stand up', 'es': 'Levantarse', 'pt': 'Levantar'},
      category: TechniqueCategory.grappling,
    ),
    'switch_wr': Technique(
      id: 'switch_wr',
      displayText: 'SW',
      ttsText: {'en': 'Switch', 'es': 'Cambiar', 'pt': 'Trocar'},
      category: TechniqueCategory.grappling,
    ),
    'sit_out': Technique(
      id: 'sit_out',
      displayText: 'SO',
      ttsText: {'en': 'Sit out', 'es': 'Salida lateral', 'pt': 'Saída lateral'},
      category: TechniqueCategory.grappling,
    ),
    'ankle_pick': Technique(
      id: 'ankle_pick',
      displayText: 'AP',
      ttsText: {'en': 'Ankle pick', 'es': 'Tomar tobillo', 'pt': 'Pegar tornozelo'},
      category: TechniqueCategory.grappling,
    ),
    'arm_drag': Technique(
      id: 'arm_drag',
      displayText: 'AD',
      ttsText: {'en': 'Arm drag', 'es': 'Arrastre de brazo', 'pt': 'Arrasto de braco'},
      category: TechniqueCategory.grappling,
    ),
  };
}
