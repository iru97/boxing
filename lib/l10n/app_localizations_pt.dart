// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Boxing Timer';

  @override
  String get appBrandName => 'BOXING';

  @override
  String get appTagline => 'TREINA COMO LUTAS';

  @override
  String get sectionMySessionsTitle => 'Minhas Sessoes';

  @override
  String get sectionQuickStartTitle => 'Inicio Rapido';

  @override
  String get sectionPresetsTitle => 'Presets';

  @override
  String get categoryBoxing => 'Boxe';

  @override
  String get categoryBagWork => 'Saco';

  @override
  String get categoryConditioning => 'Condicionamento';

  @override
  String get categoryCombatSport => 'Esporte de Combate';

  @override
  String get categoryBeginner => 'Iniciante';

  @override
  String get categoryCompound => 'Composto';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDuplicate => 'Duplicar';

  @override
  String get actionDuplicateAsCustom => 'Duplicar como personalizada';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get buttonCancel => 'CANCELAR';

  @override
  String get buttonEnd => 'ENCERRAR';

  @override
  String get buttonStart => 'INICIAR';

  @override
  String get buttonSave => 'SALVAR';

  @override
  String get buttonRepeat => 'REPETIR';

  @override
  String get buttonDone => 'PRONTO';

  @override
  String get buttonSaveExit => 'SALVAR E SAIR';

  @override
  String get deleteSessionTitle => 'Excluir sessao?';

  @override
  String deleteSessionMessage(String name) {
    return 'Excluir \"$name\"? Isso nao pode ser desfeito.';
  }

  @override
  String snackbarSessionCreated(String name) {
    return '\"$name\" criada';
  }

  @override
  String snackbarSessionDeleted(String name) {
    return '\"$name\" excluida';
  }

  @override
  String snackbarSessionSaved(String name) {
    return '\"$name\" salva';
  }

  @override
  String get sessionNotFound => 'Sessao nao encontrada';

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
    return '$work trabalho · $rest descanso · $minutes min';
  }

  @override
  String sessionCardWorkOnly(String work, int minutes) {
    return '$work trabalho · $minutes min';
  }

  @override
  String get editSessionTitle => 'Editar Sessao';

  @override
  String get customizePresetTitle => 'Personalizar Preset';

  @override
  String get newSessionTitle => 'Nova Sessao';

  @override
  String get labelSessionName => 'Nome da Sessao';

  @override
  String get hintSessionName => 'ex. Trabalho de Saco';

  @override
  String get validationNameRequired => 'O nome e obrigatorio';

  @override
  String get labelRounds => 'Rounds';

  @override
  String get labelRoundDuration => 'Duracao do Round';

  @override
  String get labelRestDuration => 'Duracao do Descanso';

  @override
  String get labelRoundStructure => 'Estrutura do Round';

  @override
  String get labelWarningTime => 'Tempo de Aviso';

  @override
  String get labelWarmup => 'Aquecimento';

  @override
  String get valueOff => 'Nao';

  @override
  String valueSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get roundStructureSimple => 'Simples';

  @override
  String get labelAutoAdvance => 'Avanco automatico';

  @override
  String get descriptionAutoAdvance => 'Iniciar proximo round apos descanso';

  @override
  String get labelKeepScreenOn => 'Manter Tela Ligada';

  @override
  String get descriptionKeepScreenOn =>
      'Evitar que a tela apague durante o treino';

  @override
  String get sessionSummaryTitle => 'Resumo da Sessao';

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
  String get timerEndWorkoutTitle => 'Encerrar Treino?';

  @override
  String timerEndWorkoutMessage(int current, int total) {
    return 'Voce esta no round $current de $total.';
  }

  @override
  String get timerStopConfirmation => 'Tem certeza que quer parar?';

  @override
  String get labelWarning => 'Aviso';

  @override
  String warningBeforeEnd(int seconds) {
    return '${seconds}s antes do fim';
  }

  @override
  String get labelTotalTime => 'Tempo Total';

  @override
  String get labelSegmentsPerRound => 'Segmentos por Round';

  @override
  String totalElapsedFormat(String duration) {
    return 'Total: $duration';
  }

  @override
  String get phaseLabelReady => 'PRONTO';

  @override
  String get phaseLabelWarmup => 'AQUECIMENTO';

  @override
  String get phaseLabelWork => 'TRABALHO';

  @override
  String get phaseLabelRest => 'DESCANSO';

  @override
  String get phaseLabelPaused => 'PAUSADO';

  @override
  String get phaseLabelComplete => 'COMPLETO';

  @override
  String get sessionCompleteTitle => 'SESSAO COMPLETA';

  @override
  String sessionCompleteRounds(int rounds) {
    return '$rounds rounds completados';
  }

  @override
  String sessionCompleteTotalTime(String duration) {
    return 'Tempo total: $duration';
  }

  @override
  String roundIndicatorFormat(int current, int total) {
    return 'ROUND $current / $total';
  }

  @override
  String get a11yPreviousRound => 'Round anterior';

  @override
  String get a11yResume => 'Retomar';

  @override
  String get a11yPause => 'Pausar';

  @override
  String get a11yNextRound => 'Proximo round';

  @override
  String a11yCountdownRemaining(int minutes, int seconds) {
    return '$minutes minutos $seconds segundos restantes';
  }

  @override
  String get settingsScreenTitle => 'Configuracoes';

  @override
  String get sectionTimerDefaults => 'Padroes do Timer';

  @override
  String get labelDefaultWarmup => 'Aquecimento Padrao';

  @override
  String get labelDefaultWarning => 'Aviso Padrao';

  @override
  String get descriptionAutoAdvanceSettings =>
      'Iniciar proximo round apos descanso';

  @override
  String get descriptionKeepScreenOnSettings =>
      'Evitar suspensao da tela durante treino';

  @override
  String get labelResumeCountdown => 'Contagem ao Retomar';

  @override
  String get descriptionResumeCountdown => 'Mostrar 3-2-1 ao retomar';

  @override
  String get sectionAudio => 'Audio';

  @override
  String get labelDefaultSoundPack => 'Sons Padrao';

  @override
  String get labelVolumeOverride => 'Forcar Volume';

  @override
  String get descriptionVolumeOverride =>
      'Usar canal de alarme para alertas mais altos';

  @override
  String get labelHapticFeedback => 'Vibracao';

  @override
  String get descriptionHapticFeedback => 'Vibrar no inicio/fim de round';

  @override
  String get sectionDisplay => 'Tela';

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
      'Tocar em qualquer lugar no timer para pausar/retomar';

  @override
  String get sectionAbout => 'Sobre';

  @override
  String get labelVersion => 'Versao';

  @override
  String get labelLicenses => 'Licencas';

  @override
  String get soundPackClassicBell => 'Sino Classico';

  @override
  String get soundPackDigitalBuzzer => 'Buzina Digital';

  @override
  String get soundPackMinimalBeep => 'Beep Minimo';

  @override
  String get soundPackPickerTitle => 'Sons';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themePickerTitle => 'Tema';

  @override
  String get presetProBoxingMen => 'Boxe Pro (Homens)';

  @override
  String get presetProBoxingWomen => 'Boxe Pro (Mulheres)';

  @override
  String get presetAmateurBoxing => 'Boxe Amador';

  @override
  String get presetAmateurWomen => 'Amador Mulheres';

  @override
  String get presetShadowBoxing => 'Sombra';

  @override
  String get presetHeavyBag => 'Saco Pesado';

  @override
  String get presetSpeedBag => 'Pera de Velocidade';

  @override
  String get presetSparring => 'Sparring';

  @override
  String get presetPadWork => 'Manoplas';

  @override
  String get presetConditioning => 'Condicionamento';

  @override
  String get presetTabata => 'Tabata';

  @override
  String get presetEmom => 'EMOM';

  @override
  String get presetBeginner => 'Iniciante';

  @override
  String get presetYouthBoxing => 'Boxe Juvenil';

  @override
  String get presetMuayThai => 'Muay Thai';

  @override
  String get presetMma => 'MMA';

  @override
  String get presetKickboxing => 'Kickboxing';

  @override
  String get presetOffenseDefense => 'Ataque / Defesa';

  @override
  String get presetBagConditioning => 'Saco + Funcional';

  @override
  String get presetBurnoutRounds => 'Rounds de Queima';

  @override
  String get templateOffenseDefense => 'Ataque / Defesa';

  @override
  String get segmentOffense => 'Ataque';

  @override
  String get segmentDefense => 'Defesa';

  @override
  String get templateBagConditioning => 'Saco + Funcional';

  @override
  String get segmentBagWork => 'Saco';

  @override
  String get segmentConditioning => 'Condicionamento';

  @override
  String get templateBurnoutFinisher => 'Queima Final';

  @override
  String get segmentNormal => 'Normal';

  @override
  String get segmentHard => 'Forte';

  @override
  String get segmentAllOut => 'Tudo';

  @override
  String get templatePyramid => 'Piramide';

  @override
  String get segmentBuild => 'Subir';

  @override
  String get segmentPeak => 'Pico';

  @override
  String get segmentTaper => 'Descer';

  @override
  String get templateStationRotation => 'Rotacao de Estacoes';

  @override
  String get segmentJumpRope => 'Pular Corda';

  @override
  String get segmentShadowBox => 'Sombra';

  @override
  String get templateModeAll => 'Igual para todos os rounds';

  @override
  String get templateModePerRound => 'Personalizar por round';

  @override
  String get templateCreateCustom => 'Personalizada';

  @override
  String get templateEditCopy => 'Editar Copia';

  @override
  String get templateSimple => 'Simples';

  @override
  String get segmentEditorTitle => 'Estrutura do Round';

  @override
  String get segmentEditorNameLabel => 'Nome da Estrutura';

  @override
  String get segmentEditorNameHint => 'ex. Combo de Saco';

  @override
  String get segmentEditorNameRequired => 'O nome e obrigatorio';

  @override
  String get segmentAdd => 'Adicionar Segmento';

  @override
  String get segmentLabelField => 'Atividade';

  @override
  String get segmentDurationField => 'Duracao';

  @override
  String segmentMaxReached(int max) {
    return 'Maximo de $max segmentos';
  }

  @override
  String get segmentMinRequired => 'E necessario pelo menos 1 segmento';

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
  String get applyToAllRounds => 'Aplicar a todos os rounds';

  @override
  String templateSaved(String name) {
    return '\"$name\" salva';
  }

  @override
  String get changeTemplate => 'Alterar';

  @override
  String get historyScreenTitle => 'Histórico de Treino';

  @override
  String get historyEmpty => 'Sem registros de treino';

  @override
  String get historyEmptySubtitle => 'Complete uma sessão para vê-la aqui';

  @override
  String get historyToday => 'Hoje';

  @override
  String get historyYesterday => 'Ontem';

  @override
  String historyRecordRounds(int completed, int total) {
    return '$completed/$total rounds';
  }

  @override
  String get historyRecordCompleted => 'Concluído';

  @override
  String get historyRecordStopped => 'Interrompido';

  @override
  String get historyDeleteTitle => 'Excluir registro?';

  @override
  String get historyDeleteMessage => 'Remover este registro de treino?';

  @override
  String get historyClearAllTitle => 'Limpar todo o histórico?';

  @override
  String get historyClearAllMessage =>
      'Isso removerá todos os registros. Não pode ser desfeito.';

  @override
  String get historyClearAll => 'Limpar Tudo';

  @override
  String get historyRecordDeleted => 'Registro excluído';

  @override
  String get historyAllCleared => 'Histórico limpo';

  @override
  String get settingsTrainingHistory => 'Histórico de Treino';

  @override
  String get sectionData => 'Dados';

  @override
  String get inProgressTitle => 'EM ANDAMENTO';

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
  String get discardSessionTitle => 'Descartar sessão?';

  @override
  String discardSessionMessage(String name) {
    return 'Descartar a sessão em andamento \"$name\"? Seu progresso será perdido.';
  }

  @override
  String get sectionSubscription => 'Assinatura';

  @override
  String get removeAdsTitle => 'Remover Anúncios';

  @override
  String get removeAdsSubtitle => 'Compra única para remover todos os anúncios';

  @override
  String removeAdsPrice(String price) {
    return 'Remover Anúncios - $price';
  }

  @override
  String get adFreeStatus => 'Sem Anúncios';

  @override
  String get adFreeDescription => 'Obrigado pela sua compra!';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get restorePurchasesDescription =>
      'Restaurar uma compra anterior de remoção de anúncios';

  @override
  String get purchaseRestored => 'Compra restaurada com sucesso';

  @override
  String get purchaseRestoredNone => 'Nenhuma compra anterior encontrada';

  @override
  String get purchaseError => 'A compra falhou. Tente novamente.';

  @override
  String get purchasePending => 'Compra pendente...';

  @override
  String get sportFilterAll => 'All';

  @override
  String get sportBoxing => 'Boxing';

  @override
  String get sportMuayThai => 'Muay Thai';

  @override
  String get sportMma => 'MMA';

  @override
  String get sportBjj => 'BJJ';

  @override
  String get sportKickboxing => 'Kickboxing';

  @override
  String get sportWrestling => 'Wrestling';

  @override
  String get subcategoryCompetition => 'Competition';

  @override
  String get subcategoryTraining => 'Training';

  @override
  String get subcategoryDrills => 'Drills';

  @override
  String get subcategoryConditioning => 'Conditioning';
}
