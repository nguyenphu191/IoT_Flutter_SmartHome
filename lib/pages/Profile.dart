import 'package:flutter/material.dart';
import 'package:smart_home/widgets/big_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bgr1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'page1',
                            child: BigText('', text: 'Home', size: 15),
                          ),
                          PopupMenuItem<String>(
                            value: 'page2',
                            child: BigText('', text: 'Data Sensor', size: 15),
                          ),
                          PopupMenuItem<String>(
                            value: 'page3',
                            child:
                                BigText('', text: 'Action History', size: 15),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        // Xử lý khi lựa chọn một mục trong danh sách
                        if (value == 'page1') {
                          Navigator.pushNamed(context, '/');
                        } else if (value == 'page2') {
                          Navigator.pushNamed(context, '/datasensor');
                        } else {
                          Navigator.pushNamed(context, '/actionhistory');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20, bottom: 30),
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        image: DecorationImage(
                          image: AssetImage('assets/images/01.JPG'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 300,
                      width: 320,
                      child: Center(
                        child: Column(
                          children: [
                            BigText('', text: 'Name: Nguyễn Văn Phú'),
                            SizedBox(height: 10),
                            BigText('', text: 'MSV: B21DCCN592'),
                            SizedBox(height: 10),
                            BigText('', text: 'Phone: 0934320943'),
                            SizedBox(height: 10),
                            InkWell(
                              child: Text(
                                'GitHub: https://github.com/nguyenphu191/IoT_Flutter_SmartHome',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                const url =
                                    'https://github.com/nguyenphu191/IoT_Flutter_SmartHome';
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              child: Text(
                                'APIDOCS',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                const url =
                                    'https://docs.google.com/document/d/1vdeOPBJDAESwTpxEDjuEOtugXHnCOxKlR9JNKg6OQEg/edit?usp=sharing';
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            InkWell(
                              child: Text(
                                'Link báo cáo',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                const url =
                                    'https://github.com/nguyenphu191/IoT_Flutter_SmartHome';
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
