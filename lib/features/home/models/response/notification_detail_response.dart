// Main Response Model
class NotificationDetailResponse {
  final String status;
  final NotificationDetailData data;

  NotificationDetailResponse({required this.status, required this.data});

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailResponse(
      status: json['status'] as String,
      data: NotificationDetailData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}

// Data Model
class NotificationDetailData {
  final NotificationDetail notification;

  NotificationDetailData({required this.notification});

  factory NotificationDetailData.fromJson(Map<String, dynamic> json) {
    return NotificationDetailData(
      notification: NotificationDetail.fromJson(
        json['notification'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'notification': notification.toJson()};
  }
}

// Individual Notification Model
class NotificationDetail {
  final String id;
  final String recipient;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationDetail({
    required this.id,
    required this.recipient,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      id: json['_id'] as String,
      recipient: json['recipient'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      version: json['__v'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipient': recipient,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      '__v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy method for immutability
  NotificationDetail copyWith({
    String? id,
    String? recipient,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationDetail(
      id: id ?? this.id,
      recipient: recipient ?? this.recipient,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NotificationDetail(id: $id, title: $title, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationDetail &&
        other.id == id &&
        other.recipient == recipient &&
        other.title == title &&
        other.message == message &&
        other.type == type &&
        other.isRead == isRead &&
        other.version == version &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        recipient.hashCode ^
        title.hashCode ^
        message.hashCode ^
        type.hashCode ^
        isRead.hashCode ^
        version.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
