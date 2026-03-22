/// Entitlement status representing which premium features the user owns.
///
/// Plain Dart class (not Freezed — no code-gen overhead needed).
/// Used by the entitlement system to drive UI locking and graceful degradation.
class EntitlementStatus {
  final bool adsRemoved;
  final bool comboPack; // $3.99
  final bool programsPack; // $4.99 (future)
  final Map<String, bool> sportPacks; // per-sport (future)
  final bool everythingBundle; // $9.99 (future)

  const EntitlementStatus({
    this.adsRemoved = false,
    this.comboPack = false,
    this.programsPack = false,
    this.sportPacks = const {},
    this.everythingBundle = false,
  });

  // Derived accessors
  bool get hasComboAccess => comboPack || everythingBundle;
  bool get hasProgramsAccess => programsPack || everythingBundle;
  bool sportPackOwned(String sportId) =>
      (sportPacks[sportId] ?? false) || everythingBundle;
  bool get hasAnyPremium =>
      adsRemoved ||
      comboPack ||
      programsPack ||
      sportPacks.values.any((v) => v) ||
      everythingBundle;

  EntitlementStatus copyWith({
    bool? adsRemoved,
    bool? comboPack,
    bool? programsPack,
    Map<String, bool>? sportPacks,
    bool? everythingBundle,
  }) {
    return EntitlementStatus(
      adsRemoved: adsRemoved ?? this.adsRemoved,
      comboPack: comboPack ?? this.comboPack,
      programsPack: programsPack ?? this.programsPack,
      sportPacks: sportPacks ?? this.sportPacks,
      everythingBundle: everythingBundle ?? this.everythingBundle,
    );
  }

  Map<String, dynamic> toJson() => {
    'adsRemoved': adsRemoved,
    'comboPack': comboPack,
    'programsPack': programsPack,
    'sportPacks': sportPacks,
    'everythingBundle': everythingBundle,
  };

  factory EntitlementStatus.fromJson(Map<String, dynamic> json) {
    return EntitlementStatus(
      adsRemoved: json['adsRemoved'] as bool? ?? false,
      comboPack: json['comboPack'] as bool? ?? false,
      programsPack: json['programsPack'] as bool? ?? false,
      sportPacks: (json['sportPacks'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as bool)) ??
          const {},
      everythingBundle: json['everythingBundle'] as bool? ?? false,
    );
  }

  static const empty = EntitlementStatus();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntitlementStatus &&
          adsRemoved == other.adsRemoved &&
          comboPack == other.comboPack &&
          programsPack == other.programsPack &&
          everythingBundle == other.everythingBundle;

  @override
  int get hashCode =>
      Object.hash(adsRemoved, comboPack, programsPack, everythingBundle);
}
