class StoreProfileMain {
  dynamic status;
  dynamic message;
  StoreProfileDataMain? data;

  StoreProfileMain(this.status, this.message, this.data);

  factory StoreProfileMain.fromJson(dynamic json) {
    if (json['data'] != null) {
      var jsd = json['data'] as List;
      StoreProfileDataMain jsData = StoreProfileDataMain.fromJson(jsd[0]);
      return StoreProfileMain(json['status'], json['message'], jsData);
    } else {
      return StoreProfileMain(json['status'], json['message'], null);
    }
  }

  @override
  String toString() {
    return '{status: $status, message: $message, data: $data}';
  }
}

class StoreProfileDataMain {
  dynamic storeName;
  dynamic phoneNumber;
  dynamic email;
  dynamic storePhoto;
  dynamic address;
  dynamic ownerName;
  dynamic password;

  StoreProfileDataMain(this.storeName, this.phoneNumber, this.email, this.storePhoto, this.address, this.ownerName, this.password);

  factory StoreProfileDataMain.fromJson(dynamic json) {
    return StoreProfileDataMain(
      json['store_name'],
      json['phone_number'],
      json['email'],
      json['store_photo'],
      json['address'],
      json['employee_name'],
      json['password'],
    );
  }

  @override
  String toString() {
    return '{store_name: $storeName, phone_number: $phoneNumber, email: $email, store_photo: $storePhoto, address: $address, owner_name: $ownerName, password: $password}';
  }
}
