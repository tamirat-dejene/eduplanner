class UserModel {
  String name;
  String email;
  String password;

  UserModel({required this.name, required this.email, required this.password});

  static Future<UserModel> getUser() async {
    return UserModel(
        name: 'Tamirat Dejenie',
        email: 'tamirat.dejenie@gmail.com',
        password: 'icdeadppl');
  }
}
