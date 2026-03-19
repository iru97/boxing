import 'package:boxing/core/constants/sport_presets_boxing.dart';
import 'package:boxing/core/constants/sport_presets_muay_thai.dart';
import 'package:boxing/core/constants/sport_presets_mma.dart';
import 'package:boxing/core/constants/sport_presets_bjj.dart';
import 'package:boxing/core/constants/sport_presets_kickboxing.dart';
import 'package:boxing/core/constants/sport_presets_wrestling.dart';
import 'package:boxing/core/constants/sport_presets_conditioning.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

class PresetSessions {
  PresetSessions._();

  static const List<SessionModel> all = [
    ...BoxingPresets.all,
    ...MuayThaiPresets.all,
    ...MmaPresets.all,
    ...BjjPresets.all,
    ...KickboxingPresets.all,
    ...WrestlingPresets.all,
    ...ConditioningPresets.all,
  ];
}
