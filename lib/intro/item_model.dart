class ItemModel{
  late String imageUrl;
  late String title;
  late String subtitle;

  ItemModel({required this.imageUrl, required this.subtitle, required this.title});

  ItemModel.fromJson(json){
    imageUrl = json['imageUrl'];
    title = json['title'];
    subtitle = json['subtitle'];
  }
}