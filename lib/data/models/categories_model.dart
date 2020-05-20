class CategoriesModel {
  String msg;
  List<Category> data;

  CategoriesModel({this.msg, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Category>();
      json['data'].forEach((v) {
        data.add(new Category.fromJson(v));
      });
    }
    // data.insert(0, Category(id: 0, name: 'الكل'));
    for(int i =0; i< data.length; i++){
      for(int j=i+1; j<data.length; j++){
        
        if(data[j].name==data[i].name || data[j].id== data[i].id)
        data.removeAt(j);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  String city;
  String createdAt;
  String updatedAt;

  Category({this.id, this.name, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null || json['name'].toString().contains('null')? json['city'] : json['name'];
    city = json['city'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
