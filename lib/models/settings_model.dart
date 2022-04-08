class Settings{
  bool?  isDark;
  String? UserFirstName;
  String? UserSecondName;
  String? UserImage;
  Settings({this.isDark,this.UserFirstName,this.UserSecondName,this.UserImage});
  Settings.fromJson(Map<String,dynamic>json){
    isDark = json['isDarl'];
    UserFirstName =json['UserFirstName'];
    UserSecondName = json['UserSecondName'];
    UserImage = json['UserImage'];
  }
  Map<String,dynamic> toJson() =>{
  "isDark":isDark,
  "UserFirstName":UserFirstName,
  "UserSecondName":UserSecondName,
  "UserImage":UserImage,
  };
}
// List<Settings> SettingsFromJson(String str) => List<Settings>.from(json.decode(str).map((x) => Settings.fromJson(x)));
// String pictureToJson(List<Settings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
