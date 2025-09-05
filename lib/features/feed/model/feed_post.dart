import '../../../core/widgets/rarity.dart' as ds;

class FeedUser {
  final String id;
  final String name;
  final String? avatarUrl;
  const FeedUser({required this.id, required this.name, this.avatarUrl});

  factory FeedUser.fromJson(Map<String, dynamic> j) => FeedUser(
    id: j['id'] as String,
    name: j['name'] as String? ?? 'Unknown',
    avatarUrl: j['avatar_url'] as String?,
  );
}

class FeedPost {
  final String id;
  final FeedUser user;
  final String imageUrl;           // URL de l’image capturée (blob)
  final ds.Rarity rarity;          // réutilise DS
  final DateTime takenAt;          // quand la photo a été prise
  final String? city;
  final String? country;
  final String make;
  final String model;
  final int likesCount;
  final bool likedByMe;

  const FeedPost({
    required this.id,
    required this.user,
    required this.imageUrl,
    required this.rarity,
    required this.takenAt,
    required this.make,
    required this.model,
    this.city,
    this.country,
    this.likesCount = 0,
    this.likedByMe = false,
  });

  static ds.Rarity _rarityFrom(dynamic v) {
    if (v is String) {
      switch (v.toLowerCase()) {
        case 'rare': return ds.Rarity.rare;
        case 'epic': return ds.Rarity.epic;
        case 'legendary': return ds.Rarity.legendary;
      }
    } else if (v is num) {
      switch (v.toInt()) {
        case 1: return ds.Rarity.rare;
        case 2: return ds.Rarity.epic;
        case 3: return ds.Rarity.legendary;
      }
    }
    return ds.Rarity.common;
  }

  factory FeedPost.fromJson(Map<String, dynamic> j) => FeedPost(
    id: j['id'] as String,
    user: FeedUser.fromJson(j['user'] as Map<String, dynamic>),
    imageUrl: j['image_url'] as String,
    rarity: _rarityFrom(j['rarity']),
    takenAt: DateTime.tryParse(j['taken_at'] as String? ?? '') ?? DateTime.now(),
    city: j['city'] as String?,
    country: j['country'] as String?,
    make: j['make'] as String? ?? 'Unknown',
    model: j['model'] as String? ?? 'Unknown',
    likesCount: (j['likes_count'] as num?)?.toInt() ?? 0,
    likedByMe: j['liked_by_me'] as bool? ?? false,
  );

  FeedPost copyWith({int? likesCount, bool? likedByMe}) => FeedPost(
    id: id,
    user: user,
    imageUrl: imageUrl,
    rarity: rarity,
    takenAt: takenAt,
    city: city,
    country: country,
    make: make,
    model: model,
    likesCount: likesCount ?? this.likesCount,
    likedByMe: likedByMe ?? this.likedByMe,
  );
}
