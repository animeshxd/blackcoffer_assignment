import 'dart:convert';


class XUser {
  final String username;
  final String uid;
  final String fullName;

  const XUser({
    required this.username,
    required this.uid,
    required this.fullName,
  });



  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'fullName': fullName,
    };
  }

  factory XUser.fromMap(Map<String, dynamic> map) {
    return XUser(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory XUser.fromJson(String source) => XUser.fromMap(json.decode(source));
}
