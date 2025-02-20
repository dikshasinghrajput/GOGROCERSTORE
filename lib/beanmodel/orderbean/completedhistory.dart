import 'package:vendor/baseurl/baseurlg.dart';

class CompletedHistory {
  int? totalRevenue;
  List<CompletedHistoryOrder>? data;

  CompletedHistory({this.totalRevenue, this.data});

  CompletedHistory.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['total_revenue'] != null && json['total_revenue'] != '' ? double.parse(json['total_revenue'].toString()).round() : 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CompletedHistoryOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_revenue'] = totalRevenue;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompletedHistoryOrder {
  dynamic orderStatus;
  dynamic deliveryDate;
  dynamic timeSlot;
  dynamic paymentMethod;
  dynamic paymentStatus;
  dynamic paidByWallet;
  dynamic cartId;
  double? price;
  double? delCharge;
  double? remainingAmount;
  double? couponDiscount;
  dynamic dboyName;
  dynamic dboyPhone;
  dynamic userName;
  List<CHOrderItme>? data;
      //
  CompletedHistoryOrder({this.orderStatus, this.deliveryDate, this.timeSlot, this.paymentMethod, this.paymentStatus, this.paidByWallet, this.cartId, this.price, this.delCharge, this.remainingAmount, this.couponDiscount, this.dboyName, this.dboyPhone, this.userName, this.data});

  CompletedHistoryOrder.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'];
    deliveryDate = json['delivery_date'];
    timeSlot = json['time_slot'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    paidByWallet = json['paid_by_wallet'];
    cartId = json['cart_id'];
    price = json['price'] != null && json['price'] != '' ? double.parse('${json['price']}') : 0.0;
    delCharge = json['del_charge'] != null && json['del_charge'] != '' ? double.parse('${json['del_charge']}') : 0.0;
    remainingAmount = json['remaining_amount'] != null && json['remaining_amount'] != '' ? double.parse('${json['remaining_amount']}') : 0.0;
    couponDiscount = json['coupon_discount'] != null && json['coupon_discount'] != '' ? double.parse('${json['coupon_discount']}') : 0.0;
    dboyName = json['dboy_name'];
    dboyPhone = json['dboy_phone'];
    userName = json['user_name'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CHOrderItme.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_status'] = orderStatus;
    data['delivery_date'] = deliveryDate;
    data['time_slot'] = timeSlot;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['paid_by_wallet'] = paidByWallet;
    data['cart_id'] = cartId;
    data['price'] = price;
    data['del_charge'] = delCharge;
    data['remaining_amount'] = remainingAmount;
    data['coupon_discount'] = couponDiscount;
    data['dboy_name'] = dboyName;
    data['dboy_phone'] = dboyPhone;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CHOrderItme {
  dynamic storeOrderId;
  dynamic productName;
  dynamic varientImage;
  dynamic quantity;
  dynamic unit;
  dynamic varientId;
  dynamic qty;
  double? price;
  double? totalMrp;
  dynamic orderCartId;
  dynamic orderDate;
  dynamic storeApproval;
  dynamic storeId;
  dynamic description;

  CHOrderItme({this.storeOrderId, this.productName, this.varientImage, this.quantity, this.unit, this.varientId, this.qty, this.price, this.totalMrp, this.orderCartId, this.orderDate, this.storeApproval, this.storeId, this.description});

  CHOrderItme.fromJson(Map<String, dynamic> json) {
    storeOrderId = json['store_order_id'];
    productName = json['product_name'];
    varientImage = '$imagebaseUrl${json['varient_image']}';
    quantity = json['quantity'];
    unit = json['unit'];
    varientId = json['varient_id'];
    qty = json['qty'];
    price = double.parse('${json['price']}');
    totalMrp = double.parse('${json['total_mrp']}');
    orderCartId = json['order_cart_id'];
    orderDate = json['order_date'];
    storeApproval = json['store_approval'];
    storeId = json['store_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_order_id'] = storeOrderId;
    data['product_name'] = productName;
    data['varient_image'] = varientImage;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['varient_id'] = varientId;
    data['qty'] = qty;
    data['price'] = price;
    data['total_mrp'] = totalMrp;
    data['order_cart_id'] = orderCartId;
    data['order_date'] = orderDate;
    data['store_approval'] = storeApproval;
    data['store_id'] = storeId;
    data['description'] = description;
    return data;
  }
}
