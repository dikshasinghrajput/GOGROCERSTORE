class DeliveryBoyMain{
  dynamic status;
  dynamic message;
  List<DeliveryBoyData> data;

  DeliveryBoyMain(this.status, this.message, this.data);

  factory DeliveryBoyMain.fromJson(dynamic json){

    var js = json['data'] as List?;
    List<DeliveryBoyData> dlist = [];
    if(js!=null && js.isNotEmpty){
      dlist = js.map((e) => DeliveryBoyData.fromJson(e)).toList();
    }
    return DeliveryBoyMain(json['status'], json['message'], dlist);
  }

  @override
  String toString() {
    return '{status: $status, message: $message, data: $data}';
  }
}

class DeliveryBoyData{

  dynamic boyName;
  dynamic dboyId;
  dynamic lat;
  dynamic lng;
  dynamic boyCity;
  dynamic count;
  dynamic distance;

  DeliveryBoyData(this.boyName, this.dboyId, this.lat, this.lng,
      this.boyCity, this.count, this.distance);

  factory DeliveryBoyData.fromJson(dynamic json){
    return DeliveryBoyData(json['boy_name'], json['dboy_id'], json['lat'], json['lng'], json['boy_city'], json['count'], json['distance']);
  }

  @override
  String toString() {
    return '{boy_name: $boyName, dboy_id: $dboyId, lat: $lat, lng: $lng, boy_city: $boyCity, count: $count, distance: $distance}';
  }
}