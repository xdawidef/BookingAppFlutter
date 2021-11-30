class UserModel{
  String name='', address='', profileImage='';
  bool isStaff=false;

  UserModel({required this.name, required this.address, required this.profileImage});

  UserModel.fromJson(Map<String, dynamic> json){
    address = json['address'];
    name = json['name'];
    profileImage = json['profileImage'];
    isStaff = json['isStaff'] == null ? false : json['isStaff'] as bool;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    data['isStaff'] = this.isStaff;
    return data;
  }

}