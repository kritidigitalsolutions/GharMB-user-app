// Main Response Model
class NotificationResponse {
  final String status;
  final int results;
  final NotificationData data;

  NotificationResponse({
    required this.status,
    required this.results,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'] as String,
      results: json['results'] as int,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'results': results, 'data': data.toJson()};
  }
}

// Data Model
class NotificationData {
  final List<Notification> notifications;

  NotificationData({required this.notifications});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: (json['notifications'] as List)
          .map((item) => Notification.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'notifications': notifications.map((n) => n.toJson()).toList()};
  }
}

// Individual Notification Model
class Notification {
  final String id;
  final String recipient;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notification({
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

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
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
  Notification copyWith({
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
    return Notification(
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
    return 'Notification(id: $id, title: $title, isRead: $isRead)';
  }
}
