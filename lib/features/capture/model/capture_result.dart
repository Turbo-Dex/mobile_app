import '../../../core/widgets/rarity.dart' as ds;

/// Résultat renvoyé par l’API après création du post.
/// On réutilise l'enum `Rarity` de votre DS (rarity.dart).
class CaptureResult {
  final bool newForUser;
  final ds.Rarity rarity;
  final String vehicleName;
  final int xpGained;

  const CaptureResult({
    required this.newForUser,
    required this.rarity,
    required this.vehicleName,
    required this.xpGained,
  });

  /// Mappe la valeur API -> enum DS (supporte string/number).
  static ds.Rarity _rarityFrom(dynamic v) {
    if (v is String) {
      switch (v.toLowerCase()) {
        case 'rare':
          return ds.Rarity.rare;
        case 'epic':
          return ds.Rarity.epic;
        case 'legendary':
          return ds.Rarity.legendary;
        default:
          return ds.Rarity.common;
      }
    }
    if (v is num) {
      switch (v.toInt()) {
        case 1:
          return ds.Rarity.rare;
        case 2:
          return ds.Rarity.epic;
        case 3:
          return ds.Rarity.legendary;
        default:
          return ds.Rarity.common;
      }
    }
    return ds.Rarity.common;
  }

  factory CaptureResult.fromJson(Map<String, dynamic> j) => CaptureResult(
    newForUser: j['new_for_user'] as bool? ?? false,
    rarity: _rarityFrom(j['rarity']),
    vehicleName: j['vehicle_name'] as String? ?? 'Unknown vehicle',
    xpGained: (j['xp_gained'] as num?)?.toInt() ?? 0,
  );
}
