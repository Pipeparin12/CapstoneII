import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Support'),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ),
            // height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.5),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Call to shop",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text(
                            "0213456789",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ), // Replace with your total price text
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: EdgeInsets.all(
                              10), // Adjust the padding to increase the tappable area
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  140, 50), // Adjust the minimum size as needed
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the icon and text horizontally
                              children: [
                                Icon(Icons
                                    .call), // Replace with your desired icon
                                SizedBox(
                                    width:
                                        8), // Add spacing between the icon and text
                                Text(
                                  "Call",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              final Uri url =
                                  Uri(scheme: 'tel', path: "091 931 6517");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                print('can not lauch url');
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Email to shop",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text(
                            "longdoo@mail.com",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(140, 50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.email),
                                SizedBox(width: 8),
                                Text(
                                  "Email",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              String? encodeQueryParameters(
                                  Map<String, String> params) {
                                return params.entries
                                    .map((MapEntry<String, String> e) =>
                                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                    .join('&');
                              }

                              final Uri email = Uri(
                                scheme: 'mailto',
                                path: "jackpot2545@gmail.com",
                                query: encodeQueryParameters(<String, String>{
                                  'subject':
                                      'Example Subject & Symbols are allowed!',
                                }),
                              );
                              if (await canLaunchUrl(email)) {
                                await launchUrl(email);
                              } else {
                                print('can not lauch url');
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}