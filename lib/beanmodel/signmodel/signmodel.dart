class SignMain{
  dynamic status;
  dynamic message;
  SignDataModel? data;

  SignMain(this.status, this.message, this.data);

  factory SignMain.fromJson(dynamic json){

    var js = json['data'] as List?;
    List<SignDataModel> datajs = [];
    SignDataModel? ddModel;
    if(js!=null && js.isNotEmpty){
      datajs = js.map((e) => SignDataModel.fromJson(e)).toList();
      ddModel = datajs[0];
    }
    return SignMain(json['status'], json['message'], ddModel);
  }

  @override
  String toString() {
    return '{status: $status, message: $message, data: $data}';
  }
}

class SignDataModel{

  dynamic id;
  dynamic storeName;
  dynamic employeeName;
  dynamic phoneNumber;
  dynamic storePhoto;
  dynamic city;
  dynamic adminShare;
  dynamic deviceId;
  dynamic email;
  dynamic password;
  dynamic delRange;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic adminApproval;
  dynamic storeStatus;
  dynamic storeOpeningTime;
  dynamic storeClosingTime;
  dynamic timeInterval;
  dynamic inactiveReason;

  SignDataModel(
      this.id, //store_id
      this.storeName,
      this.employeeName,
      this.phoneNumber,
      this.storePhoto,
      this.city,
      this.adminShare,
      this.deviceId,
      this.email,
      this.password,
      this.delRange,
      this.lat,
      this.lng,
      this.address,
      this.adminApproval,
      this.storeStatus,
      this.storeOpeningTime,
      this.storeClosingTime,
      this.timeInterval,
      this.inactiveReason);

  factory SignDataModel.fromJson(dynamic json){
    return SignDataModel(json['id'], json['store_name'], json['employee_name'], json['phone_number'], json['store_photo'], json['city'], json['admin_share'], json['device_id'], json['email'], json['password'], json['del_range'], json['lat'], json['lng'], json['address'], json['admin_approval'], json['store_status'], json['store_opening_time'], json['store_closing_time'], json['time_interval'], json['inactive_reason']);
  }

  @override
  String toString() {
    return '{id: $id, store_name: $storeName, employee_name: $employeeName, phone_number: $phoneNumber, store_photo: $storePhoto, city: $city, admin_share: $adminShare, device_id: $deviceId, email: $email, password: $password, del_range: $delRange, lat: $lat, lng: $lng, address: $address, admin_approval: $adminApproval, store_status: $storeStatus, store_opening_time: $storeOpeningTime, store_closing_time: $storeClosingTime, time_interval: $timeInterval, inactive_reason: $inactiveReason}';
  }
}