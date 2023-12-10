class UserData {
  late final int ID;
  final String Username;
  final bool IsAdmin;

  UserData(this.ID, this.Username,this.IsAdmin);

  UserData.fromMap(Map<String, dynamic> item)
      : ID = item["ID"],
        Username = item["Username"],
        IsAdmin = item["IsAdmin"];

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'Username': Username,
      'IsAdmin': IsAdmin
    };
  }
}