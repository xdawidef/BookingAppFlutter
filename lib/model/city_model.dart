class CityModel{
  String name='', cityPhoto='';

  CityModel({required this.name});

  CityModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    cityPhoto = json['cityPhoto'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cityPhoto'] = this.cityPhoto;
    return data;
  }
}