import 'dart:math' as math;

/// Categories of motivational coach interjections.
enum InterjectionCategory { encouragement, intensity, technique, roundContext }

/// 102 motivational coaching phrases (34 per locale) across 4 categories.
///
/// Storage is a static const map — this is training content like technique
/// TTS text, not user-facing UI strings, so it lives here rather than in ARB.
class InterjectionLibrary {
  InterjectionLibrary._();

  static const _phrases = <String, Map<InterjectionCategory, List<String>>>{
    'en': {
      InterjectionCategory.encouragement: [
        'Good!',
        'Nice!',
        "That's it!",
        "Let's go!",
        'Beautiful!',
        'Keep it up!',
        'There you go!',
        'Yes!',
        'Sharp!',
        'Clean!',
      ],
      InterjectionCategory.intensity: [
        'Work!',
        'Harder!',
        'Faster!',
        "Don't stop!",
        'Push it!',
        'Stay busy!',
        'More power!',
        'Go!',
        'Keep moving!',
        'Non-stop!',
      ],
      InterjectionCategory.technique: [
        'Hands up!',
        'Stay tight!',
        'Move your head!',
        'Breathe!',
        'Snap it!',
        'Work the body!',
        'Stay loose!',
        'Reset!',
        'Chin down!',
        'Stay on your toes!',
      ],
      InterjectionCategory.roundContext: [
        'Last thirty!',
        'Finish strong!',
        'Dig in!',
        'One more!',
      ],
    },
    'es': {
      InterjectionCategory.encouragement: [
        'Bien!',
        'Eso es!',
        'Vamos!',
        'Asi se hace!',
        'Perfecto!',
        'Sigue asi!',
        'Ahi esta!',
        'Si!',
        'Preciso!',
        'Limpio!',
      ],
      InterjectionCategory.intensity: [
        'Trabaja!',
        'Mas fuerte!',
        'Mas rapido!',
        'No pares!',
        'Empuja!',
        'Mantente activo!',
        'Mas potencia!',
        'Venga!',
        'Sigue moviendote!',
        'Sin parar!',
      ],
      InterjectionCategory.technique: [
        'Manos arriba!',
        'Mantente cerrado!',
        'Mueve la cabeza!',
        'Respira!',
        'Chasquealo!',
        'Trabaja el cuerpo!',
        'Relajate!',
        'Posicion!',
        'Barbilla abajo!',
        'Punta de los pies!',
      ],
      InterjectionCategory.roundContext: [
        'Ultimos treinta!',
        'Termina fuerte!',
        'Aguanta!',
        'Un ultimo esfuerzo!',
      ],
    },
    'pt': {
      InterjectionCategory.encouragement: [
        'Bom!',
        'Isso!',
        'Vamos!',
        'Muito bem!',
        'Perfeito!',
        'Continue!',
        'E isso ai!',
        'Sim!',
        'Preciso!',
        'Limpo!',
      ],
      InterjectionCategory.intensity: [
        'Trabalha!',
        'Mais forte!',
        'Mais rapido!',
        'Nao para!',
        'Empurra!',
        'Fica ativo!',
        'Mais potencia!',
        'Vai!',
        'Continua se movendo!',
        'Sem parar!',
      ],
      InterjectionCategory.technique: [
        'Maos para cima!',
        'Fica fechado!',
        'Mexe a cabeca!',
        'Respira!',
        'Estalido!',
        'Trabalha o corpo!',
        'Relaxa!',
        'Posicao!',
        'Queixo abaixo!',
        'Na ponta dos pes!',
      ],
      InterjectionCategory.roundContext: [
        'Ultimos trinta!',
        'Termina forte!',
        'Aguenta!',
        'Mais um!',
      ],
    },
  };

  /// Pick a random phrase for the given locale and category.
  /// Falls back to English if locale not found.
  static String pick(
    String locale,
    InterjectionCategory category,
    math.Random rng,
  ) {
    final localeData = _phrases[locale] ?? _phrases['en']!;
    final list = localeData[category]!;
    return list[rng.nextInt(list.length)];
  }
}
