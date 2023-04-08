// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourgather/controllers/location_controller.dart';
import 'package:tourgather/essential/essential.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final LocationController locationController = Get.put(LocationController());
  double xPos = 0;
  double yPos = 0;

  @override
  void initState() {
    super.initState();
    startToFetchingLocation();
  }

  void startToFetchingLocation() async {
    await locationController.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('TourGather example'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    child: GetBuilder<LocationController>(
                      builder: (_) {
                        if (locationController.curPosition == null) {
                          return const Text('Fetching the location data...');
                        } else {
                          yPos = locationController.curPosition!.latitude;
                          xPos = locationController.curPosition!.longitude;

                          if (yPos >= 37.3745000 &&
                              yPos <= 37.3748580 &&
                              xPos >= 126.6328750 &&
                              xPos <= 126.6335400) {
                            // 좌표 계산
                            locationController.xDiff =
                                ((yPos - 37.3745000) * 10000000).toInt();
                            locationController.yDiff =
                                ((xPos - 126.6328750) * 10000000).toInt();

                            print(
                              'You Are In! ${locationController.xDiff} ${locationController.yDiff}',
                            );

                            locationController.xPercent =
                                locationController.xDiff / 3580;
                            locationController.yPercent =
                                locationController.yDiff / 6650;
                            print(
                              '${locationController.xPercent}, ${locationController.yPercent}',
                            );

                            locationController.calcUserPos();
                          }

                          return Text(
                            'latitude(${locationController.curPosition!.latitude}), longitude(${locationController.curPosition!.longitude})',
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: essential.screenWidth,
                        height: 300,
                        child: Image.asset(
                          '${essential.imagePath}/map_01.png',
                          width: essential.screenWidth,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GetBuilder<LocationController>(
                        builder: (_) {
                          return Positioned(
                            left: locationController.userPosX,
                            top: locationController.userPosY,
                            child: IconButton(
                              icon: const Icon(Icons.person),
                              iconSize: 30,
                              onPressed: () {
                                print('Icon Pressed!');
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
