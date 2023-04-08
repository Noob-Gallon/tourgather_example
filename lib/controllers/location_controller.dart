// ignore_for_file: avoid_print

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tourgather/essential/essential.dart';

// Geolocator를 통해 GPS 데이터를 받아오는 과정을
// 처리하는 Controller Class.
class LocationController extends GetxController {
  bool _serviceEnabled = false;
  int xDiff = 0;
  int yDiff = 0;
  double xPercent = 0;
  double yPercent = 0;
  double userPosX = 0;
  double userPosY = 0;

  Position? curPosition;
  late StreamSubscription<Position> positionStream;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );

  void calcUserPos() {
    // yPercent와 xPercent 위치를 바꾸니까 제대로 계산됨.
    // 위도와 경도를 계산하는 과정에서 헷갈렸던 것 같은데, 확인 필요함.
    userPosX = (essential.screenWidth * yPercent) - 15;
    userPosY = 300 * (1 - xPercent) - 15;
    print('$userPosX, $userPosY');

    // update를 부르면 오류 발생?
    // 원인 파악 필요
    // update();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission? permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error("Location service ard disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location Permissions are permanently denied, we cannot request permissions.",
      );
    }

    Geolocator.getCurrentPosition().then(
      (Position? newPosition) {
        if (newPosition != null) {
          curPosition = newPosition;
          update();

          // PositionStream을 통해서
          // 주기적으로 데이터를 전달받는다.
          positionStream =
              Geolocator.getPositionStream(locationSettings: locationSettings)
                  .listen(
            (Position? newPosition) {
              if (newPosition != null) {
                // Geolocator Stream data를 전달 받고나면,
                // curPosition을 newPostion으로 업데이트한다.
                // 이후, update() 메서드를 실행시켜서
                // controller의 position 데이터가 변경되었음을 알린다.
                curPosition = newPosition;
                update();
              }
            },
          );
        } else {
          // 무언가 오류가 발생한 상황.
          // 적절한 대처를 추가해야 함.
          return Future.error("An error occurred on fetching location data...");
        }
      },
    );
  }
}
