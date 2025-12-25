class AlbumModel {
  int? id;
  int? memberId;
  int? year;
  int? month;
  String? status;
  DateTime? submittedDate;
  String? note;
  String? createBy;
  String? updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  List<PhotoModel>? photos;

  AlbumModel({this.id, this.memberId, this.year, this.month, this.status, this.submittedDate, this.note, this.createBy, this.updateBy, this.createdAt, this.updatedAt, this.deletedAt, this.photos});

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      memberId: json['member_id'],
      year: json['year'],
      month: json['month'],
      status: json['status'],
      submittedDate: json['submitted_date'] != null ? DateTime.tryParse(json['submitted_date']) : null,
      note: json['note'],
      createBy: json['create_by'],
      updateBy: json['update_by'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      photos: json['photos'] != null ? (json['photos'] as List).map((i) => PhotoModel.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'year': year,
      'month': month,
      'status': status,
      'submitted_date': submittedDate?.toIso8601String(),
      'note': note,
      'create_by': createBy,
      'update_by': updateBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'photos': photos?.map((v) => v.toJson()).toList(),
    };
  }
}

class PhotoModel {
  int? id;
  int? albumMonthId;
  int? seq;
  String? image;
  String? caption;
  String? imageOriginal;
  String? imageCropped;
  String? fileSize; // JSON เป็น null แต่เผื่อไว้เป็น String หรือ int ก็ได้
  int? width;
  int? height;
  int? isActive;
  String? createBy;
  String? updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  PhotoModel({
    this.id,
    this.albumMonthId,
    this.seq,
    this.image,
    this.caption,
    this.imageOriginal,
    this.imageCropped,
    this.fileSize,
    this.width,
    this.height,
    this.isActive,
    this.createBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      albumMonthId: json['album_month_id'],
      seq: json['seq'],
      image: json['image'],
      caption: json['caption'],
      imageOriginal: json['image_original'],
      imageCropped: json['image_cropped'],
      fileSize: json['file_size']?.toString(), // แปลงเป็น String เผื่อ JSON มาเป็นตัวเลข
      width: json['width'],
      height: json['height'],
      isActive: json['is_active'],
      createBy: json['create_by'],
      updateBy: json['update_by'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'album_month_id': albumMonthId,
      'seq': seq,
      'image': image,
      'caption': caption,
      'image_original': imageOriginal,
      'image_cropped': imageCropped,
      'file_size': fileSize,
      'width': width,
      'height': height,
      'is_active': isActive,
      'create_by': createBy,
      'update_by': updateBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}


