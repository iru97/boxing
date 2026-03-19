import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/programs/domain/training_program.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

/// Static library of built-in training programs.
///
/// Each program embeds full [SessionModel] instances so that program day
/// workouts are self-contained and can be passed directly to the timer.
class ProgramLibrary {
  ProgramLibrary._();

  static List<TrainingProgram> get all => [
        boxingFundamentals,
        heavyBagPower,
        shadowBoxing30Day,
      ];

  static TrainingProgram? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Program 1: Boxing Fundamentals (4 weeks, beginner, 12 days)
  // ---------------------------------------------------------------------------

  static final boxingFundamentals = TrainingProgram(
    id: 'program_boxing_fundamentals',
    name: 'Boxing Fundamentals',
    description:
        'A 4-week program for beginners that builds from basic stance and jab '
        'through hooks, uppercuts, and full combinations. Each week introduces '
        'new techniques while reinforcing fundamentals.',
    sport: 'boxing',
    difficulty: 'beginner',
    durationWeeks: 4,
    weeks: [
      // Week 1: Stance & Jab
      ProgramWeek(
        weekNumber: 1,
        name: 'Stance & Jab',
        description:
            'Master your fighting stance, guard position, and the most '
            'important punch in boxing: the jab.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Shadow Boxing Basics',
            description:
                'Focus on stance, movement, and basic 1-2 combinations. '
                'Stay relaxed, work on form over power.',
            session: _session(
              id: 'program_boxing_fund_w1d1',
              name: 'Shadow Boxing Basics',
              rounds: 4,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'relaxed',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Heavy Bag Basics',
            description:
                'Apply your jab and cross to the heavy bag. Focus on '
                'snapping your punches and returning to guard.',
            session: _session(
              id: 'program_boxing_fund_w1d2',
              name: 'Heavy Bag Basics',
              rounds: 5,
              roundDurationSec: 120,
              restDurationSec: 60,
              difficulty: 'beginner',
              intensity: 'relaxed',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Footwork + Jab',
            description:
                'Move around while jabbing. Practice stepping in, stepping '
                'out, and pivoting while maintaining your guard.',
            session: _session(
              id: 'program_boxing_fund_w1d3',
              name: 'Footwork + Jab',
              rounds: 4,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'relaxed',
              includeFootwork: true,
            ),
          ),
        ],
      ),

      // Week 2: Adding the Cross
      ProgramWeek(
        weekNumber: 2,
        name: 'Adding the Cross',
        description:
            'Build on your jab with the straight cross. Learn to generate '
            'power from hip rotation and weight transfer.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Shadow Boxing - 1-2s',
            description:
                'All about the jab-cross. Mix in double jabs and work on '
                'smooth transitions between punches.',
            session: _session(
              id: 'program_boxing_fund_w2d1',
              name: 'Shadow Boxing - 1-2s',
              rounds: 5,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Heavy Bag - Straight Punches',
            description:
                'Work 1-2, 1-1-2, and 2-1-2 combinations on the heavy bag. '
                'Focus on snapping back to guard after each combo.',
            session: _session(
              id: 'program_boxing_fund_w2d2',
              name: 'Heavy Bag - Straight Punches',
              rounds: 6,
              roundDurationSec: 120,
              restDurationSec: 60,
              difficulty: 'beginner',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Speed Work',
            description:
                'Short, intense rounds focused on hand speed. Quick 1-2 '
                'combinations with fast recovery.',
            session: _session(
              id: 'program_boxing_fund_w2d3',
              name: 'Speed Work',
              rounds: 6,
              roundDurationSec: 90,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'intense',
            ),
          ),
        ],
      ),

      // Week 3: The Hook
      ProgramWeek(
        weekNumber: 3,
        name: 'The Hook',
        description:
            'Introduce the lead hook and learn to combine it with your '
            'straight punches for devastating 3-punch combinations.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Shadow Boxing - Adding Hooks',
            description:
                'Practice the lead hook mechanics: pivot on the front foot, '
                'rotate the hips, keep the elbow at 90 degrees.',
            session: _session(
              id: 'program_boxing_fund_w3d1',
              name: 'Shadow Boxing - Adding Hooks',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Heavy Bag - Hook Combos',
            description:
                'Work 1-2-3, 2-3-2, and 1-2-3-2 combinations. Let the '
                'hook flow naturally from the cross.',
            session: _session(
              id: 'program_boxing_fund_w3d2',
              name: 'Heavy Bag - Hook Combos',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'intermediate',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Defense + Offense',
            description:
                'Combine defensive movements (slips, rolls) with counter '
                'punches. Slip the jab, counter with a 2-3.',
            session: _session(
              id: 'program_boxing_fund_w3d3',
              name: 'Defense + Offense',
              rounds: 5,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'moderate',
              includeDefense: true,
            ),
          ),
        ],
      ),

      // Week 4: Putting It Together
      ProgramWeek(
        weekNumber: 4,
        name: 'Putting It Together',
        description:
            'Combine everything you have learned: jab, cross, hook, '
            'footwork, and defense into full boxing rounds.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Shadow Boxing - Full Combos',
            description:
                'All punches, all combinations. Move, punch, defend. '
                'Visualize an opponent in front of you.',
            session: _session(
              id: 'program_boxing_fund_w4d1',
              name: 'Shadow Boxing - Full Combos',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Heavy Bag - All Weapons',
            description:
                'Full-power combinations on the heavy bag. Work body shots, '
                'level changes, and 4-5 punch combinations.',
            session: _session(
              id: 'program_boxing_fund_w4d2',
              name: 'Heavy Bag - All Weapons',
              rounds: 8,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Fight Simulation',
            description:
                'Full-intensity rounds simulating a real fight. Use '
                'everything: combinations, defense, footwork, ring control.',
            session: _session(
              id: 'program_boxing_fund_w4d3',
              name: 'Fight Simulation',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'advanced',
              intensity: 'hurricane',
            ),
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Program 2: Heavy Bag Power (3 weeks, intermediate, 9 days)
  // ---------------------------------------------------------------------------

  static final heavyBagPower = TrainingProgram(
    id: 'program_heavy_bag_power',
    name: 'Heavy Bag Power',
    description:
        'A 3-week program for intermediate boxers focused on developing '
        'knockout power on the heavy bag. Builds from single power shots '
        'through complex combinations to championship-round endurance.',
    sport: 'boxing',
    difficulty: 'intermediate',
    durationWeeks: 3,
    weeks: [
      // Week 1: Power Fundamentals
      ProgramWeek(
        weekNumber: 1,
        name: 'Power Fundamentals',
        description:
            'Focus on generating maximum power from individual punches. '
            'Sit down on your shots and drive through the bag.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Straight Punches',
            description:
                'Power jabs and crosses. Focus on full hip rotation, '
                'planting the rear foot, and driving through the target.',
            session: _session(
              id: 'program_bag_power_w1d1',
              name: 'Straight Punches',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 90,
              difficulty: 'intermediate',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Hooks & Uppercuts',
            description:
                'Power hooks and uppercuts. Drive from the legs, rotate '
                'the hips, and follow through on every shot.',
            session: _session(
              id: 'program_bag_power_w1d2',
              name: 'Hooks & Uppercuts',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 90,
              difficulty: 'intermediate',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Power Combos',
            description:
                'Combine straight punches with hooks for maximum impact. '
                'Work on transferring power between punches.',
            session: _session(
              id: 'program_bag_power_w1d3',
              name: 'Power Combos',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
        ],
      ),

      // Week 2: Combination Power
      ProgramWeek(
        weekNumber: 2,
        name: 'Combination Power',
        description:
            'Learn to maintain power through longer combinations. '
            'Every punch in the combo should hurt.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Body-Head Combos',
            description:
                'Mix body shots with head shots. Go low to bring the guard '
                'down, then come upstairs with power.',
            session: _session(
              id: 'program_bag_power_w2d1',
              name: 'Body-Head Combos',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: '4-5 Punch Combos',
            description:
                'Long combinations that break through defense. Stay '
                'balanced through every punch in the sequence.',
            session: _session(
              id: 'program_bag_power_w2d2',
              name: '4-5 Punch Combos',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Counter Punching',
            description:
                'Defensive movement followed by sharp counter combinations. '
                'Slip, then let your hands go.',
            session: _session(
              id: 'program_bag_power_w2d3',
              name: 'Counter Punching',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'intermediate',
              intensity: 'intense',
              includeDefense: true,
            ),
          ),
        ],
      ),

      // Week 3: Endurance + Power
      ProgramWeek(
        weekNumber: 3,
        name: 'Endurance + Power',
        description:
            'Maintain your power even when fatigued. Championship rounds '
            'that test your gas tank and your will.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Long Rounds',
            description:
                'Full 3-minute rounds at a measured pace. Pick your spots '
                'and throw with intention, not desperation.',
            session: _session(
              id: 'program_bag_power_w3d1',
              name: 'Long Rounds',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'advanced',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Short Rest',
            description:
                'Many rounds with minimal rest. Forces you to stay composed '
                'and throw power even when tired.',
            session: _session(
              id: 'program_bag_power_w3d2',
              name: 'Short Rest',
              rounds: 8,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'advanced',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Championship Rounds',
            description:
                'The final test: long rounds, moderate rest, maximum output. '
                'Empty the tank on every round.',
            session: _session(
              id: 'program_bag_power_w3d3',
              name: 'Championship Rounds',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 60,
              difficulty: 'advanced',
              intensity: 'hurricane',
            ),
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Program 3: 30-Day Shadow Boxing (4 weeks, beginner, 12 days)
  // ---------------------------------------------------------------------------

  static final shadowBoxing30Day = TrainingProgram(
    id: 'program_shadow_boxing_30day',
    name: '30-Day Shadow Boxing',
    description:
        'A 4-week shadow boxing program designed for complete beginners who '
        'want to learn boxing at home. Progressively increases round duration, '
        'round count, and combination complexity.',
    sport: 'boxing',
    difficulty: 'beginner',
    durationWeeks: 4,
    weeks: [
      // Week 1: Getting Started
      ProgramWeek(
        weekNumber: 1,
        name: 'Getting Started',
        description:
            'Short, easy rounds to build the habit. Focus on stance, '
            'guard, and basic movement patterns.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'First Steps',
            description:
                'Your first shadow boxing session. Practice your stance, '
                'throw some jabs, and get comfortable moving.',
            session: _session(
              id: 'program_shadow_30_w1d1',
              name: 'First Steps',
              rounds: 4,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'relaxed',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Finding Your Rhythm',
            description:
                'Work on rhythmic movement: bounce, jab, move. Do not '
                'worry about power, just flow.',
            session: _session(
              id: 'program_shadow_30_w1d2',
              name: 'Finding Your Rhythm',
              rounds: 4,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'relaxed',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Jab Variations',
            description:
                'Single jab, double jab, jab to the body. Learn to vary '
                'the most versatile punch in boxing.',
            session: _session(
              id: 'program_shadow_30_w1d3',
              name: 'Jab Variations',
              rounds: 4,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'relaxed',
            ),
          ),
        ],
      ),

      // Week 2: Building Rhythm
      ProgramWeek(
        weekNumber: 2,
        name: 'Building Rhythm',
        description:
            'One more round per session, slightly higher intensity. Start '
            'stringing 2-punch combinations together.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'The 1-2',
            description:
                'The fundamental jab-cross. Practice the weight transfer '
                'and hip rotation that makes the cross powerful.',
            session: _session(
              id: 'program_shadow_30_w2d1',
              name: 'The 1-2',
              rounds: 5,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Movement + Punches',
            description:
                'Combine footwork with combinations. Step in, throw, step '
                'out. Never stay in one place.',
            session: _session(
              id: 'program_shadow_30_w2d2',
              name: 'Movement + Punches',
              rounds: 5,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'moderate',
              includeFootwork: true,
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Combo Flow',
            description:
                'Let combinations flow naturally. 1-2, 1-1-2, step, 1-2. '
                'Focus on smooth transitions.',
            session: _session(
              id: 'program_shadow_30_w2d3',
              name: 'Combo Flow',
              rounds: 5,
              roundDurationSec: 120,
              restDurationSec: 30,
              difficulty: 'beginner',
              intensity: 'moderate',
            ),
          ),
        ],
      ),

      // Week 3: Longer Rounds
      ProgramWeek(
        weekNumber: 3,
        name: 'Longer Rounds',
        description:
            'Step up to 3-minute rounds. These are real boxing round lengths '
            'and will build your endurance.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Three-Minute Rounds',
            description:
                'Your first full-length boxing rounds. Pace yourself: '
                'start slow, pick up intensity through the round.',
            session: _session(
              id: 'program_shadow_30_w3d1',
              name: 'Three-Minute Rounds',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Adding Hooks',
            description:
                'Introduce the lead hook into your shadow boxing. 1-2-3 '
                'and 2-3-2 combinations.',
            session: _session(
              id: 'program_shadow_30_w3d2',
              name: 'Adding Hooks',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'moderate',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Offense & Defense',
            description:
                'Slip, roll, counter. Start thinking about what comes back '
                'at you after you punch.',
            session: _session(
              id: 'program_shadow_30_w3d3',
              name: 'Offense & Defense',
              rounds: 5,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'moderate',
              includeDefense: true,
            ),
          ),
        ],
      ),

      // Week 4: Full Sessions
      ProgramWeek(
        weekNumber: 4,
        name: 'Full Sessions',
        description:
            'Six full-length rounds with higher intensity. You are now '
            'shadow boxing like a real boxer.',
        days: [
          ProgramDay(
            dayNumber: 1,
            name: 'Full Workout',
            description:
                'Six rounds of free shadow boxing. Use everything you '
                'have learned: all punches, defense, footwork.',
            session: _session(
              id: 'program_shadow_30_w4d1',
              name: 'Full Workout',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 2,
            name: 'Volume Rounds',
            description:
                'High output: throw more combinations, move more, stay '
                'busy for the full three minutes.',
            session: _session(
              id: 'program_shadow_30_w4d2',
              name: 'Volume Rounds',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
          ProgramDay(
            dayNumber: 3,
            name: 'Graduation Round',
            description:
                'Your final session. Leave everything on the floor. '
                'You are no longer a beginner.',
            session: _session(
              id: 'program_shadow_30_w4d3',
              name: 'Graduation Round',
              rounds: 6,
              roundDurationSec: 180,
              restDurationSec: 30,
              difficulty: 'intermediate',
              intensity: 'intense',
            ),
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Helper to build SessionModel with combo config
  // ---------------------------------------------------------------------------

  static SessionModel _session({
    required String id,
    required String name,
    required int rounds,
    required int roundDurationSec,
    required int restDurationSec,
    required String difficulty,
    required String intensity,
    bool includeDefense = false,
    bool includeFootwork = false,
  }) {
    return SessionModel(
      id: id,
      name: name,
      rounds: rounds,
      roundDurationSec: roundDurationSec,
      restDurationSec: restDurationSec,
      warningTimeSec: 10,
      warmupDurationSec: 0,
      autoAdvance: true,
      keepScreenOn: true,
      soundPack: 'classic_bell',
      isPreset: false,
      sport: 'boxing',
      comboConfig: ComboCalloutConfig(
        enabled: true,
        sport: 'boxing',
        difficulty: difficulty,
        intensity: intensity,
        includeDefense: includeDefense,
        includeFootwork: includeFootwork,
      ),
    );
  }
}
