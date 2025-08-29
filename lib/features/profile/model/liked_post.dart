class LikedPost {
  final String id;
  final String vehicle;
  final String city;
  final DateTime likedAt;
  final String imageUrl;
  final String postLink;

  const LikedPost({
    required this.id,
    required this.vehicle,
    required this.city,
    required this.likedAt,
    required this.imageUrl,
    required this.postLink,
  });
}
