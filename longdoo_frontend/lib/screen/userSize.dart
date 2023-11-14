import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/screen/menu.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';
import 'package:numberpicker/numberpicker.dart';

class UserSizeScreen extends StatefulWidget {
  const UserSizeScreen({super.key});

  @override
  State<UserSizeScreen> createState() => _UserSizeScreenState();
}

class _UserSizeScreenState extends State<UserSizeScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = true;
  String selectedGender = 'Male';
  void selectGender(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedGender = newValue;
      });
    }
  }

  String calculateSize(double chest, double waist, double hip) {
    // Define your sizing criteria
    if (chest >= 37.5 && waist >= 31.5 && hip >= 40) {
      return "XL";
    } else if (chest >= 35 && waist >= 29.5 && hip >= 38) {
      return "L";
    } else if (chest >= 33.5 && waist >= 28 && hip >= 36.5) {
      return "M";
    } else {
      return "S";
    }
  }

  Profile userProfile = Profile(
      username: "-",
      firstName: "-",
      lastName: "-",
      address: "-",
      phone: "-",
      height: 0,
      weight: 0,
      chestSize: 0,
      waistSize: 0,
      hipsSize: 0,
      gender: "-",
      size: "-",
      model: "-");

  late int height;
  late int weight;
  late int chestSize;
  late int waistSize;
  late int hipsSize;

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final chestSizeController = TextEditingController();
  final waistSizeController = TextEditingController();
  final hipsSizeController = TextEditingController();

  getHeight(String heightValue) {
    height = int.parse(heightValue);
  }

  getWeight(String weightValue) {
    weight = int.parse(weightValue);
  }

  getChestSize(String chestValue) {
    chestSize = int.parse(chestValue);
  }

  getWaistSize(String waistValue) {
    waistSize = int.parse(waistValue);
  }

  getHipsSize(String hipsValue) {
    hipsSize = int.parse(hipsValue);
  }

  updateSize(context) async {
    // Extract text from controllers
    String heightText = heightController.text;
    String weightText = weightController.text;
    String chestText = chestSizeController.text;
    String waistText = waistSizeController.text;
    String hipText = hipsSizeController.text;

    // Convert text to integers
    double heightValue = double.tryParse(heightText) ?? 0.0;
    double weightValue = double.tryParse(weightText) ?? 0.0;
    double chestValue = double.tryParse(chestText) ?? 0.0;
    double waistValue = double.tryParse(waistText) ?? 0.0;
    double hipValue = double.tryParse(hipText) ?? 0.0;

    // Create formatted strings for display
    String formattedHeight = heightValue == heightValue.roundToDouble()
        ? heightValue.round().toString()
        : heightValue.toString();
    String formattedWeight = weightValue == weightValue.roundToDouble()
        ? weightValue.round().toString()
        : weightValue.toString();
    String formattedChest = chestValue == chestValue.roundToDouble()
        ? chestValue.round().toString()
        : chestValue.toString();
    String formattedWaist = waistValue == waistValue.roundToDouble()
        ? waistValue.round().toString()
        : waistValue.toString();
    String formattedHip = hipValue == hipValue.roundToDouble()
        ? hipValue.round().toString()
        : hipValue.toString();

    String size = calculateSize(chestValue, waistValue, hipValue);

    Map<String, dynamic> updatedProfile = ({
      "height": formattedHeight,
      "weight": formattedWeight,
      "chestSize": formattedChest,
      "waistSize": formattedWaist,
      "hipsSize": formattedHip,
      "gender": selectedGender,
      "size": size
    });

    print("Updated height: ${updatedProfile['height']}");
    print("Updated weight: ${updatedProfile['weight']}");
    print("Updated chest: ${updatedProfile['chest']}");
    print("Updated waist: ${updatedProfile['waist']}");
    print("Updated hip: ${updatedProfile['hip']}");
    print("Updated gender: $selectedGender");
    print("Calculated size: $size");

    try {
      final token = SharePreference.prefs.getString("token");
      final response = await DioInstance.dio.patch(
        "/account/usersize/update",
        data: updatedProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response.data);

      if (response.data["success"]) {
        await fetchProfile();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchProfile() async {
    final token = SharePreference.prefs.getString("token");
    final response = await DioInstance.dio.get(
      "/account/userdetails",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    if (response.data["success"]) {
      final profileData = response.data["userProfile"];
      if (profileData != null) {
        setState(() {
          userProfile = Profile.fromJson(profileData);
        });
      } else {}
    } else {}
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    chestSizeController.dispose();
    waistSizeController.dispose();
    hipsSizeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    isLoading = true;

    fetchProfile().then((_) {
      heightController.text = userProfile.height.toString();
      weightController.text = userProfile.weight.toString();
      chestSizeController.text = userProfile.chestSize.toString();
      waistSizeController.text = userProfile.waistSize.toString();
      hipsSizeController.text = userProfile.hipsSize.toString();
      selectedGender = userProfile.gender ?? 'Unknown';
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Your size'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
                  height: double.maxFinite,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Height',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      controller: heightController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'cm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Weight',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      controller: weightController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'kg',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Chest',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 35),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      controller: chestSizeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'Inch',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Waist',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 35),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      controller: waistSizeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'Inch',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Hip',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 55),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      controller: hipsSizeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'Inch',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors
                                              .black38), // Set the border color
                                      borderRadius: BorderRadius.circular(
                                          5.0), // Optional: Set border radius for rounded corners
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedGender,
                                      onChanged: selectGender,
                                      items: <String>[
                                        'Male',
                                        'Female',
                                        'Unknown'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    30.0), // Adjust the padding as needed
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      underline:
                                          Container(), // Remove the default underline
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 40)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Save',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  onTap: () => updateSize(context),
                                )
                              ],
                            )
                          ])))
            ]),
          ),
        ));
  }
}
