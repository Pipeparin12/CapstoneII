class Profile {
  String username;
  String firstName;
  String lastName;
  String address;
  String phone;
  double height;
  double weight;
  double chestSize;
  double waistSize;
  double hipsSize;

  Profile(
      {required this.username,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.phone,
      required this.height,
      required this.weight,
      required this.chestSize,
      required this.waistSize,
      required this.hipsSize});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json["username"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      address: json["address"] ?? "",
      phone: json["phone"] ?? "",
      height: (json["height"] ?? 0.0).toDouble(), 
      weight: (json["weight"] ?? 0.0).toDouble(),
      chestSize: (json["chestSize"] ?? 0.0).toDouble(),
      waistSize: (json["waistSize"] ?? 0.0).toDouble(),
      hipsSize: (json["hipsSize"] ?? 0.0).toDouble(),
    );
  }

  static List<String> keys = [
    "username",
    "firstName",
    "lastName",
    "address",
    "phone",
    "height",
    "weight",
    "chestSize",
    "waistSize",
    "hipsSize"
  ];
}
