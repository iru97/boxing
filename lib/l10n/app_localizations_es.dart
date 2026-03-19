// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Boxing Timer';

  @override
  String get appBrandName => 'BOXING';

  @override
  String get appTagline => 'ENTRENA COMO PELEAS';

  @override
  String get sectionMySessionsTitle => 'Mis Sesiones';

  @override
  String get sectionQuickStartTitle => 'Inicio Rapido';

  @override
  String get sectionPresetsTitle => 'Presets';

  @override
  String get categoryBoxing => 'Boxeo';

  @override
  String get categoryBagWork => 'Saco';

  @override
  String get categoryConditioning => 'Acondicionamiento';

  @override
  String get categoryCombatSport => 'Deporte de Combate';

  @override
  String get categoryBeginner => 'Principiante';

  @override
  String get categoryCompound => 'Compuesto';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDuplicate => 'Duplicar';

  @override
  String get actionDuplicateAsCustom => 'Duplicar como personalizada';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get buttonCancel => 'CANCELAR';

  @override
  String get buttonEnd => 'TERMINAR';

  @override
  String get buttonStart => 'INICIAR';

  @override
  String get buttonSave => 'GUARDAR';

  @override
  String get buttonRepeat => 'REPETIR';

  @override
  String get buttonDone => 'LISTO';

  @override
  String get buttonSaveExit => 'GUARDAR Y SALIR';

  @override
  String get deleteSessionTitle => '¿Eliminar sesion?';

  @override
  String deleteSessionMessage(String name) {
    return '¿Eliminar \"$name\"? Esta accion no se puede deshacer.';
  }

  @override
  String snackbarSessionCreated(String name) {
    return '\"$name\" creada';
  }

  @override
  String snackbarSessionDeleted(String name) {
    return '\"$name\" eliminada';
  }

  @override
  String snackbarSessionSaved(String name) {
    return '\"$name\" guardada';
  }

  @override
  String get sessionNotFound => 'Sesion no encontrada';

  @override
  String sessionCardRoundsFormat(int rounds) {
    return '${rounds}R';
  }

  @override
  String sessionCardQuickFormat(int rounds, int minutes) {
    return '${rounds}R  $minutes min';
  }

  @override
  String sessionCardWorkRest(String work, String rest, int minutes) {
    return '$work trabajo · $rest descanso · $minutes min';
  }

  @override
  String sessionCardWorkOnly(String work, int minutes) {
    return '$work trabajo · $minutes min';
  }

  @override
  String get editSessionTitle => 'Editar Sesion';

  @override
  String get customizePresetTitle => 'Personalizar Preset';

  @override
  String get newSessionTitle => 'Nueva Sesion';

  @override
  String get labelSessionName => 'Nombre de la Sesion';

  @override
  String get hintSessionName => 'ej. Trabajo de Saco';

  @override
  String get validationNameRequired => 'El nombre es obligatorio';

  @override
  String get labelRounds => 'Rounds';

  @override
  String get labelRoundDuration => 'Duracion del Round';

  @override
  String get labelRestDuration => 'Duracion del Descanso';

  @override
  String get labelRoundStructure => 'Estructura del Round';

  @override
  String get labelWarningTime => 'Tiempo de Aviso';

  @override
  String get labelWarmup => 'Calentamiento';

  @override
  String get valueOff => 'No';

  @override
  String valueSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get roundStructureSimple => 'Simple';

  @override
  String get labelAutoAdvance => 'Avance automatico';

  @override
  String get descriptionAutoAdvance =>
      'Iniciar siguiente round despues del descanso';

  @override
  String get labelKeepScreenOn => 'Mantener Pantalla';

  @override
  String get descriptionKeepScreenOn =>
      'Evitar que la pantalla se apague durante el entrenamiento';

  @override
  String get sessionSummaryTitle => 'Resumen de Sesion';

  @override
  String sessionSummaryRounds(int rounds, String duration) {
    return '$rounds rounds × $duration';
  }

  @override
  String sessionSummaryRest(String duration) {
    return ' / $duration descanso';
  }

  @override
  String sessionSummaryTotal(String duration) {
    return 'Total: $duration';
  }

  @override
  String templateRepeatCount(int count, String duration) {
    return '× $count = $duration total';
  }

  @override
  String get timerScreenTitle => 'Temporizador';

  @override
  String get timerEndWorkoutTitle => '¿Terminar Entrenamiento?';

  @override
  String timerEndWorkoutMessage(int current, int total) {
    return 'Estas en el round $current de $total.';
  }

  @override
  String get timerStopConfirmation => '¿Seguro que quieres parar?';

  @override
  String get labelWarning => 'Aviso';

  @override
  String warningBeforeEnd(int seconds) {
    return '${seconds}s antes del final';
  }

  @override
  String get labelTotalTime => 'Tiempo Total';

  @override
  String get labelSegmentsPerRound => 'Segmentos por Round';

  @override
  String totalElapsedFormat(String duration) {
    return 'Total: $duration';
  }

  @override
  String get phaseLabelReady => 'LISTO';

  @override
  String get phaseLabelWarmup => 'CALENTAMIENTO';

  @override
  String get phaseLabelWork => 'TRABAJO';

  @override
  String get phaseLabelRest => 'DESCANSO';

  @override
  String get phaseLabelPaused => 'PAUSADO';

  @override
  String get phaseLabelComplete => 'COMPLETO';

  @override
  String get sessionCompleteTitle => 'SESION COMPLETA';

  @override
  String sessionCompleteRounds(int rounds) {
    return '$rounds rounds completados';
  }

  @override
  String sessionCompleteTotalTime(String duration) {
    return 'Tiempo total: $duration';
  }

  @override
  String roundIndicatorFormat(int current, int total) {
    return 'ROUND $current / $total';
  }

  @override
  String get a11yPreviousRound => 'Round anterior';

  @override
  String get a11yResume => 'Reanudar';

  @override
  String get a11yPause => 'Pausar';

  @override
  String get a11yNextRound => 'Siguiente round';

  @override
  String a11yCountdownRemaining(int minutes, int seconds) {
    return '$minutes minutos $seconds segundos restantes';
  }

  @override
  String get settingsScreenTitle => 'Ajustes';

  @override
  String get sectionTimerDefaults => 'Valores por Defecto';

  @override
  String get labelDefaultWarmup => 'Calentamiento por Defecto';

  @override
  String get labelDefaultWarning => 'Aviso por Defecto';

  @override
  String get descriptionAutoAdvanceSettings =>
      'Iniciar siguiente round despues del descanso';

  @override
  String get descriptionKeepScreenOnSettings =>
      'Evitar suspension de pantalla durante entrenamiento';

  @override
  String get labelResumeCountdown => 'Cuenta Regresiva al Reanudar';

  @override
  String get descriptionResumeCountdown => 'Mostrar 3-2-1 al reanudar';

  @override
  String get sectionAudio => 'Audio';

  @override
  String get labelDefaultSoundPack => 'Sonidos por Defecto';

  @override
  String get labelVolumeOverride => 'Forzar Volumen';

  @override
  String get descriptionVolumeOverride =>
      'Usar canal de alarma para alertas mas fuertes';

  @override
  String get labelHapticFeedback => 'Vibracion';

  @override
  String get descriptionHapticFeedback => 'Vibrar al inicio/fin de round';

  @override
  String get sectionDisplay => 'Pantalla';

  @override
  String get labelTheme => 'Tema';

  @override
  String get labelLanguage => 'Idioma';

  @override
  String get languagePickerTitle => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get labelTapToPause => 'Tocar para Pausar';

  @override
  String get descriptionTapToPause =>
      'Tocar en cualquier parte del temporizador para pausar/reanudar';

  @override
  String get sectionAbout => 'Acerca de';

  @override
  String get labelVersion => 'Version';

  @override
  String get labelLicenses => 'Licencias';

  @override
  String get soundPackClassicBell => 'Campana Clasica';

  @override
  String get soundPackDigitalBuzzer => 'Timbre Digital';

  @override
  String get soundPackMinimalBeep => 'Beep Minimo';

  @override
  String get soundPackPickerTitle => 'Sonidos';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themePickerTitle => 'Tema';

  @override
  String get presetProBoxingMen => 'Boxeo Pro (Hombres)';

  @override
  String get presetProBoxingWomen => 'Boxeo Pro (Mujeres)';

  @override
  String get presetAmateurBoxing => 'Boxeo Amateur';

  @override
  String get presetAmateurWomen => 'Amateur Mujeres';

  @override
  String get presetShadowBoxing => 'Sombra';

  @override
  String get presetHeavyBag => 'Saco Pesado';

  @override
  String get presetSpeedBag => 'Pera de Velocidad';

  @override
  String get presetSparring => 'Sparring';

  @override
  String get presetPadWork => 'Manoplas';

  @override
  String get presetConditioning => 'Acondicionamiento';

  @override
  String get presetTabata => 'Tabata';

  @override
  String get presetEmom => 'EMOM';

  @override
  String get presetBeginner => 'Principiante';

  @override
  String get presetYouthBoxing => 'Boxeo Juvenil';

  @override
  String get presetMuayThai => 'Muay Thai';

  @override
  String get presetMma => 'MMA';

  @override
  String get presetKickboxing => 'Kickboxing';

  @override
  String get presetOffenseDefense => 'Ataque / Defensa';

  @override
  String get presetBagConditioning => 'Saco + Funcional';

  @override
  String get presetBurnoutRounds => 'Rounds de Quema';

  @override
  String get templateOffenseDefense => 'Ataque / Defensa';

  @override
  String get segmentOffense => 'Ataque';

  @override
  String get segmentDefense => 'Defensa';

  @override
  String get templateBagConditioning => 'Saco + Funcional';

  @override
  String get segmentBagWork => 'Saco';

  @override
  String get segmentConditioning => 'Acondicionamiento';

  @override
  String get templateBurnoutFinisher => 'Quema Final';

  @override
  String get segmentNormal => 'Normal';

  @override
  String get segmentHard => 'Fuerte';

  @override
  String get segmentAllOut => 'Todo';

  @override
  String get templatePyramid => 'Piramide';

  @override
  String get segmentBuild => 'Subir';

  @override
  String get segmentPeak => 'Pico';

  @override
  String get segmentTaper => 'Bajar';

  @override
  String get templateStationRotation => 'Rotacion de Estaciones';

  @override
  String get segmentJumpRope => 'Saltar Cuerda';

  @override
  String get segmentShadowBox => 'Sombra';

  @override
  String get templateModeAll => 'Igual para todos los rounds';

  @override
  String get templateModePerRound => 'Personalizar por round';

  @override
  String get templateCreateCustom => 'Personalizada';

  @override
  String get templateEditCopy => 'Editar Copia';

  @override
  String get templateSimple => 'Simple';

  @override
  String get segmentEditorTitle => 'Estructura del Round';

  @override
  String get segmentEditorNameLabel => 'Nombre de la Estructura';

  @override
  String get segmentEditorNameHint => 'ej. Combo de Saco';

  @override
  String get segmentEditorNameRequired => 'El nombre es obligatorio';

  @override
  String get segmentAdd => 'Agregar Segmento';

  @override
  String get segmentLabelField => 'Actividad';

  @override
  String get segmentDurationField => 'Duracion';

  @override
  String segmentMaxReached(int max) {
    return 'Maximo $max segmentos';
  }

  @override
  String get segmentMinRequired => 'Se requiere al menos 1 segmento';

  @override
  String get repeatCountLabel => 'Repetir';

  @override
  String totalPerRound(String duration) {
    return 'Total por round: $duration';
  }

  @override
  String roundNLabel(int n) {
    return 'Round $n';
  }

  @override
  String get applyToAllRounds => 'Aplicar a todos los rounds';

  @override
  String templateSaved(String name) {
    return '\"$name\" guardada';
  }

  @override
  String get changeTemplate => 'Cambiar';

  @override
  String get historyScreenTitle => 'Historial de Entrenamiento';

  @override
  String get historyEmpty => 'Sin registros de entrenamiento';

  @override
  String get historyEmptySubtitle => 'Completa una sesión para verla aquí';

  @override
  String get historyToday => 'Hoy';

  @override
  String get historyYesterday => 'Ayer';

  @override
  String historyRecordRounds(int completed, int total) {
    return '$completed/$total rounds';
  }

  @override
  String get historyRecordCompleted => 'Completado';

  @override
  String get historyRecordStopped => 'Detenido';

  @override
  String get historyDeleteTitle => '¿Eliminar registro?';

  @override
  String get historyDeleteMessage =>
      '¿Eliminar este registro de entrenamiento?';

  @override
  String get historyClearAllTitle => '¿Borrar todo el historial?';

  @override
  String get historyClearAllMessage =>
      'Esto eliminará todos los registros. No se puede deshacer.';

  @override
  String get historyClearAll => 'Borrar Todo';

  @override
  String get historyRecordDeleted => 'Registro eliminado';

  @override
  String get historyAllCleared => 'Historial borrado';

  @override
  String get settingsTrainingHistory => 'Historial de Entrenamiento';

  @override
  String get sectionData => 'Datos';

  @override
  String get inProgressTitle => 'EN PROGRESO';

  @override
  String inProgressRoundFormat(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String get inProgressTimeLeft => 'restante';

  @override
  String get buttonResume => 'Continuar';

  @override
  String get buttonDiscard => 'Descartar';

  @override
  String get discardSessionTitle => '¿Descartar sesión?';

  @override
  String discardSessionMessage(String name) {
    return '¿Descartar la sesión en progreso \"$name\"? Se perderá tu progreso.';
  }

  @override
  String get sectionSubscription => 'Suscripción';

  @override
  String get removeAdsTitle => 'Eliminar Anuncios';

  @override
  String get removeAdsSubtitle =>
      'Compra única para eliminar todos los anuncios';

  @override
  String removeAdsPrice(String price) {
    return 'Eliminar Anuncios - $price';
  }

  @override
  String get adFreeStatus => 'Sin Anuncios';

  @override
  String get adFreeDescription => '¡Gracias por tu compra!';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get restorePurchasesDescription =>
      'Restaurar una compra anterior de eliminación de anuncios';

  @override
  String get purchaseRestored => 'Compra restaurada exitosamente';

  @override
  String get purchaseRestoredNone => 'No se encontraron compras anteriores';

  @override
  String get purchaseError => 'La compra falló. Inténtalo de nuevo.';

  @override
  String get purchasePending => 'Compra pendiente...';
}
