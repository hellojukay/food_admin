class Item {
  Item(
      {this.title, this.price, this.catId, this.id, this.widget, this.content});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json["id"] as int,
        price: json["price"].toDouble(),
        catId: json["catId"] as int,
        title: json["title"] as String,
        content: json["content"] ?? "",
        widget: json["widget"] ?? "");
  }
  Map toJson() {
    return {
      "id": id,
      "widget": widget ?? "",
      "title": title,
      "price": price,
      "catId": catId,
      "content": content ?? ""
    };
  }

  String? title;
  double? price;
  int? catId;
  int? id;
  String? widget;
  String? content;
}

class CategoryItem {
  CategoryItem({this.name, this.id});
  factory CategoryItem.fromJson(Map<String, dynamic> e) {
    return CategoryItem(id: e["id"] as int, name: e["name"] as String);
  }
  Map toJson() {
    return {"name": name, "id": id};
  }

  String? name;
  int? id;
}

class FoodMenu {
  FoodMenu({this.category, this.list});
  List<Item>? list;
  List<CategoryItem>? category;
  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemJsonArray = json["list"].toList();
    List<dynamic> categoryItemJsonArray = json["category"].toList();
    List<Item> items = [];
    List<CategoryItem> categoryItems = [];
    for (var e in itemJsonArray) {
      var item = Item.fromJson(e);
      items.add(item);
    }
    for (var e in categoryItemJsonArray) {
      var c = CategoryItem.fromJson(e);
      categoryItems.add(c);
    }
    return FoodMenu(list: items, category: categoryItems);
  }
  Map toJson() {
    return {"list": list, "category": category};
  }
}
