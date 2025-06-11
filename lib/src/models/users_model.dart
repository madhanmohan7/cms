class User {
  int? userId;
  String? name;
  String? email;
  String? username;
  String? passwordHash;
  String? role;
  String? phoneNumber;
  int? organizationId;
  String? organizationName;


  User({
    this.userId,
    this.name,
    this.email,
    this.username,
    this.passwordHash,
    this.role,
    this.phoneNumber,
    this.organizationId,
    this.organizationName,
  });

  String get getPassword => passwordHash!;

  set setPassword(String value) {
    passwordHash = value;
  }


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      // passwordHash: json['password_hash'],
      passwordHash: '',
      role: json['role'],
      phoneNumber: json['phone_number'],
      organizationId: json['organization_id'],
      organizationName: json['organization_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['password_hash'] = passwordHash;
    data['role'] = role;
    data['phone_number'] = phoneNumber;
    data['organization_id'] = organizationId;
    data['organization_name'] = organizationName;
    return data;
  }
}
