class ActiveUsersModel {
  String? id;
  String? name;
  int? mobile;
  List<int>? alternateMobile;
  int? createdOn;
  int? lastLogin;
  bool? isActive;
  String? roleId;
  String? roleName;

  ActiveUsersModel(
      {this.id,
      this.name,
      this.mobile,
      this.alternateMobile,
      this.createdOn,
      this.lastLogin,
      this.isActive,
      this.roleId,
      this.roleName});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobile': mobile,
      "isActive": isActive,
      "createdOn": createdOn,
      "lastLogin": lastLogin,
      "alternateMobile": alternateMobile,
      "roleName": roleName,
    };
  }

  factory ActiveUsersModel.fromMap(Map<String, dynamic> json) {
    return ActiveUsersModel(
      id: json['_id'],
      name: json['name'],
      mobile: json['mobile'],
      isActive: json["isActive"],
      createdOn: json['createdOn'],
      lastLogin: json['lastLogin'],
      alternateMobile: List<int>.from(json['alternateMobile'] ?? []),
      roleId: json['roleId']['_id'],
      roleName: json['roleId']['roleName'],
    );
  }

  ActiveUsersModel copyWith({
    String? id,
    String? name,
    int? mobile,
    List<int>? alternateMobile,
    int? createdOn,
    int? lastLogin,
    bool? isActive,
    String? roleId,
    String? roleName,
  }) {
    return ActiveUsersModel(
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        alternateMobile: alternateMobile ?? this.alternateMobile,
        createdOn: createdOn ?? this.createdOn,
        lastLogin: lastLogin ?? this.lastLogin,
        isActive: isActive ?? this.isActive,
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName);
  }
}
