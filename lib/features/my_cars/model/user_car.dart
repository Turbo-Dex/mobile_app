import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/features/my_cars/model/body_type.dart';

class UserCar {
  final String id;
  final String brandName;
  final String modelName;
  final String imageUrl;                // photo réelle capturée
  final DateTime capturedAt;
  final Rarity rarity;

  final BodyType? bodyType;
  final String? colorName;
  final String? city;
  final String? country;
  final String? modelShortDescription;  // description courte du modèle (DB)

  const UserCar({
    required this.id,
    required this.brandName,
    required this.modelName,
    required this.imageUrl,
    required this.capturedAt,
    required this.rarity,
    this.bodyType,
    this.colorName,
    this.city,
    this.country,
    this.modelShortDescription,
  });

  String get cityCountryLabel {
    if ((city ?? '').isEmpty && (country ?? '').isEmpty) return '';
    if ((city ?? '').isEmpty) return country!;
    if ((country ?? '').isEmpty) return city!;
    return '$city, $country';
  }

  factory UserCar.fromJson(Map<String, dynamic> j) {
    return UserCar(
      id: j['id'] as String,
      brandName: j['brandName'] as String,
      modelName: j['modelName'] as String,
      imageUrl: j['imageUrl'] as String,
      capturedAt: DateTime.parse(j['capturedAt'] as String),
      rarity: _rarityFrom(j['rarity'] as String),
      bodyType: _bodyFrom(j['bodyType'] as String?),
      colorName: j['colorName'] as String?,
      city: j['city'] as String?,
      country: j['country'] as String?,
      modelShortDescription: j['modelShortDescription'] as String?,
    );
  }

  static Rarity _rarityFrom(String s) {
    switch (s.toLowerCase()) {
      case 'rare':
        return Rarity.rare;
      case 'epic':
        return Rarity.epic;
      case 'legendary':
        return Rarity.legendary;
      default:
        return Rarity.common;
    }
  }

  static BodyType? _bodyFrom(String? s) {
    switch (s?.toLowerCase()) {
      case 'sedan':
        return BodyType.sedan;
      case 'suv':
        return BodyType.suv;
      case 'pickup':
        return BodyType.pickup;
      case 'coupe':
        return BodyType.coupe;
      default:
        return null;
    }
  }
}
