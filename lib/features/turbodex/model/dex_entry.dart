import 'package:mobile_app/core/widgets/rarity.dart';
import 'dex_status.dart';

class DexEntry {
  final int number;
  final Rarity rarity;
  final DexStatus status;
  final String? genericImageUrl;
  final String? make;
  final String? model;

  const DexEntry({
    required this.number,
    required this.rarity,
    required this.status,
    this.genericImageUrl,
    this.make,
    this.model,
  });
}