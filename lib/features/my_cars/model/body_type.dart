// package:mobile_app/features/my_cars/model/body_type.dart
enum BodyType { sedan, suv, pickup, coupe, hatchback, wagon, van, motorcycle, other }

extension BodyTypeX on BodyType {
  String get label {
    switch (this) {
      case BodyType.sedan: return 'Sedan';
      case BodyType.suv: return 'SUV';
      case BodyType.pickup: return 'Pickup';
      case BodyType.coupe: return 'Coupe';
      case BodyType.hatchback: return 'Hatchback';
      case BodyType.wagon: return 'Wagon';
      case BodyType.van: return 'Van';
      case BodyType.motorcycle: return 'Motorcycle';
      case BodyType.other: return 'Other';
    }
  }
}
