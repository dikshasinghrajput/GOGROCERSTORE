class MapBoxApiKey {
  dynamic status;
  dynamic message;
  MapBoxApiKeyData? data;

  MapBoxApiKey({this.status, this.message, this.data});

  MapBoxApiKey.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? MapBoxApiKeyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MapBoxApiKeyData {
  dynamic mapId;
  dynamic mapboxApi;

  MapBoxApiKeyData({this.mapId, this.mapboxApi});

  MapBoxApiKeyData.fromJson(Map<String, dynamic> json) {
    mapId = json['map_id'];
    mapboxApi = json['mapbox_api'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['map_id'] = mapId;
    data['mapbox_api'] = mapboxApi;
    return data;
  }
}