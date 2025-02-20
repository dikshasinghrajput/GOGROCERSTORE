import 'package:flutter/foundation.dart';

class LocalNotification {
  String? firstName;
  String? lastName;
  String? senderId;
  String? route;
  String? chatId;
  String? otherGlobalId;
  int? userId;
  String? fcmToken;
  String? title;
  String? body;
  String? userToken;
  int? storeId;

  LocalNotification();

  LocalNotification.fromJson(Map<String, dynamic> json) {
    try {
      firstName = json['firstName'];
      lastName = json['lastName'];
      storeId = json['storeId'] != null ? int.parse(json['storeId'].toString()) : null;
      route = json['route'];
      chatId = json['chatId'];
      otherGlobalId = json['otherGlobalId'];
      userId = json['userId'] != null ? int.parse(json['userId'].toString()) : null;
      fcmToken = json['userToken'];
      title = json['title'];
      body = json['body'];
    } catch (e) {
      debugPrint("Exception - reminder_model.dart - Reminder.fromJson():$e");
    }
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'senderId': senderId,
        'route': route,
        'chatId': chatId,
        'otherGlobalId': otherGlobalId,
        'userId': userId,
        'fcmToken': fcmToken,
        'title': title,
        'body': body,
        'userToken': userToken,
      };
}
