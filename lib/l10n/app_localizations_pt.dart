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
  String get sectionMySessionsTitle => 'Minhas Sessões';

  @override
  String get sectionQuickStartTitle => 'Início Rápido';

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
  String get deleteSessionTitle => 'Excluir sessão?';

  @override
  String deleteSessionMessage(String name) {
    return 'Excluir \"$name\"? Isso não pode ser desfeito.';
  }

  @override
  String snackbarSessionCreated(String name) {
    return '\"$name\" criada';
  }

  @override
  String snackbarSessionDeleted(String name) {
    return '\"$name\" excluída';
  }

  @override
  String snackbarSessionSaved(String name) {
    return '\"$name\" salva';
  }

  @override
  String get sessionNotFound => 'Sessão não encontrada';

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
  String get editSessionTitle => 'Editar Sessão';

  @override
  String get customizePresetTitle => 'Personalizar Preset';

  @override
  String get newSessionTitle => 'Nova Sessão';

  @override
  String get labelSessionName => 'Nome da Sessão';

  @override
  String get hintSessionName => 'ex. Trabalho de Saco';

  @override
  String get validationNameRequired => 'O nome é obrigatório';

  @override
  String get labelRounds => 'Rounds';

  @override
  String get labelRoundDuration => 'Duração do Round';

  @override
  String get labelRestDuration => 'Duração do Descanso';

  @override
  String get labelRoundStructure => 'Estrutura do Round';

  @override
  String get labelWarningTime => 'Tempo de Aviso';

  @override
  String get labelWarmup => 'Aquecimento';

  @override
  String get valueOff => 'Não';

  @override
  String valueSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get roundStructureSimple => 'Simples';

  @override
  String get labelAutoAdvance => 'Avanço automático';

  @override
  String get descriptionAutoAdvance => 'Iniciar próximo round após descanso';

  @override
  String get labelKeepScreenOn => 'Manter Tela Ligada';

  @override
  String get descriptionKeepScreenOn =>
      'Evitar que a tela apague durante o treino';

  @override
  String get labelVoiceAnnounce => 'Anúncios por voz';

  @override
  String get descriptionVoiceAnnounce => 'Anunciar números de round por voz';

  @override
  String get sessionSummaryTitle => 'Resumo da Sessão';

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
    return 'Você está no round $current de $total.';
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
  String get sessionCompleteTitle => 'SESSÃO COMPLETA';

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
  String get a11yNextRound => 'Próximo round';

  @override
  String a11yCountdownRemaining(int minutes, int seconds) {
    return '$minutes minutos $seconds segundos restantes';
  }

  @override
  String get settingsScreenTitle => 'Configurações';

  @override
  String get sectionTimerDefaults => 'Padrões do Timer';

  @override
  String get labelDefaultWarmup => 'Aquecimento Padrão';

  @override
  String get labelDefaultWarning => 'Aviso Padrão';

  @override
  String get descriptionAutoAdvanceSettings =>
      'Iniciar próximo round após descanso';

  @override
  String get descriptionKeepScreenOnSettings =>
      'Evitar suspensão da tela durante treino';

  @override
  String get labelResumeCountdown => 'Contagem ao Retomar';

  @override
  String get descriptionResumeCountdown => 'Mostrar 3-2-1 ao retomar';

  @override
  String get sectionAudio => 'Áudio';

  @override
  String get labelDefaultSoundPack => 'Sons Padrão';

  @override
  String get labelVolumeOverride => 'Forçar Volume';

  @override
  String get descriptionVolumeOverride =>
      'Usar canal de alarme para alertas mais altos';

  @override
  String get labelHapticFeedback => 'Vibração';

  @override
  String get descriptionHapticFeedback => 'Vibrar no início/fim de round';

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
  String get labelVersion => 'Versão';

  @override
  String get labelLicenses => 'Licenças';

  @override
  String get soundPackClassicBell => 'Sino Clássico';

  @override
  String get soundPackDigitalBuzzer => 'Buzina Digital';

  @override
  String get soundPackMinimalBeep => 'Beep Mínimo';

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
  String get templatePyramid => 'Pirâmide';

  @override
  String get segmentBuild => 'Subir';

  @override
  String get segmentPeak => 'Pico';

  @override
  String get segmentTaper => 'Descer';

  @override
  String get templateStationRotation => 'Rotação de Estações';

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
  String get templateEditCopy => 'Editar Cópia';

  @override
  String get templateSimple => 'Simples';

  @override
  String get segmentEditorTitle => 'Estrutura do Round';

  @override
  String get segmentEditorNameLabel => 'Nome da Estrutura';

  @override
  String get segmentEditorNameHint => 'ex. Combo de Saco';

  @override
  String get segmentEditorNameRequired => 'O nome é obrigatório';

  @override
  String get segmentAdd => 'Adicionar Segmento';

  @override
  String get segmentLabelField => 'Atividade';

  @override
  String get segmentDurationField => 'Duração';

  @override
  String segmentMaxReached(int max) {
    return 'Máximo de $max segmentos';
  }

  @override
  String get segmentMinRequired => 'É necessário pelo menos 1 segmento';

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
      'Restaurar compras anteriores neste dispositivo';

  @override
  String get comboPackUnlocked => 'Desbloqueado';

  @override
  String get paywallPurchaseSuccess => 'Tudo pronto! Combos desbloqueados.';

  @override
  String get purchaseRestored => 'Compra restaurada com sucesso';

  @override
  String get purchaseRestoredNone => 'Nenhuma compra anterior encontrada';

  @override
  String get purchaseError => 'A compra falhou. Tente novamente.';

  @override
  String get purchasePending => 'Compra pendente...';

  @override
  String get sportFilterAll => 'Todos';

  @override
  String get sportBoxing => 'Boxe';

  @override
  String get sportMuayThai => 'Muay Thai';

  @override
  String get sportMma => 'MMA';

  @override
  String get sportBjj => 'BJJ';

  @override
  String get sportKickboxing => 'Kickboxing';

  @override
  String get sportWrestling => 'Luta';

  @override
  String get subcategoryCompetition => 'Competição';

  @override
  String get subcategoryTraining => 'Treinamento';

  @override
  String get subcategoryDrills => 'Exercícios';

  @override
  String get subcategoryConditioning => 'Condicionamento';

  @override
  String get comboSectionTitle => 'Combos por Voz';

  @override
  String get comboEnable => 'Ativar combos por voz';

  @override
  String get comboEnableDescription =>
      'O treinador chama combinações de golpes durante as fases de trabalho';

  @override
  String get comboSport => 'Esporte';

  @override
  String get comboSportBoxing => 'Boxe';

  @override
  String get comboSportMuayThai => 'Muay Thai';

  @override
  String get comboSportMMA => 'MMA';

  @override
  String get comboSportKickboxing => 'Kickboxing';

  @override
  String get comboDifficulty => 'Dificuldade';

  @override
  String get comboDifficultyBeginner => 'Iniciante';

  @override
  String get comboDifficultyIntermediate => 'Intermediário';

  @override
  String get comboDifficultyAdvanced => 'Avançado';

  @override
  String get comboIntensity => 'Intensidade';

  @override
  String get comboIntensityRelaxed => 'Relaxado';

  @override
  String get comboIntensityModerate => 'Moderado';

  @override
  String get comboIntensityIntense => 'Intenso';

  @override
  String get comboIntensityHurricane => 'Furacão';

  @override
  String get comboIntensityDescription =>
      'Com que frequência os combos são chamados';

  @override
  String get comboCalloutStyle => 'Estilo de Chamada';

  @override
  String get comboCalloutStyleDescription =>
      'Como os combos são falados em voz alta';

  @override
  String get comboCalloutNumbers => 'Números';

  @override
  String get comboCalloutNames => 'Nomes';

  @override
  String get comboCalloutNumbersHint =>
      'Rápido — \"1 2 3\" (como treinadores chamam combos)';

  @override
  String get comboCalloutNamesHint => 'Iniciante — \"Jab, Cruz, Gancho\"';

  @override
  String get comboIncludeDefense => 'Incluir defesa';

  @override
  String get comboDefenseDescription => 'Esquivar, rolar, bloquear';

  @override
  String get comboIncludeFootwork => 'Incluir movimentação';

  @override
  String get comboFootworkDescription => 'Pivotar, ângulo, cortar o ringue';

  @override
  String get comboCoachEncouragement => 'Incentivo do treinador';

  @override
  String get comboEncouragementDescription =>
      'Frases motivacionais entre combos';

  @override
  String comboPoolSize(int count) {
    return '$count combos disponíveis';
  }

  @override
  String comboPoolSizeUpsell(int count) {
    return 'desbloqueie $count+ com PRO';
  }

  @override
  String get comboPreviewTitle => 'Prévia dos Combos';

  @override
  String get comboSummaryLabel => 'Combos por Voz';

  @override
  String get comboPreviewButton => 'Prévia';

  @override
  String get comboPreviewPlaying => 'Reproduzindo...';

  @override
  String sessionCompleteCombos(int count) {
    return '$count combos';
  }

  @override
  String historyRecordCombos(int count) {
    return '$count combos';
  }

  @override
  String get progressionNudgeTitle => 'Subir de nível?';

  @override
  String progressionNudgeMessage(int count, String level, String next) {
    return 'Você completou $count sessões no nível $level. Pronto para $next?';
  }

  @override
  String progressionNudgeCta(String next) {
    return 'Tentar $next';
  }

  @override
  String get progressionNudgeDismiss => 'Ainda não';

  @override
  String get paywallComboTitle => 'Pacote de Combos';

  @override
  String get paywallComboSubtitle => 'Treine como se tivesse um treinador';

  @override
  String get paywallFreeItem1 => 'Combos para iniciantes (grátis para sempre)';

  @override
  String get paywallFreeItem2 => 'Números básicos de golpes de boxe';

  @override
  String get paywallPaidItem1 => '120+ combos intermediários e avançados';

  @override
  String get paywallPaidItem2 =>
      'Chamadas de técnicas de Muay Thai, MMA e kickboxing';

  @override
  String get paywallPaidItem3 => 'Sinais de defesa e movimentação';

  @override
  String get paywallPaidItem4 => 'Seleção inteligente de combos e progressão';

  @override
  String get paywallUnlockLabel => 'Desbloquear com o pacote';

  @override
  String get paywallUnlockButton => 'Desbloquear Agora';

  @override
  String get paywallRestorePurchases => 'Restaurar Compras';

  @override
  String get paywallRestoreChecking => 'Verificando compras anteriores...';

  @override
  String get paywallUpgradeNudge =>
      'Você treinou com combos iniciantes. Desbloqueie 120+ combos avançados.';

  @override
  String get programResetTitle => 'Redefinir progresso?';

  @override
  String programResetMessage(String name) {
    return 'Isso apagará todo o progresso de \"$name\". Você começará da Semana 1, Dia 1.';
  }

  @override
  String get programResetConfirm => 'Redefinir';

  @override
  String get programResetProgress => 'Redefinir Progresso';

  @override
  String get programComplete => 'Programa Concluído';

  @override
  String get programStart => 'Iniciar Programa';

  @override
  String programContinue(int week, int day) {
    return 'Continuar - Semana $week, Dia $day';
  }

  @override
  String programWeekLabel(int week, String name) {
    return 'Semana $week: $name';
  }

  @override
  String programDayLabel(int day, String name) {
    return 'Dia $day: $name';
  }

  @override
  String programWeekDayTitle(int week, int day) {
    return 'Semana $week, Dia $day';
  }

  @override
  String get programDayCompleted => 'Concluído';

  @override
  String get programDayRepeat => 'Repetir Treino';

  @override
  String get programDayStart => 'Iniciar Treino';

  @override
  String programDayTotalMin(int minutes) {
    return '~$minutes min total';
  }

  @override
  String get programWorkoutDetails => 'DETALHES DO TREINO';

  @override
  String get programDetailRounds => 'Rounds';

  @override
  String get programDetailWork => 'Trabalho';

  @override
  String get programDetailRest => 'Descanso';

  @override
  String get programComboCallouts => 'Combos por Voz';

  @override
  String get programComboDefense => 'Defesa';

  @override
  String get programComboFootwork => 'Movimentação';

  @override
  String get programNotFound => 'Programa não encontrado';

  @override
  String get programDayNotFound => 'Dia não encontrado';

  @override
  String get comboDifficultyBeginnerFree =>
      'Iniciante é grátis. Desbloqueie 120+ combos intermediários e avançados.';

  @override
  String get storeUnavailable => 'Loja indisponível';

  @override
  String get storeRetry => 'Loja indisponível — toque para tentar novamente';

  @override
  String get paywallSemanticFree => 'Incluído gratuitamente';

  @override
  String get paywallSemanticPaid => 'Incluído com o pacote';

  @override
  String get paywallSemanticLoading => 'Carregando';

  @override
  String get paywallSemanticStoreUnavailable =>
      'Loja indisponível. Toque para tentar novamente.';
}
