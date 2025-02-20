class Notifications {
  dynamic status;
  dynamic message;
  dynamic totalOrders;
  double? totalRevenue;
  dynamic pendingOrders;
  List<NotificationData>? data;

  Notifications({this.status, this.message, this.totalOrders, this.totalRevenue, this.pendingOrders, this.data});

  Notifications.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalOrders = json['total_orders'];
    totalRevenue = json['total_revenue']!=null?double.parse('${json['total_revenue']}'):0.0;
    pendingOrders = json['pending_orders'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_orders'] = totalOrders;
    data['total_revenue'] = totalRevenue;
    data['pending_orders'] = pendingOrders;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int? notId;
  String? notTitle;
  String? notMessage;
  String? image;
  int? storeId;

  NotificationData({this.storeId, this.image, this.notId, this.notMessage, this.notTitle});

  NotificationData.fromJson(Map<String, dynamic> json) {
    notId = json['not_id'];
    storeId = json['store_id'];
    notTitle = json['not_title'];
    image = json['image'];
    notMessage = json['not_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['not_id'] = notId;
    data['not_title'] = notTitle;
    data['not_message'] = notMessage;
    data['image'] = image;
    return data;
  }
}
