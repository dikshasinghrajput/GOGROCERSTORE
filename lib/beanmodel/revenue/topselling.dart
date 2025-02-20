import 'package:vendor/baseurl/baseurlg.dart';

class TopSellingRevenueOrdCount {
  dynamic status;
  dynamic message;
  dynamic totalOrders;
  double? totalRevenue;
  dynamic pendingOrders;
  List<TopSellingItemsR>? data;

  TopSellingRevenueOrdCount({this.status, this.message, this.totalOrders, this.totalRevenue, this.pendingOrders, this.data});

  TopSellingRevenueOrdCount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalOrders = json['total_orders'];
    totalRevenue = json['total_revenue'] != null && json['total_revenue'] != '' ? double.parse('${json['total_revenue']}') : 0;
    pendingOrders = json['pending_orders'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TopSellingItemsR.fromJson(v));
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

class TopSellingItemsR {
  dynamic storeId;
  dynamic productName;
  dynamic varientId;
  dynamic varientImage;
  dynamic quantity;
  dynamic unit;
  dynamic description;
  dynamic count;
  dynamic totalqty;
  int? revenue;

  TopSellingItemsR({this.storeId, this.productName, this.varientId, this.varientImage, this.quantity, this.unit, this.description, this.count, this.totalqty, this.revenue});

  TopSellingItemsR.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    productName = json['product_name'];
    varientId = json['varient_id'];
    varientImage = '$imagebaseUrl${json['varient_image']}';
    quantity = json['quantity'];
    unit = json['unit'];
    description = json['description'];
    count = json['count'];
    totalqty = json['totalqty'];
    revenue = json['revenue'] != null && json['revenue'] != "" ? double.parse(json['revenue'].toString()).round() : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['product_name'] = productName;
    data['varient_id'] = varientId;
    data['varient_image'] = varientImage;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['description'] = description;
    data['count'] = count;
    data['totalqty'] = totalqty;
    data['revenue'] = revenue;
    return data;
  }
}
