class UserModel {
  String multicast_id;
  String success;
  String failure;
  String canonical_ids;
  List<Results> results;

  UserModel(
      {required this.multicast_id,
       required this.success,
       required this.failure,
       required this.canonical_ids,
       required this.results});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var data = json['results'] as List;
    List<Results> resultList = data.map((e) => Results.fromJson(e)).toList();

    return UserModel(
      multicast_id: json['multicast_id'].toString(),
      success: json['success'].toString(),
      failure: json['failure'].toString(),
      canonical_ids: json['canonical_ids'].toString(),
      results: resultList,
    );
  }
}

class Results {
  String message_id;

  Results({required this.message_id});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      message_id: json['message_id'].toString(),
    );
  }
}

class UserData {
  String name;
  String token;

  UserData({required this.name, required this.token});
}
