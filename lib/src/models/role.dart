class Role {
  String id;
  String name;
  String guardName;

  Role();

  Role.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] ?? '';
      guardName = jsonMap['guard_name'] ?? '';
    } catch (e) {
      id = '';
      name = '';
      guardName = '';
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
    };
  }
}
