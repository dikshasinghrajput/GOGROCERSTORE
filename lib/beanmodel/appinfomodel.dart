class AppInfoModel {
  dynamic status;
  dynamic message;
  dynamic lastLoc;
  dynamic phoneNumberLength;
  dynamic appName;
  dynamic appLogo;
  dynamic firebase;
  dynamic countryCode;
  dynamic firebaseIso;
  dynamic sms;
  dynamic currencySign;
  dynamic refertext;
  dynamic totalItems;
  dynamic androidAppLink;
  dynamic iosAppLink;
  dynamic paymentCurrency;
  dynamic imageUrl;
  dynamic wishlistCount;
  dynamic userWallet;
  dynamic liveChat;

  AppInfoModel(
      {this.status,
      this.message,
      this.lastLoc,
      this.phoneNumberLength,
      this.appName,
      this.appLogo,
      this.firebase,
      this.countryCode,
      this.firebaseIso,
      this.sms,
      this.currencySign,
      this.refertext,
      this.totalItems,
      this.androidAppLink,
      this.iosAppLink,
      this.paymentCurrency,
      this.wishlistCount,
      this.userWallet,
      this.liveChat});

  AppInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    lastLoc = json['last_loc'];
    phoneNumberLength = json['phone_number_length'];
    appName = json['app_name'];
    appLogo = json['app_logo'];
    firebase = json['firebase'];
    countryCode = json['country_code'];
    firebaseIso = json['firebase_iso'];
    sms = json['sms'];
    currencySign = json['currency_sign'];
    refertext = json['refertext'];
    totalItems = json['total_items'];
    androidAppLink = json['android_app_link'];
    iosAppLink = json['ios_app_link'];
    paymentCurrency = json['payment_currency'];
    imageUrl = json['image_url'];
    wishlistCount = json['wishlist_count'];
    userWallet = json['userwallet'];
    liveChat = json['live_chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['last_loc'] = lastLoc;
    data['phone_number_length'] = phoneNumberLength;
    data['app_name'] = appName;
    data['app_logo'] = appLogo;
    data['firebase'] = firebase;
    data['country_code'] = countryCode;
    data['firebase_iso'] = firebaseIso;
    data['sms'] = sms;
    data['currency_sign'] = currencySign;
    data['refertext'] = refertext;
    data['total_items'] = totalItems;
    data['android_app_link'] = androidAppLink;
    data['ios_app_link'] = iosAppLink;
    data['payment_currency'] = paymentCurrency;
    data['image_url'] = imageUrl;
    data['wishlist_count'] = wishlistCount;
    data['userwallet'] = userWallet;
    data['live_chat'] = liveChat;
    return data;
  }

  @override
  String toString() {
    return 'AppInfoModel{status: $status, message: $message, lastLoc: $lastLoc, phoneNumberLength: $phoneNumberLength, appName: $appName, appLogo: $appLogo, firebase: $firebase, countryCode: $countryCode, firebaseIso: $firebaseIso, sms: $sms, currencySign: $currencySign, refertext: $refertext, totalItems: $totalItems, androidAppLink: $androidAppLink, iosAppLink: $iosAppLink, paymentCurrency: $paymentCurrency, imageUrl: $imageUrl, wishlistCount: $wishlistCount, userWallet: $userWallet,liveChat:$liveChat}';
  }
}
