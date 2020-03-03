class Product {
  int _id;
  String _article;
  String _description;
  String _date;
  int _price;
  int _quantity;
  String _method;

  Product(this._article, this._quantity, this._price, this._date, this._method, [this._description]);
  Product.withId(
      this._id, this._article, this._quantity, this._price, this._date, this._method, [this._description]);

  int get id => _id;
  String get article => _article;
  String get description => _description;
  String get date => _date;
  int get price => _price;
  int get quantity => _quantity;
  String get method => _method;

  set article(String newArticle) {
    if (newArticle.length <= 255) {
      _article = newArticle;
    }
  }
  set method(String newMethod) {
    if (newMethod.length <= 255) {
      _method = newMethod;
    }
  }
  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set price(int newPrice) {
    if (newPrice >= 0) {
      _price = newPrice;
    }
  }

  set quantity(int newQuantity) {
    if (newQuantity >= 0) {
      _quantity = newQuantity;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["article"] = _article;
    map["description"] = _description;
    map["price"] = _price;
    map["quantity"] = _quantity;
    map["date"] = _date;
    if (_id != null) {
      map["id"] = _id;
    }
     map["method"] = _method;
    return map;
  }

  Product.fromObject(dynamic o) {
    this._id = o["id"];
    this._article = o["article"];
    this._description = o["description"];
    this._price = o["price"];
    this._quantity = o["quantity"];
    this._date = o["date"];
    this._method = o["method"];
  }
}
