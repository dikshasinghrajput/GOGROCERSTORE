class CategoryListMain{
  dynamic status;
  dynamic message;
  List<CategoryListData>? data;

  CategoryListMain(this.status, this.message, this.data);

  factory CategoryListMain.fromJson(dynamic json){
    var js = json['data'] as List?;
    List<CategoryListData>? jsData;
    if(js!=null && js.isNotEmpty){
      jsData = js.map((e) => CategoryListData.fromJson(e)).toList();
    }
    return CategoryListMain(json['status'], json['message'],jsData);
  }

  @override
  String toString() {
    return '{status: $status, message: $message, data: $data}';
  }
}

class CategoryListData{
  dynamic catId;
  dynamic title;
  dynamic slug;
  dynamic image;
  dynamic parent;
  dynamic level;
  dynamic description;
  dynamic status;
  dynamic addedBy;

  CategoryListData(this.catId, this.title, this.slug, this.image, this.parent,
      this.level, this.description, this.status, this.addedBy);

  factory CategoryListData.fromJson(dynamic json){
    return CategoryListData(json['cat_id'], json['title'], json['slug'], json['image'], json['parent'], json['level'], json['description'], json['status'], json['added_by']);
  }

  @override
  String toString() {
    return '{cat_id: $catId, title: $title, slug: $slug, image: $image, parent: $parent, level: $level, description: $description, status: $status, added_by: $addedBy}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryListData &&
          runtimeType == other.runtimeType &&
          '$catId' == '${other.catId}';

  @override
  int get hashCode => catId.hashCode;
}