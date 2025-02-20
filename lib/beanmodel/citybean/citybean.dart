class CityBeanModel{
  dynamic status;
  dynamic message;
  List<CityDataBean> data;

  CityBeanModel(this.status, this.message, this.data);

  factory CityBeanModel.fromJson(dynamic json){
    var tagListJson = json['data'] as List?;
    var listD = [];
    if(tagListJson!=null){
      listD = tagListJson.map((e) => CityDataBean.fromJson(e)).toList();
    }
    return CityBeanModel(json['status'], json['message'], listD as List<CityDataBean>);
  }
}

class CityDataBean{
  dynamic cityId;
  dynamic cityName;

  CityDataBean(this.cityId, this.cityName);

  factory CityDataBean.fromJson(dynamic json){
    return CityDataBean(json['city_id'], json['city_name']);
  }

  @override
  String toString() {
    return 'CityDataBean{city_id: $cityId, city_name: $cityName}';
  }
}