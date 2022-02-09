class IntroModel{
  late String imageUrl;
  late String title;
  late String subtitle;

  IntroModel({required this.imageUrl, required this.subtitle, required this.title});

  IntroModel.fromJson(json){
    imageUrl = json['imageUrl'];
    title = json['title'];
    subtitle = json['subtitle'];
  }
}