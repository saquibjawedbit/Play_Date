class ResultModel {
  final String? id;
  final int count;
  final List<Player> matches;

  ResultModel({required this.id, required this.matches, required this.count});

  factory ResultModel.fromJson(Map<String, dynamic> json, {String? id}) {
    var matchesJson = json["matches"] as List;
    List<Player> matchesList = matchesJson
        .map((i) => Player.fromJson(i as Map<String, dynamic>))
        .toList();

    return ResultModel(
      id: id,
      count: json['players'],
      matches: matchesList,
    );
  }
}

class Player {
  final String? maleId;
  final String? femaleId;
  final int score;

  Player({required this.femaleId, required this.maleId, required this.score});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      maleId: json['maleUserId'] as String,
      femaleId: (json['femaleUserId']),
      score: json['point'] as int,
    );
  }
}
