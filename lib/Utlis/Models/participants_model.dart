class ParticipantModels {
  final String userId;
  final String userName;
  final String imageUrl;
  final int points;
  final int rank;

  const ParticipantModels({
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.points,
    required this.rank,
  });
}
