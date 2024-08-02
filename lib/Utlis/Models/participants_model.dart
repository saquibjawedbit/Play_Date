class ParticipantModel {
  final String id;
  final String gender;
  final String address;
  final List<int> round1;
  final List<int> round2;
  final List<int> round3;

  const ParticipantModel({
    required this.id,
    required this.address,
    required this.gender,
    required this.round1,
    required this.round2,
    required this.round3,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'gender': gender,
      'round1': round1,
      'round2': round2,
      'round3': round3,
    };
  }

  factory ParticipantModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ParticipantModel(
      id: json['uid'],
      address: json['address'],
      gender: json['gender'],
      round1: json['round1'] as List<int>,
      round2: json['round2'] as List<int>,
      round3: json['round3'] as List<int>,
    );
  }
}
