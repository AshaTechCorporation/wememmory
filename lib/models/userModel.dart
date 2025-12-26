class UserModel {
  final int? id;
  final String? code;
  final String? fullName;
  final String? username;
  final String? phone;
  final String? avatar;
  final String? language;
  final String? email;
  final String? facebook;
  final String? lineId;
  final String? apple;
  final String? createBy;
  final String? updateBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserModel({
    this.id,
    this.code,
    this.fullName,
    this.username,
    this.phone,
    this.avatar,
    this.language,
    this.email,
    this.facebook,
    this.lineId,
    this.apple,
    this.createBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      code: json['code'],
      fullName: json['full_name'], // map จาก full_name
      username: json['username'],
      phone: json['phone'],
      // password ปกติเราจะไม่เก็บไว้ใน Model เพื่อความปลอดภัย แต่ถ้าจำเป็นก็เพิ่มได้
      avatar: json['avatar'],
      language: json['language'],
      email: json['email'],
      facebook: json['facebook'],
      lineId: json['line_id'], // map จาก line_id
      apple: json['apple'],
      createBy: json['create_by'], // map จาก create_by
      updateBy: json['update_by'], // map จาก update_by
      
      // แปลง String เป็น DateTime
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
    );
  }

  // เผื่อต้องการแปลงกลับเป็น JSON เพื่อส่งไป API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'full_name': fullName,
      'username': username,
      'phone': phone,
      'avatar': avatar,
      'language': language,
      'email': email,
      'facebook': facebook,
      'line_id': lineId,
      'apple': apple,
      'create_by': createBy,
      'update_by': updateBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}