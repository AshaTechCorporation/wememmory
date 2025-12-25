class PhotoItem {
  int? seq;
  String? image;
  String? caption;

  PhotoItem({
    this.seq,
    this.image,
    this.caption,
  });

  // แปลง JSON จาก Server เป็น Object (เผื่อใช้รับค่ากลับ)
  factory PhotoItem.fromJson(Map<String, dynamic> json) {
    return PhotoItem(
      seq: json['seq'],
      image: json['image'],
      caption: json['caption'],
    );
  }

  // แปลง Object เป็น JSON เพื่อส่งไป API
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'seq': seq,
      'image': image,
    };

    // ใส่ caption เฉพาะถ้ามีค่า (ไม่ null)
    if (caption != null) {
      data['caption'] = caption;
    }

    return data;
  }
}