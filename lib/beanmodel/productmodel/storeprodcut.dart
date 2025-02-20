import 'package:vendor/baseurl/baseurlg.dart';

class StoreProductMain {
  dynamic status;
  dynamic message;
  List<StoreProductData>? data;

  StoreProductMain({this.status, this.message, this.data});

  StoreProductMain.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    var js = json['data'] as List?;
    if (js != null && js.isNotEmpty) {
      data = [];
      json['data'].forEach((v) {
        data!.add(StoreProductData.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoreProductData {
  dynamic productId;
  dynamic catId;
  dynamic productName;
  dynamic productImage;
  dynamic hide;
  dynamic addedBy;
  dynamic approved;
  String? type;
  List<Tags>? tags;
  List<Varients>? varients;

  StoreProductData({this.productId, this.catId, this.productName, this.productImage, this.hide, this.addedBy, this.approved, this.type, this.tags, this.varients});

  StoreProductData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    catId = json['cat_id'];
    productName = json['product_name'];
    type = json['type'];
    productImage = '$imagebaseUrl${json['product_image']}';
    hide = json['hide'];
    addedBy = json['added_by'];
    approved = json['approved'];
    var jstags = json['tags'] as List?;
    if (jstags != null && jstags.isNotEmpty) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    } else {
      tags = [];
    }
    var jsvarients = json['varients'] as List?;
    if (jsvarients != null && jsvarients.isNotEmpty) {
      varients = [];
      json['varients'].forEach((v) {
        varients!.add(Varients.fromJson(v));
      });
    } else {
      varients = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['cat_id'] = catId;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['hide'] = hide;
    data['added_by'] = addedBy;
    data['approved'] = approved;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    if (varients != null) {
      data['varients'] = varients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  dynamic tagId;
  dynamic productId;
  dynamic tag;

  Tags({this.tagId, this.productId, this.tag});

  Tags.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    productId = json['product_id'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag_id'] = tagId;
    data['product_id'] = productId;
    data['tag'] = tag;
    return data;
  }
}

class Varients {
  dynamic addedBy;
  dynamic varientId;
  dynamic description;
  double? price;
  double? mrp;
  dynamic varientImage;
  dynamic unit;
  dynamic quantity;
  double? dealPrice;
  dynamic validFrom;
  dynamic validTo;
  dynamic ean;

  Varients({this.addedBy, this.varientId, this.description, this.price, this.mrp, this.varientImage, this.unit, this.quantity, this.dealPrice, this.validFrom, this.validTo, this.ean});

  Varients.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    varientId = json['varient_id'];
    description = json['description'];
    price = json['price']!=null?double.parse('${json['price']}'):0.0;
    mrp = json['mrp']!=null?double.parse('${json['mrp']}'):0.0;
    varientImage = '$imagebaseUrl${json['varient_image']}';
    unit = json['unit'];
    quantity = json['quantity'];
    dealPrice = json['deal_price']!=null?double.parse('${json['deal_price']}'):0.0;
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    ean = json['ean'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['added_by'] = addedBy;
    data['varient_id'] = varientId;
    data['description'] = description;
    data['price'] = price;
    data['mrp'] = mrp;
    data['varient_image'] = varientImage;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['deal_price'] = dealPrice;
    data['valid_from'] = validFrom;
    data['valid_to'] = validTo;
    data['ean'] = ean;
    return data;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Varients && runtimeType == other.runtimeType && '$varientId' == '${other.varientId}';

  @override
  int get hashCode => varientId.hashCode;
}
