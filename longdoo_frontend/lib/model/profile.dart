class Profile {
  String username;
  String firstName;
  String lastName;
  String password;
  String email;
  String address;
  String phone;
  double height;
  double weight;
  double chestSize;
  double waistSize;
  double hipsSize;

  Profile({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    required this.address,
    required this.phone,
    required this.height,
    required this.weight,
    required this.chestSize,
    required this.waistSize,
    required this.hipsSize
  });

  static Profile fromJson(dynamic json) {
    return Profile(
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        password: json["password"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        height: json["height"],
        weight: json["weight"],
        chestSize: json["chestSize"],
        waistSize: json["waistSize"],
        hipsSize: json["hipsSize"],
        );
  }

  static List<String> keys = [
    "username",
    "firstName",
    "lastName",
    "password",
    "email",
    "address",
    "phone",
    "height",
    "weight",
    "chestSize",
    "waistSize",
    "hipsSize"
  ];
}