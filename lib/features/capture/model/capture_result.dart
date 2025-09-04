import 'package:mobile_app/core/widgets/rarity.dart' as ds;

/// Parse un String (backend) vers l'enum Rarity du design system.
ds.Rarity _rarityFrom(dynamic v) {
  final s = (v as String?)?.toLowerCase();
  switch (s) {
    case 'rare': return ds.Rarity.rare;
    case 'epic': return ds.Rarity.epic;
    case 'legendary': return ds.Rarity.legendary;
    case 'common':
    default: return ds.Rarity.common;
  }
}

/// Représente le résultat renvoyé après /posts (immédiat)
/// et enrichi avec les infos IA après polling.
class CaptureResult {
  final bool newForUser;
  final ds.Rarity rarity;
  final String vehicleName;
  final int  xpGained;

  /// Renseignées après polling /v1/posts/{id}
  final String? processedUrl;
  final List<String>? tags;                    // top tags IA
  final Map<String, dynamic>? ai;              // payload IA brut
  final String? vehicleMake;
  final String? vehicleModel;

  const CaptureResult({
    required this.newForUser,
    required this.rarity,
    required this.vehicleName,
    required this.xpGained,
    this.processedUrl,
    this.tags,
    this.ai,
    this.vehicleMake,
    this.vehicleModel,
  });

  factory CaptureResult.fromJson(Map<String, dynamic> json) {
    return CaptureResult(
      newForUser: json['new_for_user'] as bool? ?? false,
      rarity: _rarityFrom(json['rarity']),
      vehicleName: json['vehicle_name'] as String? ?? 'Unknown vehicle',
      xpGained: (json['xp_gained'] as num?)?.toInt() ?? 0,
      processedUrl: json['processed_url'] as String?,
      tags: (json['tags'] as List?)?.cast<String>(),
      ai: json['ai'] as Map<String, dynamic>?,
      vehicleMake: json['vehicle_make'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'new_for_user': newForUser,
    'rarity': rarity.name,
    'vehicle_name': vehicleName,
    'xp_gained': xpGained,
    if (processedUrl != null) 'processed_url': processedUrl,
    if (tags != null) 'tags': tags,
    if (ai != null) 'ai': ai,
    if (vehicleMake != null) 'vehicle_make': vehicleMake,
    if (vehicleModel != null) 'vehicle_model': vehicleModel,
  };

  CaptureResult copyWith({
    bool? newForUser,
    ds.Rarity? rarity,
    String? vehicleName,
    int? xpGained,
    String? processedUrl,
    List<String>? tags,
    Map<String, dynamic>? ai,
    String? vehicleMake,
    String? vehicleModel,
  }) {
    return CaptureResult(
      newForUser: newForUser ?? this.newForUser,
      rarity: rarity ?? this.rarity,
      vehicleName: vehicleName ?? this.vehicleName,
      xpGained: xpGained ?? this.xpGained,
      processedUrl: processedUrl ?? this.processedUrl,
      tags: tags ?? this.tags,
      ai: ai ?? this.ai,
      vehicleMake: vehicleMake ?? this.vehicleMake,
      vehicleModel: vehicleModel ?? this.vehicleModel,
    );
  }
}
