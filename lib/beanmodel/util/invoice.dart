class Invoice {
  dynamic status;
  dynamic message;
  dynamic invoiceNo;
  dynamic number;
  dynamic name;
  dynamic address;
  dynamic city;
  dynamic pincode;
  double? paidByWallet;
  double? couponDiscount;
  double? priceToPay;
  double? totalPrice;
  double? priceWithoutDelivery;
  double? deliveryCharge;
  List<OrderDetails>? orderDetails;

  Invoice({this.status, this.message, this.invoiceNo, this.number, this.name, this.address, this.city, this.pincode, this.paidByWallet, this.couponDiscount, this.priceToPay, this.totalPrice, this.priceWithoutDelivery, this.deliveryCharge, this.orderDetails});

  Invoice.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    invoiceNo = json['invoice_no'];
    number = json['number'];
    name = json['Name'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    paidByWallet = json['paid_by_wallet']!=null?double.parse('${json['paid_by_wallet']}'):0.0;
    couponDiscount = json['coupon_discount']!=null?double.parse('${json['coupon_discount']}'):0.0;
    priceToPay = json['price_to_pay']!=null?double.parse('${json['price_to_pay']}'):0.0;
    totalPrice = json['total_price']!=null?double.parse('${json['total_price']}'):0.0;
    priceWithoutDelivery = json['price_without_delivery']!=null?double.parse('${json['price_without_delivery']}'):0.0;
    deliveryCharge = json['delivery_charge']!=null?double.parse('${json['delivery_charge']}'):0.0;
    if (json['order_details'] != null) {
      orderDetails = [];
      json['order_details'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['invoice_no'] = invoiceNo;
    data['number'] = number;
    data['Name'] = name;
    data['address'] = address;
    data['city'] = city;
    data['pincode'] = pincode;
    data['paid_by_wallet'] = paidByWallet;
    data['coupon_discount'] = couponDiscount;
    data['price_to_pay'] = priceToPay;
    data['total_price'] = totalPrice;
    data['price_without_delivery'] = priceWithoutDelivery;
    data['delivery_charge'] = deliveryCharge;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
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

  OrderDetails({this.storeOrderId, this.productName, this.varientImage, this.quantity, this.unit, this.varientId, this.qty, this.price, this.totalMrp, this.orderCartId, this.orderDate, this.storeApproval, this.storeId, this.description});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    storeOrderId = json['store_order_id'];
    productName = json['product_name'];
    varientImage = json['varient_image'];
    quantity = json['quantity'];
    unit = json['unit'];
    varientId = json['varient_id'];
    qty = json['qty'];
    price = json['price']!=null?double.parse('${json['price']}'):0.0;
    totalMrp = json['total_mrp']!=null?double.parse('${json['total_mrp']}'):0.0;
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
