import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:profile/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../Constants/colors.dart';
import '../constants/local_keys.dart';
import 'camera_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> menuItems = [
    {"title": "My Projects", "icon": Icons.folder},
    {"title": "Account", "icon": Icons.person},
    {"title": "Share with Friends", "icon": Icons.share},
    {"title": "Review", "icon": Icons.star_rate},
    {"title": "Info", "icon": Icons.info},
  ];
  String localImage = "";
  String latitude = "";
  String longitude = "";

  getSavedImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    localImage = preferences.getString(LocalKeys.lastPicturePath) ?? "";
    latitude = preferences.getString(LocalKeys.locationLatitude) ?? "";
    longitude = preferences.getString(LocalKeys.locationLongitude) ?? "";

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getSavedImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: backGroundImage(),
          ),
          cardWidget(),
          imageStack(),
        ],
      ),
    );
  }

  Widget backGroundImage() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(300),
              bottomLeft: Radius.circular(300),
            ),
            color: Colors.black26,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(100),
              bottomLeft: Radius.circular(100),
            ),
            color: Colors.black12,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(1000),
              bottomLeft: Radius.circular(1000),
            ),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget imageStack() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
                color: Colors.white,
                image: DecorationImage(
                  image: localImage.isNotEmpty
                      ? FileImage(File(localImage))
                      : AssetImage('assets/images/profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 3,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Vibration.vibrate();
                  Get.to(CameraScreen())?.then((value) {
                    getSavedImage();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(Icons.edit, size: 20, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardWidget() {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.settings, size: 25, color: Colors.black),
                ),
                SizedBox(height: 15),
                Text(
                  "Abc Xyz",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "abc123@xyz.com",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                SizedBox(height: 10),
                if (latitude.isNotEmpty && longitude.isNotEmpty)
                  Text(
                    "Location: $latitude, $longitude",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return listTile(
                      title: menuItems[index]["title"],
                      icon: menuItems[index]["icon"],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          MyCustomButton(
            btnText: "Logout",
            onClick: () {},
            margin: EdgeInsets.symmetric(horizontal: 30),
          ),
        ],
      ),
    );
  }

  Widget listTile({required String title, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      onTap: () {
        // handle tap
      },
    );
  }
}
