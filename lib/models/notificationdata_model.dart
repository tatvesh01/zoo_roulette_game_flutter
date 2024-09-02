class NotificationData {
  NotificationData({
    required this.image,
    required this.valueTitle,
    required this.notificationTitle,
    required this.applicationDropdown,
    required this.valueId,
    required this.notificationId,
    required this.applicationDropdownId,
    required this.title,
    required this.message,
    required this.orderId,
  });

  String image;
  String valueTitle;
  String notificationTitle;
  String applicationDropdown;
  int valueId;
  int notificationId;
  int applicationDropdownId;
  String title;
  String message;
  int orderId;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        image: json["image"] ?? '',
        valueTitle: json["value_title"] ?? '',
        notificationTitle: json["notification_title"] ?? '',
        applicationDropdown: json["application_dropdown"] ?? '',
        valueId: json["value_id"] != null
            ? json["value_id"] is String
                ? int.parse(json["value_id"])
                : json["value_id"]
            : 0,
        notificationId: json["notification_id"] != null
            ? json["notification_id"] is String
                ? int.parse(json["notification_id"])
                : json["notification_id"]
            : 0,
        applicationDropdownId: json["application_dropdown_id"] != null
            ? json["application_dropdown_id"] is String
                ? int.parse(json["application_dropdown_id"])
                : json["application_dropdown_id"]
            : 0,
        title: json["title"] ?? '',
        message: json["message"] ?? '',
        orderId: json["order_id"] != null
            ? json["order_id"] is String
                ? int.parse(json["order_id"])
                : json["order_id"]
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "value_title": valueTitle,
        "notification_title": notificationTitle,
        "application_dropdown": applicationDropdown,
        "value_id": valueId,
        "notification_id": notificationId,
        "application_dropdown_id": applicationDropdownId,
        "title": title,
        "message": message,
        "order_id": orderId,
      };
}
