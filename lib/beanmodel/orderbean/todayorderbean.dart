import 'package:vendor/baseurl/baseurlg.dart';

class TodayOrderMain {
  dynamic userAddress;
  dynamic cartId;
  dynamic userName;
  dynamic userPhone;
  double remainingPrice;
  double orderPrice;
  dynamic deliveryBoyName;
  dynamic deliveryBoyPhone;
  dynamic deliveryDate;
  dynamic timeSlot;
  dynamic paymentMode;
  dynamic paymentStatus;
  dynamic orderStatus;
  dynamic customerPhone;
  List<TodayOrderItems>? orderDetails;

  TodayOrderMain(
      this.userAddress, this.cartId, this.userName, this.userPhone, this.remainingPrice, this.orderPrice, this.deliveryBoyName, this.deliveryBoyPhone, this.deliveryDate, this.timeSlot, this.paymentMode, this.paymentStatus, this.orderStatus, this.customerPhone, this.orderDetails);

  factory TodayOrderMain.fromJson(dynamic json) {
    var js = json['order_details'] as List?;
    List<TodayOrderItems>? orderD;
    if (js != null && js.isNotEmpty) {
      orderD = js.map((e) => TodayOrderItems.fromJson(e)).toList();
    }

    return TodayOrderMain(
      json['user_address'],
      json['cart_id'],
      json['user_name'],
      json['user_phone'],
      double.parse('${json['remaining_price']}'),
      double.parse('${json['order_price']}'),
      json['delivery_boy_name'],
      json['delivery_boy_phone'],
      json['delivery_date'],
      json['time_slot'],
      json['payment_mode'],
      json['payment_status'],
      json['order_status'],
      json['customer_phone'],
      orderD,
    );
  }
}

class TodayOrderItems {
  dynamic storeOrderId;
  dynamic productName;
  dynamic varientImage;
  dynamic quantity;
  dynamic varientId;
  dynamic qty;
  dynamic unit;
  double price;
  dynamic orderCartId;
  double totalMrp;
  dynamic orderDate;
  dynamic storeApproval;

  TodayOrderItems(this.storeOrderId, this.productName, this.varientImage, this.quantity, this.varientId, this.qty, this.unit, this.price, this.orderCartId, this.totalMrp, this.orderDate, this.storeApproval);

  factory TodayOrderItems.fromJson(dynamic json) {
    return TodayOrderItems(
      json['store_order_id'],
      json['product_name'],
      '$imagebaseUrl${json['varient_image']}',
      json['quantity'],
      json['varient_id'],
      json['qty'],
      json['unit'],
      json['price'] != null && json['price'] != '' ? double.parse('${json['price']}') : 0.0,
      json['order_cart_id'],
      json['total_mrp'] != null && json['total_mrp'] != '' ? double.parse('${json['total_mrp']}') : 0.0,
      json['order_date'],
      json['store_approval'],
    );
  }

  @override
  String toString() {
    return '{store_order_id: $storeOrderId, product_name: $productName, varient_image: $varientImage, quantity: $quantity, varient_id: $varientId, qty: $qty, unit: $unit, price: $price, order_cart_id: $orderCartId, total_mrp: $totalMrp, order_date: $orderDate, store_approval: $storeApproval}';
  }
}
