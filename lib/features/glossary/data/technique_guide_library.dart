import 'package:boxing/features/glossary/domain/technique_guide.dart';

/// Static library of educational content for every technique.
///
/// 47 technique guides total with localized descriptions (en/es/pt),
/// form points, and related technique cross-references.
class TechniqueGuideLibrary {
  TechniqueGuideLibrary._();

  /// Lookup a guide by technique ID. Returns null if not found.
  static TechniqueGuide? byId(String id) => all[id];

  /// All technique guides indexed by technique ID.
  static const Map<String, TechniqueGuide> all = {
    // =================================================================
    // PUNCHES (14)
    // =================================================================
    '1': TechniqueGuide(
      techniqueId: '1',
      description: {
        'en': 'The jab is the most important punch in boxing. A quick, straight punch thrown with the lead hand from the guard position. It sets up combinations, measures distance, and disrupts your opponent\'s rhythm.',
        'es': 'El jab es el golpe mas importante del boxeo. Un golpe recto y rapido lanzado con la mano delantera desde la guardia. Prepara combinaciones, mide la distancia y rompe el ritmo del oponente.',
        'pt': 'O jab e o golpe mais importante do boxe. Um soco reto e rapido desferido com a mao da frente a partir da guarda. Prepara combinacoes, mede a distancia e quebra o ritmo do oponente.',
      },
      formPoints: {
        'en': [
          'Extend the lead hand straight from the chin',
          'Rotate the fist so the palm faces down at full extension',
          'Keep the rear hand up to protect the chin',
          'Step forward slightly with the lead foot for range',
          'Snap the hand back to guard immediately after contact',
        ],
        'es': [
          'Extiende la mano delantera recto desde la barbilla',
          'Rota el puno para que la palma mire hacia abajo al extender',
          'Manten la mano trasera arriba para proteger la barbilla',
          'Da un paso corto adelante con el pie delantero para alcance',
          'Regresa la mano a la guardia inmediatamente despues del contacto',
        ],
        'pt': [
          'Estenda a mao da frente reto a partir do queixo',
          'Gire o punho para que a palma fique para baixo na extensao total',
          'Mantenha a mao de tras levantada para proteger o queixo',
          'De um passo curto a frente com o pe da frente para alcance',
          'Retorne a mao para a guarda imediatamente apos o contato',
        ],
      },
      relatedTechniqueIds: ['2', '1b', '3'],
    ),

    '2': TechniqueGuide(
      techniqueId: '2',
      description: {
        'en': 'The cross is a powerful straight punch thrown with the rear hand. It generates power by rotating the hips and shoulders. The most common follow-up to the jab.',
        'es': 'El cross es un golpe recto potente lanzado con la mano trasera. Genera potencia rotando las caderas y los hombros. El seguimiento mas comun del jab.',
        'pt': 'O cross e um soco reto poderoso desferido com a mao de tras. Gera potencia girando os quadris e ombros. A continuacao mais comum do jab.',
      },
      formPoints: {
        'en': [
          'Rotate the rear hip and shoulder forward as you punch',
          'Drive off the ball of the rear foot',
          'Keep the chin tucked behind the lead shoulder',
          'Extend fully through the target',
          'Return to guard position along the same path',
        ],
        'es': [
          'Rota la cadera y el hombro trasero hacia adelante al golpear',
          'Impulsa desde la planta del pie trasero',
          'Manten la barbilla detras del hombro delantero',
          'Extiende completamente a traves del objetivo',
          'Regresa a la guardia por el mismo camino',
        ],
        'pt': [
          'Gire o quadril e ombro de tras para frente ao socar',
          'Impulsione a partir da planta do pe de tras',
          'Mantenha o queixo atras do ombro da frente',
          'Estenda completamente atraves do alvo',
          'Retorne a guarda pelo mesmo caminho',
        ],
      },
      relatedTechniqueIds: ['1', '2b', '3'],
    ),

    '3': TechniqueGuide(
      techniqueId: '3',
      description: {
        'en': 'The lead hook is a short-range power punch thrown in a circular motion with the lead hand. Devastating at close range, it targets the jaw and temple from an angle the opponent often cannot see.',
        'es': 'El gancho delantero es un golpe de potencia de corto alcance lanzado en un movimiento circular con la mano delantera. Devastador en corta distancia, apunta a la mandibula y sien desde un angulo que el oponente a menudo no puede ver.',
        'pt': 'O gancho da frente e um soco de potencia de curto alcance desferido em movimento circular com a mao da frente. Devastador em curta distancia, mira a mandibula e tempera de um angulo que o oponente geralmente nao consegue ver.',
      },
      formPoints: {
        'en': [
          'Keep the elbow bent at roughly 90 degrees',
          'Rotate the hips and pivot the lead foot',
          'Punch across, not up — keep the fist at chin level',
          'Keep the rear hand glued to the chin for protection',
          'Engage the core to transfer power through rotation',
        ],
        'es': [
          'Manten el codo doblado aproximadamente a 90 grados',
          'Rota las caderas y pivotea el pie delantero',
          'Golpea horizontal, no hacia arriba — manten el puno a nivel de la barbilla',
          'Manten la mano trasera pegada a la barbilla para proteccion',
          'Activa el core para transferir potencia a traves de la rotacion',
        ],
        'pt': [
          'Mantenha o cotovelo dobrado em aproximadamente 90 graus',
          'Gire os quadris e gire o pe da frente',
          'Soque para o lado, nao para cima — mantenha o punho na altura do queixo',
          'Mantenha a mao de tras colada no queixo para protecao',
          'Ative o core para transferir potencia atraves da rotacao',
        ],
      },
      relatedTechniqueIds: ['4', '3b', '1', '2'],
    ),

    '4': TechniqueGuide(
      techniqueId: '4',
      description: {
        'en': 'The rear hook is a powerful hook thrown with the rear hand. Less common than the lead hook but very effective as a counter or in close-range exchanges.',
        'es': 'El gancho trasero es un gancho potente lanzado con la mano trasera. Menos comun que el gancho delantero pero muy efectivo como contragolpe o en intercambios de corta distancia.',
        'pt': 'O gancho traseiro e um gancho poderoso desferido com a mao de tras. Menos comum que o gancho da frente mas muito eficaz como contragolpe ou em trocacoes de curta distancia.',
      },
      formPoints: {
        'en': [
          'Rotate hips and shoulders to generate power',
          'Keep the elbow at 90 degrees like the lead hook',
          'Transfer weight from rear foot to lead foot',
          'Protect the chin with the lead hand',
          'Follow through the target and return to guard',
        ],
        'es': [
          'Rota caderas y hombros para generar potencia',
          'Manten el codo a 90 grados como el gancho delantero',
          'Transfiere el peso del pie trasero al pie delantero',
          'Protege la barbilla con la mano delantera',
          'Sigue a traves del objetivo y regresa a la guardia',
        ],
        'pt': [
          'Gire quadris e ombros para gerar potencia',
          'Mantenha o cotovelo a 90 graus como o gancho da frente',
          'Transfira o peso do pe de tras para o pe da frente',
          'Proteja o queixo com a mao da frente',
          'Siga atraves do alvo e retorne a guarda',
        ],
      },
      relatedTechniqueIds: ['3', '4b', '2'],
    ),

    '5': TechniqueGuide(
      techniqueId: '5',
      description: {
        'en': 'The lead uppercut is a short, rising punch thrown with the lead hand. It travels upward from below the opponent\'s line of sight, targeting the chin or body at close range.',
        'es': 'El uppercut delantero es un golpe corto y ascendente lanzado con la mano delantera. Viaja hacia arriba desde debajo de la linea de vision del oponente, apuntando a la barbilla o el cuerpo en corta distancia.',
        'pt': 'O uppercut da frente e um soco curto e ascendente desferido com a mao da frente. Viaja para cima por baixo da linha de visao do oponente, mirando o queixo ou corpo em curta distancia.',
      },
      formPoints: {
        'en': [
          'Dip slightly at the knees to load the punch',
          'Drive upward with the legs and hips',
          'Keep the elbow tight and the palm facing you',
          'Aim to land under the chin or on the solar plexus',
          'Do not lean forward — rise vertically through the punch',
        ],
        'es': [
          'Flexiona ligeramente las rodillas para cargar el golpe',
          'Impulsa hacia arriba con las piernas y caderas',
          'Manten el codo pegado y la palma mirando hacia ti',
          'Apunta a impactar debajo de la barbilla o en el plexo solar',
          'No te inclines hacia adelante — sube verticalmente a traves del golpe',
        ],
        'pt': [
          'Flexione levemente os joelhos para carregar o soco',
          'Impulsione para cima com as pernas e quadris',
          'Mantenha o cotovelo junto e a palma virada para voce',
          'Mire para acertar embaixo do queixo ou no plexo solar',
          'Nao se incline para frente — suba verticalmente atraves do soco',
        ],
      },
      relatedTechniqueIds: ['6', '5b', '3'],
    ),

    '6': TechniqueGuide(
      techniqueId: '6',
      description: {
        'en': 'The rear uppercut is the power version of the uppercut, thrown with the rear hand. It generates significant force from the hip rotation and is devastating as a counter or inside fighting tool.',
        'es': 'El uppercut trasero es la version de potencia del uppercut, lanzado con la mano trasera. Genera fuerza significativa de la rotacion de caderas y es devastador como contragolpe o herramienta de pelea interna.',
        'pt': 'O uppercut traseiro e a versao de potencia do uppercut, desferido com a mao de tras. Gera forca significativa da rotacao do quadril e e devastador como contragolpe ou ferramenta de luta interna.',
      },
      formPoints: {
        'en': [
          'Drop the rear hand slightly as you dip the knees',
          'Rotate the rear hip forward and upward',
          'Drive through the legs for maximum power',
          'Keep the lead hand high for protection',
          'Snap back to guard — do not leave the hand out',
        ],
        'es': [
          'Baja la mano trasera ligeramente mientras flexionas las rodillas',
          'Rota la cadera trasera hacia adelante y arriba',
          'Impulsa a traves de las piernas para maxima potencia',
          'Manten la mano delantera alta para proteccion',
          'Regresa rapido a la guardia — no dejes la mano afuera',
        ],
        'pt': [
          'Abaixe a mao de tras levemente enquanto flexiona os joelhos',
          'Gire o quadril de tras para frente e para cima',
          'Impulsione atraves das pernas para potencia maxima',
          'Mantenha a mao da frente alta para protecao',
          'Retorne rapido a guarda — nao deixe a mao estendida',
        ],
      },
      relatedTechniqueIds: ['5', '6b', '4'],
    ),

    '1b': TechniqueGuide(
      techniqueId: '1b',
      description: {
        'en': 'The jab to the body targets the midsection instead of the head. It is thrown by dipping the knees slightly and angling the punch downward. Effective for setting up head punches.',
        'es': 'El jab al cuerpo apunta a la seccion media en lugar de la cabeza. Se lanza flexionando ligeramente las rodillas y angulando el golpe hacia abajo. Efectivo para preparar golpes a la cabeza.',
        'pt': 'O jab ao corpo mira a secao media em vez da cabeca. E desferido flexionando levemente os joelhos e angulando o soco para baixo. Eficaz para preparar socos a cabeca.',
      },
      formPoints: {
        'en': [
          'Bend at the knees, not at the waist',
          'Keep your eyes on the opponent, not the target',
          'Punch straight to the body — same mechanics as head jab',
          'Return to full guard height immediately',
        ],
        'es': [
          'Flexiona las rodillas, no la cintura',
          'Manten los ojos en el oponente, no en el objetivo',
          'Golpea recto al cuerpo — misma mecanica que el jab a la cabeza',
          'Regresa a la altura completa de guardia inmediatamente',
        ],
        'pt': [
          'Flexione os joelhos, nao a cintura',
          'Mantenha os olhos no oponente, nao no alvo',
          'Soque reto ao corpo — mesma mecanica do jab a cabeca',
          'Retorne a altura completa da guarda imediatamente',
        ],
      },
      relatedTechniqueIds: ['1', '2b'],
    ),

    '2b': TechniqueGuide(
      techniqueId: '2b',
      description: {
        'en': 'The cross to the body is a powerful straight punch aimed at the midsection with the rear hand. It can target the liver or the solar plexus.',
        'es': 'El cross al cuerpo es un golpe recto potente dirigido a la seccion media con la mano trasera. Puede apuntar al higado o al plexo solar.',
        'pt': 'O cross ao corpo e um soco reto poderoso direcionado a secao media com a mao de tras. Pode mirar o figado ou o plexo solar.',
      },
      formPoints: {
        'en': [
          'Dip the knees and level-change to bring the punch to body height',
          'Rotate the hips fully, just like a head-level cross',
          'Aim for the solar plexus or the floating ribs',
          'Keep the lead hand high to protect against counters',
        ],
        'es': [
          'Flexiona las rodillas y cambia de nivel para llevar el golpe a la altura del cuerpo',
          'Rota las caderas completamente, igual que un cross a la cabeza',
          'Apunta al plexo solar o las costillas flotantes',
          'Manten la mano delantera alta para protegerte de contragolpes',
        ],
        'pt': [
          'Flexione os joelhos e mude de nivel para trazer o soco a altura do corpo',
          'Gire os quadris completamente, assim como um cross a cabeca',
          'Mire o plexo solar ou as costelas flutuantes',
          'Mantenha a mao da frente alta para se proteger de contragolpes',
        ],
      },
      relatedTechniqueIds: ['2', '1b', '3b'],
    ),

    '3b': TechniqueGuide(
      techniqueId: '3b',
      description: {
        'en': 'The hook to the body with the lead hand targets the liver or the ribs. One of the most effective body shots in boxing.',
        'es': 'El gancho al cuerpo con la mano delantera apunta al higado o las costillas. Uno de los golpes al cuerpo mas efectivos del boxeo.',
        'pt': 'O gancho ao corpo com a mao da frente mira o figado ou as costelas. Um dos golpes ao corpo mais eficazes do boxe.',
      },
      formPoints: {
        'en': [
          'Drop your level by bending the knees',
          'Rotate through the hips — same arc as the head hook',
          'Turn the fist so the palm faces the floor',
          'Dig upward into the ribs on contact',
        ],
        'es': [
          'Baja tu nivel flexionando las rodillas',
          'Rota a traves de las caderas — mismo arco que el gancho a la cabeza',
          'Gira el puno para que la palma mire al suelo',
          'Cava hacia arriba en las costillas al contacto',
        ],
        'pt': [
          'Abaixe seu nivel flexionando os joelhos',
          'Gire atraves dos quadris — mesmo arco do gancho a cabeca',
          'Vire o punho para que a palma fique para o chao',
          'Cave para cima nas costelas no contato',
        ],
      },
      relatedTechniqueIds: ['3', '4b', '2b'],
    ),

    '4b': TechniqueGuide(
      techniqueId: '4b',
      description: {
        'en': 'The rear hook to the body is a devastating close-range punch targeting the liver or kidneys. It requires good positioning and timing.',
        'es': 'El gancho trasero al cuerpo es un golpe devastador de corta distancia que apunta al higado o los rinones. Requiere buen posicionamiento y timing.',
        'pt': 'O gancho traseiro ao corpo e um soco devastador de curta distancia que mira o figado ou os rins. Requer bom posicionamento e timing.',
      },
      formPoints: {
        'en': [
          'Close the distance before throwing',
          'Rotate the rear hip into the punch',
          'Aim for the soft area below the ribs',
          'Keep the lead hand protecting your chin',
        ],
        'es': [
          'Cierra la distancia antes de lanzar',
          'Rota la cadera trasera hacia el golpe',
          'Apunta al area blanda debajo de las costillas',
          'Manten la mano delantera protegiendo tu barbilla',
        ],
        'pt': [
          'Feche a distancia antes de desferir',
          'Gire o quadril de tras para o soco',
          'Mire a area macia abaixo das costelas',
          'Mantenha a mao da frente protegendo seu queixo',
        ],
      },
      relatedTechniqueIds: ['4', '3b'],
    ),

    '5b': TechniqueGuide(
      techniqueId: '5b',
      description: {
        'en': 'The lead uppercut to the body rises into the solar plexus or stomach from close range. Especially effective when the opponent lowers their guard.',
        'es': 'El uppercut delantero al cuerpo sube al plexo solar o estomago desde corta distancia. Especialmente efectivo cuando el oponente baja la guardia.',
        'pt': 'O uppercut da frente ao corpo sobe ao plexo solar ou estomago de curta distancia. Especialmente eficaz quando o oponente abaixa a guarda.',
      },
      formPoints: {
        'en': [
          'Stay low and drive upward from the legs',
          'Aim for the solar plexus or bottom of the sternum',
          'Keep the motion compact — no wind-up',
          'Return to guard quickly to avoid counters',
        ],
        'es': [
          'Quedate bajo e impulsa hacia arriba desde las piernas',
          'Apunta al plexo solar o la parte baja del esternon',
          'Manten el movimiento compacto — sin preparacion',
          'Regresa a la guardia rapido para evitar contragolpes',
        ],
        'pt': [
          'Fique baixo e impulsione para cima a partir das pernas',
          'Mire o plexo solar ou a parte inferior do esterno',
          'Mantenha o movimento compacto — sem preparacao',
          'Retorne a guarda rapidamente para evitar contragolpes',
        ],
      },
      relatedTechniqueIds: ['5', '6b'],
    ),

    '6b': TechniqueGuide(
      techniqueId: '6b',
      description: {
        'en': 'The rear uppercut to the body drives into the solar plexus or stomach with full hip rotation. The power body-shot version of the uppercut.',
        'es': 'El uppercut trasero al cuerpo se clava en el plexo solar o estomago con rotacion completa de caderas. La version de potencia del uppercut al cuerpo.',
        'pt': 'O uppercut traseiro ao corpo crava no plexo solar ou estomago com rotacao completa do quadril. A versao de potencia do uppercut ao corpo.',
      },
      formPoints: {
        'en': [
          'Load the punch by dipping the rear knee',
          'Drive upward with full hip rotation',
          'Target the soft area below the sternum',
          'Maintain balance — do not overcommit forward',
        ],
        'es': [
          'Carga el golpe flexionando la rodilla trasera',
          'Impulsa hacia arriba con rotacion completa de caderas',
          'Apunta al area blanda debajo del esternon',
          'Manten el equilibrio — no te comprometas demasiado hacia adelante',
        ],
        'pt': [
          'Carregue o soco flexionando o joelho de tras',
          'Impulsione para cima com rotacao completa do quadril',
          'Mire a area macia abaixo do esterno',
          'Mantenha o equilibrio — nao se comprometa demais para frente',
        ],
      },
      relatedTechniqueIds: ['6', '5b'],
    ),

    'superman': TechniqueGuide(
      techniqueId: 'superman',
      description: {
        'en': 'The superman punch is a leaping straight punch where the rear leg kicks back to generate forward momentum. It closes distance explosively and is common in MMA and kickboxing.',
        'es': 'El golpe superman es un golpe recto con salto donde la pierna trasera patea hacia atras para generar impulso hacia adelante. Cierra la distancia explosivamente y es comun en MMA y kickboxing.',
        'pt': 'O soco superman e um soco reto com salto onde a perna de tras chuta para tras para gerar impulso para frente. Fecha a distancia explosivamente e e comum no MMA e kickboxing.',
      },
      formPoints: {
        'en': [
          'Fake a rear knee or kick to disguise the entry',
          'Leap forward while throwing the rear hand',
          'Kick the rear leg back for momentum',
          'Land in a balanced stance ready to follow up',
        ],
        'es': [
          'Finta una rodilla trasera o patada para disfrazar la entrada',
          'Salta hacia adelante mientras lanzas la mano trasera',
          'Patea la pierna trasera hacia atras para impulso',
          'Aterriza en posicion equilibrada listo para continuar',
        ],
        'pt': [
          'Finte um joelho ou chute traseiro para disfarcar a entrada',
          'Pule para frente enquanto desfere a mao de tras',
          'Chute a perna de tras para gerar impulso',
          'Aterrisse em posicao equilibrada pronto para continuar',
        ],
      },
      relatedTechniqueIds: ['2', 'overhand'],
    ),

    'overhand': TechniqueGuide(
      techniqueId: 'overhand',
      description: {
        'en': 'The overhand is a looping power punch thrown over the opponent\'s guard. It arcs from outside the line of sight and lands on the temple or behind the ear. Common in MMA.',
        'es': 'El overhand es un golpe de potencia en arco lanzado por encima de la guardia del oponente. Hace un arco desde fuera de la linea de vision y aterriza en la sien o detras de la oreja. Comun en MMA.',
        'pt': 'O overhand e um soco de potencia em arco desferido por cima da guarda do oponente. Faz um arco de fora da linha de visao e acerta na tempera ou atras da orelha. Comum no MMA.',
      },
      formPoints: {
        'en': [
          'Step slightly off-line as you throw',
          'Arc the punch over the opponent\'s lead hand',
          'Rotate the hips fully for power',
          'Be ready to defend — the overhand leaves you open',
        ],
        'es': [
          'Da un paso ligeramente fuera de linea al lanzar',
          'Hace un arco con el golpe sobre la mano delantera del oponente',
          'Rota las caderas completamente para potencia',
          'Preparate para defender — el overhand te deja expuesto',
        ],
        'pt': [
          'De um passo levemente fora da linha ao desferir',
          'Faca um arco com o soco sobre a mao da frente do oponente',
          'Gire os quadris completamente para potencia',
          'Esteja pronto para defender — o overhand te deixa exposto',
        ],
      },
      relatedTechniqueIds: ['2', 'superman'],
    ),

    'ground_strike': TechniqueGuide(
      techniqueId: 'ground_strike',
      description: {
        'en': 'Ground strikes are punches thrown from a dominant top position on the ground. They are fundamental to MMA ground-and-pound strategy.',
        'es': 'Los golpes al suelo son golpes lanzados desde una posicion dominante arriba en el suelo. Son fundamentales para la estrategia de ground-and-pound en MMA.',
        'pt': 'Golpes no chao sao socos desferidos de uma posicao dominante por cima no chao. Sao fundamentais para a estrategia de ground-and-pound no MMA.',
      },
      formPoints: {
        'en': [
          'Maintain a strong base to avoid being swept',
          'Use short, powerful punches — no wide hooks',
          'Posture up to create space for power shots',
          'Mix strikes with submission attempts for effectiveness',
        ],
        'es': [
          'Manten una base fuerte para evitar ser barrido',
          'Usa golpes cortos y potentes — sin ganchos amplios',
          'Postura hacia arriba para crear espacio para golpes de potencia',
          'Mezcla golpes con intentos de sumision para efectividad',
        ],
        'pt': [
          'Mantenha uma base forte para evitar ser varrido',
          'Use socos curtos e poderosos — sem ganchos amplos',
          'Posture para cima para criar espaco para golpes de potencia',
          'Misture golpes com tentativas de finalizacao para eficacia',
        ],
      },
      relatedTechniqueIds: ['level_change', 'takedown'],
    ),

    // =================================================================
    // DEFENSE (11)
    // =================================================================
    'slip_l': TechniqueGuide(
      techniqueId: 'slip_l',
      description: {
        'en': 'Slipping left is a head movement defense where you move your head to the left to avoid a straight punch. It positions you for a counter with the rear hand.',
        'es': 'Esquivar a la izquierda es una defensa de movimiento de cabeza donde mueves la cabeza a la izquierda para evitar un golpe recto. Te posiciona para un contragolpe con la mano trasera.',
        'pt': 'Esquivar para a esquerda e uma defesa de movimento de cabeca onde voce move a cabeca para a esquerda para evitar um soco reto. Te posiciona para um contragolpe com a mao de tras.',
      },
      formPoints: {
        'en': [
          'Bend at the waist and knees, not just the neck',
          'Move your head just enough to avoid the punch',
          'Keep your eyes on the opponent at all times',
          'Stay balanced and ready to counter immediately',
        ],
        'es': [
          'Flexiona la cintura y rodillas, no solo el cuello',
          'Mueve la cabeza solo lo suficiente para evitar el golpe',
          'Manten los ojos en el oponente en todo momento',
          'Quedate equilibrado y listo para contragolpear inmediatamente',
        ],
        'pt': [
          'Flexione a cintura e joelhos, nao apenas o pescoco',
          'Mova a cabeca apenas o suficiente para evitar o soco',
          'Mantenha os olhos no oponente o tempo todo',
          'Fique equilibrado e pronto para contra-atacar imediatamente',
        ],
      },
      relatedTechniqueIds: ['slip_r', 'roll', 'duck'],
    ),

    'slip_r': TechniqueGuide(
      techniqueId: 'slip_r',
      description: {
        'en': 'Slipping right moves your head to the right to evade a cross or rear hand. It sets up counter opportunities with the lead hook or lead uppercut.',
        'es': 'Esquivar a la derecha mueve tu cabeza a la derecha para evadir un cross o mano trasera. Prepara oportunidades de contragolpe con el gancho delantero o uppercut delantero.',
        'pt': 'Esquivar para a direita move sua cabeca para a direita para evadir um cross ou mao de tras. Prepara oportunidades de contragolpe com o gancho da frente ou uppercut da frente.',
      },
      formPoints: {
        'en': [
          'Rotate the torso slightly to the right',
          'Dip below the incoming punch line',
          'Keep hands up and guard tight',
          'Return to center quickly after slipping',
        ],
        'es': [
          'Rota el torso ligeramente a la derecha',
          'Baja por debajo de la linea del golpe entrante',
          'Manten las manos arriba y la guardia cerrada',
          'Regresa al centro rapido despues de esquivar',
        ],
        'pt': [
          'Gire o torso levemente para a direita',
          'Abaixe por baixo da linha do soco entrante',
          'Mantenha as maos levantadas e a guarda fechada',
          'Retorne ao centro rapidamente apos esquivar',
        ],
      },
      relatedTechniqueIds: ['slip_l', 'roll', 'parry'],
    ),

    'roll': TechniqueGuide(
      techniqueId: 'roll',
      description: {
        'en': 'Rolling under is a defensive movement where you duck and roll your body beneath a hook. It puts you in position for devastating counters.',
        'es': 'Rolar por debajo es un movimiento defensivo donde te agachas y rolas el cuerpo debajo de un gancho. Te posiciona para contragolpes devastadores.',
        'pt': 'Rolar por baixo e um movimento defensivo onde voce se abaixa e rola o corpo por baixo de um gancho. Te posiciona para contragolpes devastadores.',
      },
      formPoints: {
        'en': [
          'Bend at the knees to duck under the hook',
          'Roll your torso in a U-shaped motion',
          'Come up on the opposite side ready to counter',
          'Keep your hands up throughout the entire motion',
        ],
        'es': [
          'Flexiona las rodillas para agacharte debajo del gancho',
          'Rola el torso en un movimiento en forma de U',
          'Sube por el lado opuesto listo para contragolpear',
          'Manten las manos arriba durante todo el movimiento',
        ],
        'pt': [
          'Flexione os joelhos para abaixar por baixo do gancho',
          'Role o torso em um movimento em forma de U',
          'Suba pelo lado oposto pronto para contra-atacar',
          'Mantenha as maos levantadas durante todo o movimento',
        ],
      },
      relatedTechniqueIds: ['slip_l', 'slip_r', 'duck'],
    ),

    'block': TechniqueGuide(
      techniqueId: 'block',
      description: {
        'en': 'Blocking absorbs an incoming punch with the gloves, arms, or shoulders. It is the simplest defensive technique and essential for beginners.',
        'es': 'Bloquear absorbe un golpe entrante con los guantes, brazos u hombros. Es la tecnica defensiva mas simple y esencial para principiantes.',
        'pt': 'Bloquear absorve um soco entrante com as luvas, bracos ou ombros. E a tecnica defensiva mais simples e essencial para iniciantes.',
      },
      formPoints: {
        'en': [
          'Keep both hands tight to the face and chin',
          'Absorb hooks with the forearm and elbow',
          'Tuck the chin behind the shoulder for straight punches',
          'Stay compact — do not reach out to block',
        ],
        'es': [
          'Manten ambas manos pegadas a la cara y barbilla',
          'Absorbe ganchos con el antebrazo y codo',
          'Esconde la barbilla detras del hombro para golpes rectos',
          'Quedate compacto — no estires para bloquear',
        ],
        'pt': [
          'Mantenha ambas as maos junto ao rosto e queixo',
          'Absorva ganchos com o antebraco e cotovelo',
          'Esconda o queixo atras do ombro para socos retos',
          'Fique compacto — nao estenda para bloquear',
        ],
      },
      relatedTechniqueIds: ['parry', 'cover', 'catch_t'],
    ),

    'parry': TechniqueGuide(
      techniqueId: 'parry',
      description: {
        'en': 'Parrying deflects an incoming straight punch with a small hand movement, redirecting it off-line. More energy-efficient than blocking and opens the opponent up.',
        'es': 'Desviar deflecta un golpe recto entrante con un pequeno movimiento de mano, redirigiendolo fuera de linea. Mas eficiente en energia que bloquear y abre al oponente.',
        'pt': 'Defletir desvia um soco reto entrante com um pequeno movimento de mao, redirecionando-o para fora da linha. Mais eficiente em energia que bloquear e abre o oponente.',
      },
      formPoints: {
        'en': [
          'Use the lead hand to tap the jab aside',
          'Use the rear hand to redirect the cross',
          'Keep the motion small — just enough to deflect',
          'Immediately counter after the parry',
        ],
        'es': [
          'Usa la mano delantera para desviar el jab',
          'Usa la mano trasera para redirigir el cross',
          'Manten el movimiento pequeno — solo lo suficiente para deflectar',
          'Contragolpea inmediatamente despues de desviar',
        ],
        'pt': [
          'Use a mao da frente para desviar o jab',
          'Use a mao de tras para redirecionar o cross',
          'Mantenha o movimento pequeno — apenas o suficiente para defletir',
          'Contra-ataque imediatamente apos defletir',
        ],
      },
      relatedTechniqueIds: ['block', 'slip_r', 'catch_t'],
    ),

    'pull': TechniqueGuide(
      techniqueId: 'pull',
      description: {
        'en': 'Pulling back leans your upper body backward just out of range of an incoming punch, then you snap forward with a counter.',
        'es': 'Retroceder inclina el cuerpo hacia atras justo fuera del alcance de un golpe entrante, luego avanzas rapido con un contragolpe.',
        'pt': 'Recuar inclina o corpo para tras justo fora do alcance de um soco entrante, depois voce avanca rapido com um contragolpe.',
      },
      formPoints: {
        'en': [
          'Shift weight to the rear foot',
          'Pull the head back just enough to avoid the punch',
          'Keep the hands up and eyes on the opponent',
          'Spring forward to counter as the punch misses',
        ],
        'es': [
          'Cambia el peso al pie trasero',
          'Retira la cabeza justo lo suficiente para evitar el golpe',
          'Manten las manos arriba y los ojos en el oponente',
          'Salta hacia adelante para contragolpear cuando el golpe falla',
        ],
        'pt': [
          'Transfira o peso para o pe de tras',
          'Puxe a cabeca para tras apenas o suficiente para evitar o soco',
          'Mantenha as maos levantadas e os olhos no oponente',
          'Salte para frente para contra-atacar quando o soco errar',
        ],
      },
      relatedTechniqueIds: ['step_back', 'slip_r', 'parry'],
    ),

    'catch_t': TechniqueGuide(
      techniqueId: 'catch_t',
      description: {
        'en': 'Catching receives and absorbs a kick with your arms or hands. Essential in Muay Thai and kickboxing for defending body and high kicks.',
        'es': 'Atrapar recibe y absorbe una patada con los brazos o manos. Esencial en Muay Thai y kickboxing para defender patadas al cuerpo y altas.',
        'pt': 'Pegar recebe e absorve um chute com os bracos ou maos. Essencial no Muay Thai e kickboxing para defender chutes ao corpo e altos.',
      },
      formPoints: {
        'en': [
          'Absorb the kick with the arm pressed against the body',
          'Trap the leg against your side if possible',
          'Counter immediately — the opponent is off-balance',
          'Do not reach out — let the kick come to you',
        ],
        'es': [
          'Absorbe la patada con el brazo presionado contra el cuerpo',
          'Atrapa la pierna contra tu costado si es posible',
          'Contragolpea inmediatamente — el oponente esta desequilibrado',
          'No estires — deja que la patada venga a ti',
        ],
        'pt': [
          'Absorva o chute com o braco pressionado contra o corpo',
          'Prenda a perna contra seu lado se possivel',
          'Contra-ataque imediatamente — o oponente esta desequilibrado',
          'Nao estenda — deixe o chute vir ate voce',
        ],
      },
      relatedTechniqueIds: ['check', 'block'],
    ),

    'duck': TechniqueGuide(
      techniqueId: 'duck',
      description: {
        'en': 'Ducking drops your level quickly by bending the knees to go under a hook or overhand. It keeps you in range to counter.',
        'es': 'Agacharse baja tu nivel rapidamente flexionando las rodillas para pasar debajo de un gancho u overhand. Te mantiene en rango para contragolpear.',
        'pt': 'Agachar abaixa seu nivel rapidamente flexionando os joelhos para passar por baixo de um gancho ou overhand. Te mantem em alcance para contra-atacar.',
      },
      formPoints: {
        'en': [
          'Bend at the knees, not the waist',
          'Keep your eyes on the opponent throughout',
          'Do not duck too low — you lose vision',
          'Come back up quickly and counter',
        ],
        'es': [
          'Flexiona las rodillas, no la cintura',
          'Manten los ojos en el oponente todo el tiempo',
          'No te agaches demasiado — pierdes vision',
          'Levantate rapido y contragolpea',
        ],
        'pt': [
          'Flexione os joelhos, nao a cintura',
          'Mantenha os olhos no oponente o tempo todo',
          'Nao se agache demais — voce perde visao',
          'Levante-se rapido e contra-ataque',
        ],
      },
      relatedTechniqueIds: ['roll', 'slip_l', 'slip_r'],
    ),

    'cover': TechniqueGuide(
      techniqueId: 'cover',
      description: {
        'en': 'Covering up is a shell defense where you tighten your guard and absorb punches with the arms and shoulders. Used when overwhelmed or hurt.',
        'es': 'Cubrirse es una defensa en forma de caparazon donde aprietas la guardia y absorbes golpes con los brazos y hombros. Usado cuando estas superado o herido.',
        'pt': 'Cobrir-se e uma defesa em forma de concha onde voce aperta a guarda e absorve socos com os bracos e ombros. Usado quando esta sobrecarregado ou machucado.',
      },
      formPoints: {
        'en': [
          'Press both gloves tightly to the temples',
          'Tuck the chin and round the shoulders',
          'Keep the elbows close together to protect the body',
          'Move or clinch to escape — do not just stand still',
        ],
        'es': [
          'Presiona ambos guantes firmemente a las sienes',
          'Esconde la barbilla y redondea los hombros',
          'Manten los codos juntos para proteger el cuerpo',
          'Muevete o haz clinch para escapar — no solo te quedes quieto',
        ],
        'pt': [
          'Pressione ambas as luvas firmemente nas temporas',
          'Esconda o queixo e arredonde os ombros',
          'Mantenha os cotovelos juntos para proteger o corpo',
          'Mova-se ou faca clinch para escapar — nao fique parado',
        ],
      },
      relatedTechniqueIds: ['block', 'shoulder_roll'],
    ),

    'shoulder_roll': TechniqueGuide(
      techniqueId: 'shoulder_roll',
      description: {
        'en': 'The shoulder roll uses the lead shoulder to deflect straight punches while keeping the rear hand at the chin. Made famous by Floyd Mayweather Jr.',
        'es': 'El shoulder roll usa el hombro delantero para deflectar golpes rectos mientras mantiene la mano trasera en la barbilla. Hecho famoso por Floyd Mayweather Jr.',
        'pt': 'O shoulder roll usa o ombro da frente para defletir socos retos enquanto mantem a mao de tras no queixo. Tornado famoso por Floyd Mayweather Jr.',
      },
      formPoints: {
        'en': [
          'Turn the lead shoulder up toward the chin',
          'Let the punch glance off the shoulder',
          'Keep the rear hand at the chin for protection',
          'Counter with the rear hand immediately after the roll',
        ],
        'es': [
          'Gira el hombro delantero hacia arriba hacia la barbilla',
          'Deja que el golpe resbale del hombro',
          'Manten la mano trasera en la barbilla para proteccion',
          'Contragolpea con la mano trasera inmediatamente despues del roll',
        ],
        'pt': [
          'Vire o ombro da frente para cima em direcao ao queixo',
          'Deixe o soco escorregar do ombro',
          'Mantenha a mao de tras no queixo para protecao',
          'Contra-ataque com a mao de tras imediatamente apos o roll',
        ],
      },
      relatedTechniqueIds: ['parry', 'cover', 'pull'],
    ),

    'check': TechniqueGuide(
      techniqueId: 'check',
      description: {
        'en': 'Checking a kick means lifting the shin to block an incoming low or body kick. It is the primary kick defense in Muay Thai and kickboxing.',
        'es': 'Chequear una patada significa levantar la canilla para bloquear una patada baja o al cuerpo entrante. Es la defensa principal contra patadas en Muay Thai y kickboxing.',
        'pt': 'Checar um chute significa levantar a canela para bloquear um chute baixo ou ao corpo entrante. E a defesa principal contra chutes no Muay Thai e kickboxing.',
      },
      formPoints: {
        'en': [
          'Lift the knee and turn the shin outward',
          'Point the toes slightly outward for stability',
          'Keep the hands up — do not drop the guard',
          'Turn the hip into the check for a harder block',
        ],
        'es': [
          'Levanta la rodilla y gira la canilla hacia afuera',
          'Apunta los dedos de los pies ligeramente hacia afuera para estabilidad',
          'Manten las manos arriba — no bajes la guardia',
          'Gira la cadera hacia el chequeo para un bloqueo mas duro',
        ],
        'pt': [
          'Levante o joelho e vire a canela para fora',
          'Aponte os dedos dos pes levemente para fora para estabilidade',
          'Mantenha as maos levantadas — nao abaixe a guarda',
          'Vire o quadril para o chequeo para um bloqueio mais duro',
        ],
      },
      relatedTechniqueIds: ['catch_t', 'block'],
    ),

    // =================================================================
    // FOOTWORK (10)
    // =================================================================
    'pivot_l': TechniqueGuide(
      techniqueId: 'pivot_l',
      description: {
        'en': 'Pivoting left rotates your body using the lead foot as an anchor. It changes your angle and opens up new attack lines.',
        'es': 'Pivotear a la izquierda rota tu cuerpo usando el pie delantero como ancla. Cambia tu angulo y abre nuevas lineas de ataque.',
        'pt': 'Pivotar para a esquerda gira seu corpo usando o pe da frente como ancora. Muda seu angulo e abre novas linhas de ataque.',
      },
      formPoints: {
        'en': [
          'Plant the ball of the lead foot',
          'Swing the rear foot around in an arc',
          'Maintain your stance width after the pivot',
          'Throw a punch as you complete the pivot',
        ],
        'es': [
          'Planta la planta del pie delantero',
          'Balancea el pie trasero en un arco',
          'Manten la amplitud de tu posicion despues del pivot',
          'Lanza un golpe al completar el pivot',
        ],
        'pt': [
          'Plante a planta do pe da frente',
          'Balance o pe de tras em um arco',
          'Mantenha a largura da sua posicao apos o pivo',
          'Desfira um soco ao completar o pivo',
        ],
      },
      relatedTechniqueIds: ['pivot_r', 'angle_l', 'circle_l'],
    ),

    'pivot_r': TechniqueGuide(
      techniqueId: 'pivot_r',
      description: {
        'en': 'Pivoting right rotates your body to the right. Used to escape the corner, create angles for the rear hand, or reset position.',
        'es': 'Pivotear a la derecha rota tu cuerpo a la derecha. Se usa para escapar de la esquina, crear angulos para la mano trasera o resetear la posicion.',
        'pt': 'Pivotar para a direita gira seu corpo para a direita. Usado para escapar do canto, criar angulos para a mao de tras ou resetar a posicao.',
      },
      formPoints: {
        'en': [
          'Plant the lead foot and swing the rear foot',
          'Keep the stance balanced and knees bent',
          'Use the pivot to angle for the cross or rear hook',
          'Practice pivoting in both directions equally',
        ],
        'es': [
          'Planta el pie delantero y balancea el pie trasero',
          'Manten la posicion equilibrada y las rodillas flexionadas',
          'Usa el pivot para angularte para el cross o gancho trasero',
          'Practica pivotear en ambas direcciones por igual',
        ],
        'pt': [
          'Plante o pe da frente e balance o pe de tras',
          'Mantenha a posicao equilibrada e os joelhos flexionados',
          'Use o pivo para se angular para o cross ou gancho traseiro',
          'Pratique pivotar em ambas as direcoes igualmente',
        ],
      },
      relatedTechniqueIds: ['pivot_l', 'angle_r', 'circle_r'],
    ),

    'angle_l': TechniqueGuide(
      techniqueId: 'angle_l',
      description: {
        'en': 'Angling left takes you off the opponent\'s center line with a lateral step. It creates an angle where you can land shots they cannot return.',
        'es': 'Angularse a la izquierda te saca de la linea central del oponente con un paso lateral. Crea un angulo donde puedes conectar golpes que no pueden devolver.',
        'pt': 'Angular para a esquerda te tira da linha central do oponente com um passo lateral. Cria um angulo onde voce pode acertar golpes que nao podem devolver.',
      },
      formPoints: {
        'en': [
          'Step diagonally forward and left',
          'Maintain your fighting stance as you move',
          'Throw a combination as you arrive at the new angle',
          'Do not cross your feet — stay balanced',
        ],
        'es': [
          'Da un paso diagonalmente adelante e izquierda',
          'Manten tu posicion de pelea mientras te mueves',
          'Lanza una combinacion al llegar al nuevo angulo',
          'No cruces los pies — mantente equilibrado',
        ],
        'pt': [
          'De um passo diagonalmente para frente e esquerda',
          'Mantenha sua posicao de luta enquanto se move',
          'Desfira uma combinacao ao chegar no novo angulo',
          'Nao cruze os pes — fique equilibrado',
        ],
      },
      relatedTechniqueIds: ['angle_r', 'pivot_l', 'circle_l'],
    ),

    'angle_r': TechniqueGuide(
      techniqueId: 'angle_r',
      description: {
        'en': 'Angling right steps diagonally to the right, taking you to the outside of an orthodox opponent. The preferred angle for landing the cross safely.',
        'es': 'Angularse a la derecha da un paso diagonalmente a la derecha, llevandote al exterior de un oponente ortodoxo. El angulo preferido para conectar el cross de forma segura.',
        'pt': 'Angular para a direita da um passo diagonalmente para a direita, levando voce para fora de um oponente ortodoxo. O angulo preferido para acertar o cross com seguranca.',
      },
      formPoints: {
        'en': [
          'Step diagonally forward and right with the lead foot',
          'Follow with the rear foot to maintain stance width',
          'Attack as you arrive — the angle is temporary',
          'Use this angle to avoid the opponent\'s rear hand',
        ],
        'es': [
          'Da un paso diagonalmente adelante y derecha con el pie delantero',
          'Sigue con el pie trasero para mantener la amplitud de posicion',
          'Ataca al llegar — el angulo es temporal',
          'Usa este angulo para evitar la mano trasera del oponente',
        ],
        'pt': [
          'De um passo diagonalmente para frente e direita com o pe da frente',
          'Siga com o pe de tras para manter a largura da posicao',
          'Ataque ao chegar — o angulo e temporario',
          'Use este angulo para evitar a mao de tras do oponente',
        ],
      },
      relatedTechniqueIds: ['angle_l', 'pivot_r', 'circle_r'],
    ),

    'step_back': TechniqueGuide(
      techniqueId: 'step_back',
      description: {
        'en': 'Stepping back creates distance from an advancing opponent. Used defensively to avoid punches or offensively to draw the opponent into range.',
        'es': 'Dar un paso atras crea distancia de un oponente que avanza. Se usa defensivamente para evitar golpes u ofensivamente para atraer al oponente a tu rango.',
        'pt': 'Dar um passo atras cria distancia de um oponente que avanca. Usado defensivamente para evitar socos ou ofensivamente para atrair o oponente ao alcance.',
      },
      formPoints: {
        'en': [
          'Push off the lead foot and step back with the rear foot first',
          'Maintain your stance distance — do not widen or narrow',
          'Stay on the balls of the feet for quick recovery',
          'Counter as the opponent steps into your range',
        ],
        'es': [
          'Impulsa desde el pie delantero y da un paso atras con el pie trasero primero',
          'Manten la distancia de tu posicion — no ensanches ni estreches',
          'Quedate en las puntas de los pies para recuperacion rapida',
          'Contragolpea cuando el oponente entre en tu rango',
        ],
        'pt': [
          'Impulsione a partir do pe da frente e de um passo atras com o pe de tras primeiro',
          'Mantenha a distancia da sua posicao — nao alargue nem estreite',
          'Fique nas pontas dos pes para recuperacao rapida',
          'Contra-ataque quando o oponente entrar no seu alcance',
        ],
      },
      relatedTechniqueIds: ['pull', 'in_out'],
    ),

    'cut_off': TechniqueGuide(
      techniqueId: 'cut_off',
      description: {
        'en': 'Cutting off the ring uses lateral movement and angles to prevent the opponent from escaping. A key pressure-fighting skill.',
        'es': 'Cortar el ring usa movimiento lateral y angulos para evitar que el oponente escape. Una habilidad clave para pelear con presion.',
        'pt': 'Cortar o ringue usa movimento lateral e angulos para impedir que o oponente escape. Uma habilidade chave para lutar com pressao.',
      },
      formPoints: {
        'en': [
          'Move laterally to mirror the opponent\'s movement',
          'Take small, quick steps — do not lunge',
          'Use feints and jabs to control the opponent\'s path',
          'Cut the angle, do not chase in a straight line',
        ],
        'es': [
          'Muevete lateralmente para reflejar el movimiento del oponente',
          'Da pasos pequenos y rapidos — no te lances',
          'Usa fintas y jabs para controlar el camino del oponente',
          'Corta el angulo, no persigas en linea recta',
        ],
        'pt': [
          'Mova-se lateralmente para espelhar o movimento do oponente',
          'De passos pequenos e rapidos — nao se lance',
          'Use fintas e jabs para controlar o caminho do oponente',
          'Corte o angulo, nao persiga em linha reta',
        ],
      },
      relatedTechniqueIds: ['pivot_l', 'pivot_r', 'lateral'],
    ),

    'circle_l': TechniqueGuide(
      techniqueId: 'circle_l',
      description: {
        'en': 'Circling left moves you around the opponent using small lateral steps. It keeps you moving and makes you a harder target.',
        'es': 'Circular a la izquierda te mueve alrededor del oponente usando pasos laterales pequenos. Te mantiene en movimiento y te convierte en un objetivo mas dificil.',
        'pt': 'Circular para a esquerda te move ao redor do oponente usando passos laterais pequenos. Te mantem em movimento e te torna um alvo mais dificil.',
      },
      formPoints: {
        'en': [
          'Lead with the left foot, follow with the right',
          'Keep the stance width consistent',
          'Stay on the balls of your feet',
          'Throw shots while circling — do not just move',
        ],
        'es': [
          'Lidera con el pie izquierdo, sigue con el derecho',
          'Manten la amplitud de posicion consistente',
          'Quedate en las puntas de los pies',
          'Lanza golpes mientras circulas — no solo te muevas',
        ],
        'pt': [
          'Lidere com o pe esquerdo, siga com o direito',
          'Mantenha a largura da posicao consistente',
          'Fique nas pontas dos pes',
          'Desfira golpes enquanto circula — nao apenas se mova',
        ],
      },
      relatedTechniqueIds: ['circle_r', 'pivot_l', 'angle_l'],
    ),

    'circle_r': TechniqueGuide(
      techniqueId: 'circle_r',
      description: {
        'en': 'Circling right moves you toward the opponent\'s power hand — use with caution. It can set up your own rear hand attacks.',
        'es': 'Circular a la derecha te lleva hacia la mano de potencia del oponente — usa con precaucion. Puede preparar tus propios ataques con la mano trasera.',
        'pt': 'Circular para a direita te leva em direcao a mao de potencia do oponente — use com cautela. Pode preparar seus proprios ataques com a mao de tras.',
      },
      formPoints: {
        'en': [
          'Lead with the right foot, follow with the left',
          'Maintain guard — you are moving toward the power hand',
          'Use this to set up your own rear hand attacks',
          'Keep steps small and controlled',
        ],
        'es': [
          'Lidera con el pie derecho, sigue con el izquierdo',
          'Manten la guardia — te mueves hacia la mano de potencia',
          'Usa esto para preparar tus propios ataques con la mano trasera',
          'Manten los pasos pequenos y controlados',
        ],
        'pt': [
          'Lidere com o pe direito, siga com o esquerdo',
          'Mantenha a guarda — voce esta se movendo em direcao a mao de potencia',
          'Use isso para preparar seus proprios ataques com a mao de tras',
          'Mantenha os passos pequenos e controlados',
        ],
      },
      relatedTechniqueIds: ['circle_l', 'pivot_r', 'angle_r'],
    ),

    'in_out': TechniqueGuide(
      techniqueId: 'in_out',
      description: {
        'en': 'In-and-out movement lets you dart in to attack and immediately pull out of range. It is the foundation of an outfighter\'s style.',
        'es': 'El movimiento de entrada y salida te permite entrar para atacar e inmediatamente salir del alcance. Es la base del estilo de un outfighter.',
        'pt': 'O movimento de entrada e saida te permite avancar para atacar e imediatamente sair do alcance. E a base do estilo de um outfighter.',
      },
      formPoints: {
        'en': [
          'Push off the rear foot to step in',
          'Throw your combination during the forward step',
          'Push off the lead foot to step out immediately',
          'Do not stay in the pocket — get in, hit, get out',
        ],
        'es': [
          'Impulsa desde el pie trasero para entrar',
          'Lanza tu combinacion durante el paso adelante',
          'Impulsa desde el pie delantero para salir inmediatamente',
          'No te quedes en el bolsillo — entra, golpea, sal',
        ],
        'pt': [
          'Impulsione a partir do pe de tras para entrar',
          'Desfira sua combinacao durante o passo a frente',
          'Impulsione a partir do pe da frente para sair imediatamente',
          'Nao fique no bolsao — entre, bata, saia',
        ],
      },
      relatedTechniqueIds: ['step_back', 'lateral'],
    ),

    'lateral': TechniqueGuide(
      techniqueId: 'lateral',
      description: {
        'en': 'Lateral movement is side-to-side stepping that keeps you off the center line. It makes you unpredictable and harder to hit.',
        'es': 'El movimiento lateral es un desplazamiento de lado a lado que te mantiene fuera de la linea central. Te hace impredecible y mas dificil de golpear.',
        'pt': 'O movimento lateral e um deslocamento de lado a lado que te mantem fora da linha central. Te torna imprevisivel e mais dificil de acertar.',
      },
      formPoints: {
        'en': [
          'Move the lead foot first when going left, rear foot first when going right',
          'Never cross your feet',
          'Keep the stance width constant',
          'Combine lateral movement with level changes for unpredictability',
        ],
        'es': [
          'Mueve el pie delantero primero al ir a la izquierda, pie trasero primero al ir a la derecha',
          'Nunca cruces los pies',
          'Manten la amplitud de posicion constante',
          'Combina movimiento lateral con cambios de nivel para ser impredecible',
        ],
        'pt': [
          'Mova o pe da frente primeiro ao ir para a esquerda, pe de tras primeiro ao ir para a direita',
          'Nunca cruze os pes',
          'Mantenha a largura da posicao constante',
          'Combine movimento lateral com mudancas de nivel para ser imprevisivel',
        ],
      },
      relatedTechniqueIds: ['circle_l', 'circle_r', 'in_out'],
    ),

    // =================================================================
    // KICKS (8)
    // =================================================================
    'lk': TechniqueGuide(
      techniqueId: 'lk',
      description: {
        'en': 'The low kick targets the thigh or calf. One of the most effective techniques in Muay Thai and kickboxing, causing cumulative damage that limits mobility.',
        'es': 'La patada baja apunta al muslo o pantorrilla. Una de las tecnicas mas efectivas en Muay Thai y kickboxing, causando dano acumulativo que limita la movilidad.',
        'pt': 'O chute baixo mira a coxa ou panturrilha. Uma das tecnicas mais eficazes no Muay Thai e kickboxing, causando dano acumulativo que limita a mobilidade.',
      },
      formPoints: {
        'en': [
          'Step at a 45-degree angle with the lead foot',
          'Rotate the hips fully through the kick',
          'Strike with the lower shin, not the foot',
          'Follow through the target — do not pull back early',
        ],
        'es': [
          'Da un paso en angulo de 45 grados con el pie delantero',
          'Rota las caderas completamente a traves de la patada',
          'Golpea con la parte baja de la canilla, no el pie',
          'Sigue a traves del objetivo — no retires antes',
        ],
        'pt': [
          'De um passo em angulo de 45 graus com o pe da frente',
          'Gire os quadris completamente atraves do chute',
          'Acerte com a parte baixa da canela, nao o pe',
          'Siga atraves do alvo — nao retire antes',
        ],
      },
      relatedTechniqueIds: ['bk', 'hk', 'switch_kick'],
    ),

    'hk': TechniqueGuide(
      techniqueId: 'hk',
      description: {
        'en': 'The high kick targets the head or neck. High-risk, high-reward — it can end a fight instantly. Requires flexibility and proper setup.',
        'es': 'La patada alta apunta a la cabeza o cuello. Alto riesgo, alta recompensa — puede terminar una pelea instantaneamente. Requiere flexibilidad y preparacion.',
        'pt': 'O chute alto mira a cabeca ou pescoco. Alto risco, alta recompensa — pode terminar uma luta instantaneamente. Requer flexibilidade e preparacao.',
      },
      formPoints: {
        'en': [
          'Set up with punches or a low kick first',
          'Turn the supporting foot completely',
          'Kick through the target, not at it',
          'Keep the hands up — high kicks leave you exposed',
        ],
        'es': [
          'Prepara con golpes o una patada baja primero',
          'Gira el pie de apoyo completamente',
          'Patea a traves del objetivo, no hacia el',
          'Manten las manos arriba — las patadas altas te dejan expuesto',
        ],
        'pt': [
          'Prepare com socos ou um chute baixo primeiro',
          'Vire o pe de apoio completamente',
          'Chute atraves do alvo, nao para ele',
          'Mantenha as maos levantadas — chutes altos te deixam exposto',
        ],
      },
      relatedTechniqueIds: ['lk', 'bk', 'switch_kick'],
    ),

    'bk': TechniqueGuide(
      techniqueId: 'bk',
      description: {
        'en': 'The body kick targets the ribs, liver, or midsection. The workhorse kick of Muay Thai, combining power and relatively low risk.',
        'es': 'La patada al cuerpo apunta a las costillas, higado o seccion media. La patada principal del Muay Thai, combinando potencia y riesgo relativamente bajo.',
        'pt': 'O chute ao corpo mira as costelas, figado ou secao media. O chute principal do Muay Thai, combinando potencia e risco relativamente baixo.',
      },
      formPoints: {
        'en': [
          'Aim for the floating ribs or liver area',
          'Step at an angle and rotate the hip fully',
          'Strike through the target with the shin',
          'Return to stance quickly after the kick',
        ],
        'es': [
          'Apunta a las costillas flotantes o area del higado',
          'Da un paso en angulo y rota la cadera completamente',
          'Golpea a traves del objetivo con la canilla',
          'Regresa a la posicion rapidamente despues de la patada',
        ],
        'pt': [
          'Mire as costelas flutuantes ou area do figado',
          'De um passo em angulo e gire o quadril completamente',
          'Acerte atraves do alvo com a canela',
          'Retorne a posicao rapidamente apos o chute',
        ],
      },
      relatedTechniqueIds: ['lk', 'hk', 'teep'],
    ),

    'switch_kick': TechniqueGuide(
      techniqueId: 'switch_kick',
      description: {
        'en': 'The switch kick swaps the stance mid-motion to throw a power roundhouse from the lead side. Adds deception and extra power.',
        'es': 'La patada switch cambia la posicion a mitad de movimiento para lanzar una patada circular con potencia desde el lado delantero. Agrega engano y potencia extra.',
        'pt': 'O chute switch troca a posicao durante o movimento para desferir uma circular com potencia do lado da frente. Adiciona engano e potencia extra.',
      },
      formPoints: {
        'en': [
          'Quickly switch your feet to reverse the stance',
          'Kick immediately after the switch — no pause',
          'Use the switch momentum to add power',
          'Practice until the switch is invisible to opponents',
        ],
        'es': [
          'Cambia rapidamente los pies para invertir la posicion',
          'Patea inmediatamente despues del switch — sin pausa',
          'Usa el impulso del switch para agregar potencia',
          'Practica hasta que el switch sea invisible para los oponentes',
        ],
        'pt': [
          'Troque rapidamente os pes para inverter a posicao',
          'Chute imediatamente apos o switch — sem pausa',
          'Use o impulso do switch para adicionar potencia',
          'Pratique ate que o switch seja invisivel para os oponentes',
        ],
      },
      relatedTechniqueIds: ['lk', 'bk', 'hk'],
    ),

    'teep': TechniqueGuide(
      techniqueId: 'teep',
      description: {
        'en': 'The teep (push kick) is Muay Thai\'s jab equivalent for the legs. It pushes opponents away, controls distance, and can target the body or hip.',
        'es': 'El teep (patada de empujon) es el equivalente del jab para las piernas. Empuja a los oponentes, controla la distancia y puede apuntar al cuerpo o cadera.',
        'pt': 'O teep (chute de empurrao) e o equivalente do jab para as pernas. Empurra os oponentes, controla a distancia e pode mirar o corpo ou quadril.',
      },
      formPoints: {
        'en': [
          'Chamber the knee to the chest',
          'Push straight out with the ball of the foot',
          'Target the solar plexus, hip, or thigh',
          'Retract quickly to avoid the leg being caught',
        ],
        'es': [
          'Levanta la rodilla al pecho',
          'Empuja recto hacia afuera con la planta del pie',
          'Apunta al plexo solar, cadera o muslo',
          'Retrae rapido para evitar que atrapen la pierna',
        ],
        'pt': [
          'Levante o joelho ao peito',
          'Empurre reto para fora com a planta do pe',
          'Mire o plexo solar, quadril ou coxa',
          'Retraia rapidamente para evitar que peguem a perna',
        ],
      },
      relatedTechniqueIds: ['rear_teep', 'lk'],
    ),

    'rear_teep': TechniqueGuide(
      techniqueId: 'rear_teep',
      description: {
        'en': 'The rear teep is thrown with the rear leg for more power and distance than the lead teep. It can push opponents across the ring.',
        'es': 'El teep trasero se lanza con la pierna trasera para mas potencia y distancia que el teep delantero. Puede empujar a los oponentes a traves del ring.',
        'pt': 'O teep traseiro e desferido com a perna de tras para mais potencia e distancia que o teep da frente. Pode empurrar os oponentes atraves do ringue.',
      },
      formPoints: {
        'en': [
          'Step forward slightly with the lead foot to shift weight',
          'Chamber the rear knee and drive forward',
          'Push through the target with the ball of the foot',
          'Maintain balance — the rear teep shifts your center forward',
        ],
        'es': [
          'Da un paso corto adelante con el pie delantero para cambiar el peso',
          'Levanta la rodilla trasera e impulsa hacia adelante',
          'Empuja a traves del objetivo con la planta del pie',
          'Manten el equilibrio — el teep trasero cambia tu centro hacia adelante',
        ],
        'pt': [
          'De um passo curto a frente com o pe da frente para mudar o peso',
          'Levante o joelho de tras e impulsione para frente',
          'Empurre atraves do alvo com a planta do pe',
          'Mantenha o equilibrio — o teep traseiro muda seu centro para frente',
        ],
      },
      relatedTechniqueIds: ['teep', 'bk'],
    ),

    'spinning_back_kick': TechniqueGuide(
      techniqueId: 'spinning_back_kick',
      description: {
        'en': 'The spinning back kick rotates 180 degrees and strikes with the heel. Tremendous power — one of the most devastating kicks in combat sports.',
        'es': 'La patada giratoria trasera gira 180 grados y golpea con el talon. Tremenda potencia — una de las patadas mas devastadoras en deportes de combate.',
        'pt': 'O chute giratorio traseiro gira 180 graus e acerta com o calcanhar. Tremenda potencia — um dos chutes mais devastadores nos esportes de combate.',
      },
      formPoints: {
        'en': [
          'Look over the shoulder at the target before turning',
          'Spin on the ball of the lead foot',
          'Drive the heel straight back into the target',
          'Commit fully — a half-spin leaves you exposed',
        ],
        'es': [
          'Mira por encima del hombro al objetivo antes de girar',
          'Gira sobre la planta del pie delantero',
          'Clava el talon recto hacia atras en el objetivo',
          'Comprometete completamente — un medio giro te deja expuesto',
        ],
        'pt': [
          'Olhe por cima do ombro para o alvo antes de girar',
          'Gire sobre a planta do pe da frente',
          'Crave o calcanhar reto para tras no alvo',
          'Comprometa-se completamente — um meio giro te deixa exposto',
        ],
      },
      relatedTechniqueIds: ['axe_kick', 'hk'],
    ),

    'axe_kick': TechniqueGuide(
      techniqueId: 'axe_kick',
      description: {
        'en': 'The axe kick brings the leg up high and drops the heel onto the opponent\'s shoulder, collarbone, or head. Flashy but effective when well-timed.',
        'es': 'La patada hacha levanta la pierna alto y deja caer el talon sobre el hombro, clavicula o cabeza del oponente. Llamativa pero efectiva cuando esta bien cronometrada.',
        'pt': 'O chute machado levanta a perna alto e deixa cair o calcanhar sobre o ombro, clavicula ou cabeca do oponente. Chamativo mas eficaz quando bem cronometrado.',
      },
      formPoints: {
        'en': [
          'Swing the leg up straight in front of you',
          'Drop the heel down sharply onto the target',
          'Aim for the collarbone or top of the shoulder',
          'Return to guard immediately after landing the kick',
        ],
        'es': [
          'Balancea la pierna hacia arriba recto frente a ti',
          'Deja caer el talon bruscamente sobre el objetivo',
          'Apunta a la clavicula o parte superior del hombro',
          'Regresa a la guardia inmediatamente despues de aterrizar la patada',
        ],
        'pt': [
          'Balance a perna para cima reto a sua frente',
          'Deixe cair o calcanhar bruscamente sobre o alvo',
          'Mire a clavicula ou parte superior do ombro',
          'Retorne a guarda imediatamente apos acertar o chute',
        ],
      },
      relatedTechniqueIds: ['hk', 'spinning_back_kick'],
    ),

    // =================================================================
    // ELBOWS (4)
    // =================================================================
    'lead_elbow': TechniqueGuide(
      techniqueId: 'lead_elbow',
      description: {
        'en': 'The lead elbow is a devastating close-range strike thrown horizontally. Elbows are the sharpest weapons in Muay Thai and cause cuts easily.',
        'es': 'El codo delantero es un golpe devastador de corta distancia lanzado horizontalmente. Los codos son las armas mas afiladas del Muay Thai y causan cortes facilmente.',
        'pt': 'A cotovelada da frente e um golpe devastador de curta distancia desferido horizontalmente. Os cotovelos sao as armas mais afiadas do Muay Thai e causam cortes facilmente.',
      },
      formPoints: {
        'en': [
          'Close the distance — elbows are extremely short-range',
          'Rotate the hips and shoulders as with a hook',
          'Strike with the point of the elbow',
          'Keep the opposite hand up for defense',
        ],
        'es': [
          'Cierra la distancia — los codos son de rango extremadamente corto',
          'Rota las caderas y hombros como con un gancho',
          'Golpea con la punta del codo',
          'Manten la mano opuesta arriba para defensa',
        ],
        'pt': [
          'Feche a distancia — os cotovelos sao de alcance extremamente curto',
          'Gire os quadris e ombros como com um gancho',
          'Acerte com a ponta do cotovelo',
          'Mantenha a mao oposta levantada para defesa',
        ],
      },
      relatedTechniqueIds: ['rear_elbow', 'up_elbow', 'spinning_elbow'],
    ),

    'rear_elbow': TechniqueGuide(
      techniqueId: 'rear_elbow',
      description: {
        'en': 'The rear elbow delivers more power than the lead elbow due to greater hip rotation. Commonly used in the clinch or after closing distance.',
        'es': 'El codo trasero entrega mas potencia que el codo delantero debido a la mayor rotacion de caderas. Comunmente usado en el clinch o despues de cerrar la distancia.',
        'pt': 'A cotovelada traseira entrega mais potencia que a cotovelada da frente devido a maior rotacao do quadril. Comumente usada no clinch ou apos fechar a distancia.',
      },
      formPoints: {
        'en': [
          'Drive the rear hip forward as you throw',
          'Slash horizontally across the target',
          'Aim for the eyebrow, temple, or chin',
          'Use after a punch combination to close distance',
        ],
        'es': [
          'Impulsa la cadera trasera hacia adelante al lanzar',
          'Corta horizontalmente a traves del objetivo',
          'Apunta a la ceja, sien o barbilla',
          'Usa despues de una combinacion de golpes para cerrar distancia',
        ],
        'pt': [
          'Impulsione o quadril de tras para frente ao desferir',
          'Corte horizontalmente atraves do alvo',
          'Mire a sobrancelha, tempera ou queixo',
          'Use apos uma combinacao de socos para fechar distancia',
        ],
      },
      relatedTechniqueIds: ['lead_elbow', 'up_elbow', 'spinning_elbow'],
    ),

    'up_elbow': TechniqueGuide(
      techniqueId: 'up_elbow',
      description: {
        'en': 'The upward elbow rises vertically and targets the chin from below. Extremely effective against opponents who lean forward or duck into range.',
        'es': 'El codo ascendente sube verticalmente y apunta a la barbilla desde abajo. Extremadamente efectivo contra oponentes que se inclinan o se agachan en rango.',
        'pt': 'A cotovelada ascendente sobe verticalmente e mira o queixo por baixo. Extremamente eficaz contra oponentes que se inclinam ou se abaixam no alcance.',
      },
      formPoints: {
        'en': [
          'Drive upward from the legs, similar to an uppercut',
          'Strike with the point of the elbow under the chin',
          'Step in to close distance as you throw',
          'Follow through vertically, not diagonally',
        ],
        'es': [
          'Impulsa hacia arriba desde las piernas, similar a un uppercut',
          'Golpea con la punta del codo debajo de la barbilla',
          'Avanza para cerrar distancia al lanzar',
          'Sigue verticalmente, no diagonalmente',
        ],
        'pt': [
          'Impulsione para cima a partir das pernas, similar a um uppercut',
          'Acerte com a ponta do cotovelo embaixo do queixo',
          'Avance para fechar distancia ao desferir',
          'Siga verticalmente, nao diagonalmente',
        ],
      },
      relatedTechniqueIds: ['lead_elbow', 'rear_elbow', 'spinning_elbow'],
    ),

    'spinning_elbow': TechniqueGuide(
      techniqueId: 'spinning_elbow',
      description: {
        'en': 'The spinning elbow is a 360-degree turn that delivers an elbow with tremendous force. High-risk, high-reward — it can knock out an opponent instantly.',
        'es': 'El codo giratorio es un giro de 360 grados que entrega un codo con tremenda fuerza. Alto riesgo, alta recompensa — puede noquear instantaneamente.',
        'pt': 'A cotovelada giratoria e um giro de 360 graus que desfere uma cotovelada com tremenda forca. Alto risco, alta recompensa — pode nocautear instantaneamente.',
      },
      formPoints: {
        'en': [
          'Look at the target over your shoulder before committing',
          'Spin on the ball of the lead foot',
          'Keep the elbow tight and level as you spin',
          'Commit fully — hesitation leads to being countered',
        ],
        'es': [
          'Mira al objetivo por encima del hombro antes de comprometerte',
          'Gira sobre la planta del pie delantero',
          'Manten el codo apretado y nivelado al girar',
          'Comprometete completamente — la vacilacion lleva a ser contragolpeado',
        ],
        'pt': [
          'Olhe para o alvo por cima do ombro antes de se comprometer',
          'Gire sobre a planta do pe da frente',
          'Mantenha o cotovelo junto e nivelado ao girar',
          'Comprometa-se completamente — a hesitacao leva a ser contra-atacado',
        ],
      },
      relatedTechniqueIds: ['lead_elbow', 'rear_elbow', 'up_elbow'],
    ),

    // =================================================================
    // KNEES (3)
    // =================================================================
    'lead_knee': TechniqueGuide(
      techniqueId: 'lead_knee',
      description: {
        'en': 'The lead knee is a close-range weapon driven upward into the body or head. A staple of Muay Thai clinch fighting.',
        'es': 'La rodilla delantera es un arma de corta distancia impulsada hacia arriba en el cuerpo o cabeza. Un basico del clinch en Muay Thai.',
        'pt': 'A joelhada da frente e uma arma de curta distancia impulsionada para cima no corpo ou cabeca. Um basico do clinch no Muay Thai.',
      },
      formPoints: {
        'en': [
          'Pull the opponent down as you drive the knee up',
          'Rise on the standing foot for maximum height',
          'Strike with the tip of the knee',
          'Use the clinch to control the opponent\'s posture',
        ],
        'es': [
          'Jala al oponente hacia abajo mientras impulsas la rodilla',
          'Levantate sobre el pie de apoyo para maxima altura',
          'Golpea con la punta de la rodilla',
          'Usa el clinch para controlar la postura del oponente',
        ],
        'pt': [
          'Puxe o oponente para baixo enquanto impulsiona o joelho',
          'Levante-se sobre o pe de apoio para altura maxima',
          'Acerte com a ponta do joelho',
          'Use o clinch para controlar a postura do oponente',
        ],
      },
      relatedTechniqueIds: ['rear_knee', 'diagonal_knee', 'clinch'],
    ),

    'rear_knee': TechniqueGuide(
      techniqueId: 'rear_knee',
      description: {
        'en': 'The rear knee drives upward from the back leg with full hip rotation. More powerful than the lead knee and the primary weapon in the Muay Thai clinch.',
        'es': 'La rodilla trasera impulsa hacia arriba desde la pierna trasera con rotacion completa de caderas. Mas potente que la rodilla delantera y el arma principal en el clinch de Muay Thai.',
        'pt': 'A joelhada traseira impulsiona para cima a partir da perna de tras com rotacao completa do quadril. Mais poderosa que a joelhada da frente e a arma principal no clinch do Muay Thai.',
      },
      formPoints: {
        'en': [
          'Drive the rear hip forward as the knee rises',
          'Pull the opponent into the knee for maximum impact',
          'Rise on the toes of the standing foot',
          'Keep the hands controlling the head in clinch',
        ],
        'es': [
          'Impulsa la cadera trasera hacia adelante mientras sube la rodilla',
          'Jala al oponente hacia la rodilla para maximo impacto',
          'Levantate en las puntas del pie de apoyo',
          'Manten las manos controlando la cabeza en clinch',
        ],
        'pt': [
          'Impulsione o quadril de tras para frente enquanto o joelho sobe',
          'Puxe o oponente para o joelho para maximo impacto',
          'Levante-se nas pontas do pe de apoio',
          'Mantenha as maos controlando a cabeca no clinch',
        ],
      },
      relatedTechniqueIds: ['lead_knee', 'diagonal_knee', 'clinch'],
    ),

    'diagonal_knee': TechniqueGuide(
      techniqueId: 'diagonal_knee',
      description: {
        'en': 'The diagonal knee strikes at an angle into the ribcage. Harder to defend than a straight knee because it comes from an unexpected angle.',
        'es': 'La rodilla diagonal golpea en angulo en la caja toracica. Mas dificil de defender que una rodilla recta porque viene de un angulo inesperado.',
        'pt': 'A joelhada diagonal acerta em angulo na caixa toracica. Mais dificil de defender que uma joelhada reta porque vem de um angulo inesperado.',
      },
      formPoints: {
        'en': [
          'Drive the knee at a 45-degree angle into the ribs',
          'Twist the hip to generate the diagonal trajectory',
          'Control the opponent\'s posture to expose the ribs',
          'Combine with straight knees to keep the opponent guessing',
        ],
        'es': [
          'Impulsa la rodilla en un angulo de 45 grados en las costillas',
          'Gira la cadera para generar la trayectoria diagonal',
          'Controla la postura del oponente para exponer las costillas',
          'Combina con rodillas rectas para mantener al oponente adivinando',
        ],
        'pt': [
          'Impulsione o joelho em um angulo de 45 graus nas costelas',
          'Gire o quadril para gerar a trajetoria diagonal',
          'Controle a postura do oponente para expor as costelas',
          'Combine com joelhadas retas para manter o oponente adivinhando',
        ],
      },
      relatedTechniqueIds: ['lead_knee', 'rear_knee', 'clinch'],
    ),

    // =================================================================
    // GRAPPLING (12)
    // =================================================================
    'clinch': TechniqueGuide(
      techniqueId: 'clinch',
      description: {
        'en': 'The clinch is a close-range grappling position where fighters control each other around the head, neck, or body. The foundation of Muay Thai inside fighting.',
        'es': 'El clinch es una posicion de agarre de corta distancia donde los peleadores se controlan alrededor de la cabeza, cuello o cuerpo. La base de la pelea interna del Muay Thai.',
        'pt': 'O clinch e uma posicao de agarramento de curta distancia onde os lutadores se controlam ao redor da cabeca, pescoco ou corpo. A base da luta interna do Muay Thai.',
      },
      formPoints: {
        'en': [
          'Control the back of the opponent\'s head with both hands',
          'Keep your elbows tight to prevent the opponent from entering',
          'Fight for the dominant position (double collar tie)',
          'Throw knees and elbows from the clinch',
        ],
        'es': [
          'Controla la parte trasera de la cabeza del oponente con ambas manos',
          'Manten los codos apretados para evitar que el oponente entre',
          'Pelea por la posicion dominante (doble agarre de cuello)',
          'Lanza rodillas y codos desde el clinch',
        ],
        'pt': [
          'Controle a parte de tras da cabeca do oponente com ambas as maos',
          'Mantenha os cotovelos apertados para impedir o oponente de entrar',
          'Lute pela posicao dominante (duplo agarre de pescoco)',
          'Desfira joelhadas e cotoveladas a partir do clinch',
        ],
      },
      relatedTechniqueIds: ['clinch_break', 'rear_knee', 'lead_elbow'],
    ),

    'level_change': TechniqueGuide(
      techniqueId: 'level_change',
      description: {
        'en': 'A level change drops your body height by bending the knees to set up a takedown or body shot. Essential for wrestlers and MMA fighters.',
        'es': 'Un cambio de nivel baja la altura de tu cuerpo flexionando las rodillas para preparar un derribo o golpe al cuerpo. Esencial para luchadores y peleadores de MMA.',
        'pt': 'Uma mudanca de nivel abaixa a altura do corpo flexionando os joelhos para preparar uma queda ou golpe ao corpo. Essencial para lutadores e lutadores de MMA.',
      },
      formPoints: {
        'en': [
          'Drop your hips by bending the knees, not the waist',
          'Keep your back straight and head up',
          'Change levels quickly — speed makes it deceptive',
          'Use it as a feint even when not shooting',
        ],
        'es': [
          'Baja tus caderas flexionando las rodillas, no la cintura',
          'Manten la espalda recta y la cabeza arriba',
          'Cambia de nivel rapido — la velocidad lo hace enganoso',
          'Usalo como finta incluso cuando no vas a derribar',
        ],
        'pt': [
          'Abaixe seus quadris flexionando os joelhos, nao a cintura',
          'Mantenha as costas retas e a cabeca levantada',
          'Mude de nivel rapido — a velocidade o torna enganoso',
          'Use como finta mesmo quando nao vai derrubar',
        ],
      },
      relatedTechniqueIds: ['takedown', 'single_leg', 'double_leg'],
    ),

    'sprawl': TechniqueGuide(
      techniqueId: 'sprawl',
      description: {
        'en': 'The sprawl is the primary defense against takedowns. You kick your legs back and drive your hips down onto the opponent\'s back to stop the shot.',
        'es': 'El sprawl es la defensa principal contra derribos. Pateas las piernas hacia atras y empujas tus caderas sobre la espalda del oponente para detener la entrada.',
        'pt': 'O sprawl e a defesa principal contra quedas. Voce chuta as pernas para tras e empurra os quadris sobre as costas do oponente para parar a entrada.',
      },
      formPoints: {
        'en': [
          'React immediately when you see the level change',
          'Kick both legs straight back behind you',
          'Drive your hips down onto the opponent\'s shoulders',
          'Crossface or grab a front headlock to control',
        ],
        'es': [
          'Reacciona inmediatamente cuando veas el cambio de nivel',
          'Patea ambas piernas recto hacia atras detras de ti',
          'Empuja tus caderas hacia abajo sobre los hombros del oponente',
          'Haz crossface o agarra una guillotina frontal para controlar',
        ],
        'pt': [
          'Reaja imediatamente quando ver a mudanca de nivel',
          'Chute ambas as pernas reto para tras',
          'Empurre seus quadris para baixo sobre os ombros do oponente',
          'Faca crossface ou agarre uma guilhotina frontal para controlar',
        ],
      },
      relatedTechniqueIds: ['front_headlock', 'level_change', 'takedown'],
    ),

    'takedown': TechniqueGuide(
      techniqueId: 'takedown',
      description: {
        'en': 'A takedown brings the opponent from standing to the ground. The foundational wrestling skill and essential for MMA.',
        'es': 'Un derribo lleva al oponente de pie al suelo. La habilidad fundamental de lucha y esencial para MMA.',
        'pt': 'Uma queda leva o oponente de pe ao chao. A habilidade fundamental de luta e essencial para MMA.',
      },
      formPoints: {
        'en': [
          'Set up with strikes or feints before shooting',
          'Change levels and penetrate with a deep step',
          'Drive through the opponent, not into them',
          'Establish a dominant position after taking down',
        ],
        'es': [
          'Prepara con golpes o fintas antes de atacar',
          'Cambia de nivel y penetra con un paso profundo',
          'Empuja a traves del oponente, no hacia ellos',
          'Establece una posicion dominante despues del derribo',
        ],
        'pt': [
          'Prepare com golpes ou fintas antes de avancar',
          'Mude de nivel e penetre com um passo profundo',
          'Empurre atraves do oponente, nao em direcao a eles',
          'Estabeleca uma posicao dominante apos a queda',
        ],
      },
      relatedTechniqueIds: ['single_leg', 'double_leg', 'level_change'],
    ),

    'single_leg': TechniqueGuide(
      techniqueId: 'single_leg',
      description: {
        'en': 'The single leg attacks one of the opponent\'s legs, lifting and tripping them. The most versatile takedown in wrestling and MMA.',
        'es': 'La pierna unica ataca una de las piernas del oponente, levantandola y derribandolo. El derribo mas versatil en lucha y MMA.',
        'pt': 'A perna unica ataca uma das pernas do oponente, levantando e derrubando. A queda mais versatil na luta e MMA.',
      },
      formPoints: {
        'en': [
          'Level change and shoot for one leg',
          'Grab behind the knee and pull it to your chest',
          'Keep your head on the inside (same side as the leg)',
          'Trip, lift, or run the pipe to finish',
        ],
        'es': [
          'Cambia de nivel y ataca una pierna',
          'Agarra detras de la rodilla y jalala a tu pecho',
          'Manten tu cabeza adentro (mismo lado que la pierna)',
          'Tropieza, levanta o corre el tubo para finalizar',
        ],
        'pt': [
          'Mude de nivel e avance para uma perna',
          'Agarre atras do joelho e puxe ao peito',
          'Mantenha sua cabeca por dentro (mesmo lado da perna)',
          'Tropece, levante ou corra o tubo para finalizar',
        ],
      },
      relatedTechniqueIds: ['double_leg', 'takedown', 'ankle_pick'],
    ),

    'double_leg': TechniqueGuide(
      techniqueId: 'double_leg',
      description: {
        'en': 'The double leg attacks both legs simultaneously, driving through the opponent. The most direct and explosive takedown technique.',
        'es': 'Las dos piernas atacan ambas piernas simultaneamente, empujando a traves del oponente. La tecnica de derribo mas directa y explosiva.',
        'pt': 'As duas pernas atacam ambas as pernas simultaneamente, empurrando atraves do oponente. A tecnica de queda mais direta e explosiva.',
      },
      formPoints: {
        'en': [
          'Change levels deeply and shoot between the legs',
          'Put your shoulder into the opponent\'s hips',
          'Grab behind both knees',
          'Drive forward and up to lift and dump',
        ],
        'es': [
          'Cambia de nivel profundamente y ataca entre las piernas',
          'Pon tu hombro en las caderas del oponente',
          'Agarra detras de ambas rodillas',
          'Empuja hacia adelante y arriba para levantar y derribar',
        ],
        'pt': [
          'Mude de nivel profundamente e avance entre as pernas',
          'Coloque seu ombro nos quadris do oponente',
          'Agarre atras de ambos os joelhos',
          'Empurre para frente e para cima para levantar e derrubar',
        ],
      },
      relatedTechniqueIds: ['single_leg', 'takedown', 'level_change'],
    ),

    'clinch_break': TechniqueGuide(
      techniqueId: 'clinch_break',
      description: {
        'en': 'Breaking the clinch separates you from an opponent who has closed the distance. Frame with the arms, push away, and create space.',
        'es': 'Romper el clinch te separa de un oponente que ha cerrado la distancia. Enmarca con los brazos, empuja y crea espacio.',
        'pt': 'Quebrar o clinch te separa de um oponente que fechou a distancia. Enquadre com os bracos, empurre e crie espaco.',
      },
      formPoints: {
        'en': [
          'Frame with your forearms against the opponent\'s chest or neck',
          'Push off and create distance with your legs',
          'Be ready to strike immediately as you break',
          'Do not turn your back during the break',
        ],
        'es': [
          'Enmarca con tus antebrazos contra el pecho o cuello del oponente',
          'Empuja y crea distancia con tus piernas',
          'Preparate para golpear inmediatamente al romper',
          'No des la espalda durante la ruptura',
        ],
        'pt': [
          'Enquadre com seus antebracos contra o peito ou pescoco do oponente',
          'Empurre e crie distancia com suas pernas',
          'Esteja pronto para golpear imediatamente ao quebrar',
          'Nao de as costas durante a quebra',
        ],
      },
      relatedTechniqueIds: ['clinch', 'teep'],
    ),

    'shot': TechniqueGuide(
      techniqueId: 'shot',
      description: {
        'en': 'Shooting is the explosive entry into a takedown with a deep penetration step and level change. The foundation of offensive wrestling.',
        'es': 'La entrada es la entrada explosiva a un derribo con un paso de penetracion profunda y cambio de nivel. La base de la lucha ofensiva.',
        'pt': 'A entrada e a entrada explosiva para uma queda com um passo de penetracao profunda e mudanca de nivel. A base da luta ofensiva.',
      },
      formPoints: {
        'en': [
          'Change levels explosively before the shot',
          'Take a deep penetration step with the lead knee',
          'Keep the head up and back straight',
          'Drive off the back foot for explosive forward movement',
        ],
        'es': [
          'Cambia de nivel explosivamente antes de la entrada',
          'Da un paso de penetracion profunda con la rodilla delantera',
          'Manten la cabeza arriba y la espalda recta',
          'Impulsa desde el pie trasero para movimiento explosivo',
        ],
        'pt': [
          'Mude de nivel explosivamente antes da entrada',
          'De um passo de penetracao profunda com o joelho da frente',
          'Mantenha a cabeca levantada e as costas retas',
          'Impulsione a partir do pe de tras para movimento explosivo',
        ],
      },
      relatedTechniqueIds: ['single_leg', 'double_leg', 'level_change'],
    ),

    'snap_down': TechniqueGuide(
      techniqueId: 'snap_down',
      description: {
        'en': 'The snap down pulls the opponent\'s head downward, breaking their posture and setting up front headlocks, go-behinds, or attacks.',
        'es': 'El snap down jala la cabeza del oponente hacia abajo, rompiendo su postura y preparando guillotinas frontales, ir por detras u otros ataques.',
        'pt': 'O snap down puxa a cabeca do oponente para baixo, quebrando a postura e preparando guilhotinas frontais, ir por tras ou ataques.',
      },
      formPoints: {
        'en': [
          'Grab the back of the neck or head',
          'Pull sharply downward while stepping back',
          'Follow up immediately — do not let them recover posture',
          'Circle to the side for a go-behind or front headlock',
        ],
        'es': [
          'Agarra la parte trasera del cuello o cabeza',
          'Jala bruscamente hacia abajo mientras retrocedes',
          'Da seguimiento inmediatamente — no los dejes recuperar postura',
          'Circula al lado para ir por detras o guillotina frontal',
        ],
        'pt': [
          'Agarre a parte de tras do pescoco ou cabeca',
          'Puxe bruscamente para baixo enquanto recua',
          'De seguimento imediatamente — nao os deixe recuperar postura',
          'Circule para o lado para ir por tras ou guilhotina frontal',
        ],
      },
      relatedTechniqueIds: ['front_headlock', 'arm_drag', 'shot'],
    ),

    'duck_under': TechniqueGuide(
      techniqueId: 'duck_under',
      description: {
        'en': 'The duck under moves beneath the opponent\'s arm to get behind them. Low-risk technique for gaining back control without shooting.',
        'es': 'Pasar por debajo se mueve debajo del brazo del oponente para llegar por detras. Tecnica de bajo riesgo para ganar control de la espalda sin atacar.',
        'pt': 'Passar por baixo move-se por baixo do braco do oponente para chegar por tras. Tecnica de baixo risco para ganhar controle das costas sem atacar.',
      },
      formPoints: {
        'en': [
          'Clear the opponent\'s hand from your neck or collar',
          'Dip your head under their arm',
          'Step through and behind in one motion',
          'Lock your hands around the waist for the go-behind',
        ],
        'es': [
          'Despeja la mano del oponente de tu cuello o collar',
          'Mete la cabeza debajo de su brazo',
          'Da un paso a traves y detras en un solo movimiento',
          'Cierra tus manos alrededor de la cintura para ir por detras',
        ],
        'pt': [
          'Limpe a mao do oponente do seu pescoco ou gola',
          'Mergulhe a cabeca por baixo do braco dele',
          'De um passo atraves e por tras em um so movimento',
          'Feche suas maos ao redor da cintura para ir por tras',
        ],
      },
      relatedTechniqueIds: ['arm_drag', 'snap_down', 'takedown'],
    ),

    'front_headlock': TechniqueGuide(
      techniqueId: 'front_headlock',
      description: {
        'en': 'The front headlock controls the opponent\'s head and arm from the front, typically after a sprawl or snap down. Leads to chokes, go-behinds, and takedowns.',
        'es': 'La guillotina frontal controla la cabeza y brazo del oponente desde el frente, tipicamente despues de un sprawl o snap down. Lleva a estrangulaciones, ir por detras y derribos.',
        'pt': 'A guilhotina frontal controla a cabeca e braco do oponente pela frente, tipicamente apos um sprawl ou snap down. Leva a estrangulamentos, ir por tras e quedas.',
      },
      formPoints: {
        'en': [
          'Wrap one arm around the head, the other controls the arm',
          'Keep your hips heavy on the opponent',
          'Circle to the side to break their base',
          'Attack guillotine, anaconda, or go-behind',
        ],
        'es': [
          'Envuelve un brazo alrededor de la cabeza, el otro controla el brazo',
          'Manten tus caderas pesadas sobre el oponente',
          'Circula al lado para romper su base',
          'Ataca guillotina, anaconda o ir por detras',
        ],
        'pt': [
          'Envolva um braco ao redor da cabeca, o outro controla o braco',
          'Mantenha seus quadris pesados sobre o oponente',
          'Circule para o lado para quebrar a base',
          'Ataque guilhotina, anaconda ou ir por tras',
        ],
      },
      relatedTechniqueIds: ['sprawl', 'snap_down', 'takedown'],
    ),

    'stand_up': TechniqueGuide(
      techniqueId: 'stand_up',
      description: {
        'en': 'The technical stand-up returns you to your feet from bottom position using proper base and hand positioning to stand safely.',
        'es': 'La levantada tecnica te regresa a tus pies desde la posicion de abajo usando base y posicionamiento de manos adecuados para levantarte de forma segura.',
        'pt': 'A levantada tecnica te retorna aos pes a partir da posicao de baixo usando base e posicionamento de maos adequados para levantar com seguranca.',
      },
      formPoints: {
        'en': [
          'Post one hand on the mat behind you',
          'Clear the opponent\'s hands from your legs',
          'Base up to one foot and stand explosively',
          'Turn to face the opponent as you stand',
        ],
        'es': [
          'Apoya una mano en la lona detras de ti',
          'Despeja las manos del oponente de tus piernas',
          'Apoyate en un pie y levantate explosivamente',
          'Gira para enfrentar al oponente mientras te levantas',
        ],
        'pt': [
          'Apoie uma mao no chao atras de voce',
          'Limpe as maos do oponente das suas pernas',
          'Apoie-se em um pe e levante-se explosivamente',
          'Vire para enfrentar o oponente enquanto se levanta',
        ],
      },
      relatedTechniqueIds: ['sit_out', 'switch_wr'],
    ),

    'switch_wr': TechniqueGuide(
      techniqueId: 'switch_wr',
      description: {
        'en': 'The switch is a bottom-position escape where you reverse the position by stepping behind the opponent who has your waist.',
        'es': 'El switch es un escape desde abajo donde inviertes la posicion dando un paso detras del oponente que tiene tu cintura.',
        'pt': 'O switch e um escape de baixo onde voce inverte a posicao dando um passo atras do oponente que tem sua cintura.',
      },
      formPoints: {
        'en': [
          'Reach back and grab the opponent\'s far arm',
          'Step your far leg behind the opponent',
          'Turn and face the opponent to complete the reversal',
          'Immediately secure the position after the switch',
        ],
        'es': [
          'Estira hacia atras y agarra el brazo lejano del oponente',
          'Da un paso con la pierna lejana detras del oponente',
          'Gira y enfrenta al oponente para completar la reversion',
          'Asegura la posicion inmediatamente despues del switch',
        ],
        'pt': [
          'Estenda para tras e agarre o braco distante do oponente',
          'De um passo com a perna distante atras do oponente',
          'Vire e enfrente o oponente para completar a reversao',
          'Assegure a posicao imediatamente apos o switch',
        ],
      },
      relatedTechniqueIds: ['sit_out', 'stand_up'],
    ),

    'sit_out': TechniqueGuide(
      techniqueId: 'sit_out',
      description: {
        'en': 'The sit-out is a bottom-position escape where you sit through to the outside, clearing the opponent\'s grip and turning to face them.',
        'es': 'La salida lateral es un escape de abajo donde te sientas hacia el exterior, liberando el agarre del oponente y girando para enfrentarlos.',
        'pt': 'A saida lateral e um escape de baixo onde voce senta para o exterior, liberando o agarre do oponente e virando para enfrenta-lo.',
      },
      formPoints: {
        'en': [
          'Clear the opponent\'s arm from around your waist',
          'Sit your hips out to the side and turn',
          'Use your hand on the mat for base',
          'Face the opponent as you complete the escape',
        ],
        'es': [
          'Despeja el brazo del oponente de alrededor de tu cintura',
          'Sienta tus caderas hacia el lado y gira',
          'Usa tu mano en la lona para base',
          'Enfrenta al oponente al completar el escape',
        ],
        'pt': [
          'Limpe o braco do oponente de ao redor da sua cintura',
          'Sente seus quadris para o lado e vire',
          'Use sua mao no chao para base',
          'Enfrente o oponente ao completar o escape',
        ],
      },
      relatedTechniqueIds: ['switch_wr', 'stand_up'],
    ),

    'ankle_pick': TechniqueGuide(
      techniqueId: 'ankle_pick',
      description: {
        'en': 'The ankle pick is a quick, low-effort takedown where you grab the ankle while pushing the opponent\'s head or shoulder to off-balance them.',
        'es': 'El ankle pick es un derribo rapido y de bajo esfuerzo donde agarras el tobillo mientras empujas la cabeza u hombro para desequilibrar.',
        'pt': 'O ankle pick e uma queda rapida e de baixo esforco onde voce agarra o tornozelo enquanto empurra a cabeca ou ombro para desequilibrar.',
      },
      formPoints: {
        'en': [
          'Push the opponent\'s head or shoulder to one side',
          'Reach down and grab the opposite ankle',
          'Pull the ankle toward you as you push the upper body away',
          'Follow the opponent to the mat for top position',
        ],
        'es': [
          'Empuja la cabeza u hombro del oponente a un lado',
          'Baja y agarra el tobillo opuesto',
          'Jala el tobillo hacia ti mientras empujas el cuerpo superior',
          'Sigue al oponente a la lona para posicion arriba',
        ],
        'pt': [
          'Empurre a cabeca ou ombro do oponente para um lado',
          'Abaixe e agarre o tornozelo oposto',
          'Puxe o tornozelo em sua direcao enquanto empurra o corpo superior',
          'Siga o oponente ao chao para posicao por cima',
        ],
      },
      relatedTechniqueIds: ['single_leg', 'snap_down'],
    ),

    'arm_drag': TechniqueGuide(
      techniqueId: 'arm_drag',
      description: {
        'en': 'The arm drag pulls the opponent\'s arm across their body to expose their back. One of the most versatile techniques in wrestling and BJJ.',
        'es': 'El arrastre de brazo jala el brazo del oponente a traves de su cuerpo para exponer su espalda. Una de las tecnicas mas versatiles en lucha y BJJ.',
        'pt': 'O arrasto de braco puxa o braco do oponente atraves do corpo para expor as costas. Uma das tecnicas mais versateis na luta e BJJ.',
      },
      formPoints: {
        'en': [
          'Grab the opponent\'s wrist and tricep',
          'Pull their arm across your body in one sharp motion',
          'Step to the side as you pull to get behind them',
          'Follow up with a go-behind, single leg, or back take',
        ],
        'es': [
          'Agarra la muneca y tricep del oponente',
          'Jala su brazo a traves de tu cuerpo en un movimiento brusco',
          'Da un paso al lado mientras jalas para llegar por detras',
          'Da seguimiento con ir por detras, una pierna o tomar la espalda',
        ],
        'pt': [
          'Agarre o pulso e tricep do oponente',
          'Puxe o braco atraves do seu corpo em um movimento brusco',
          'De um passo para o lado enquanto puxa para chegar por tras',
          'De seguimento com ir por tras, uma perna ou pegar as costas',
        ],
      },
      relatedTechniqueIds: ['duck_under', 'single_leg', 'snap_down'],
    ),
  };
}
