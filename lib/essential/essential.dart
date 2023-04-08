class Essential {
  late double _screenWidth;
  late double _screenHeight;
  final _imagePath = 'assets/images';

  get screenWidth => _screenWidth;
  get screenHeight => _screenHeight;
  get imagePath => _imagePath;

  void setScreenSize(width, height) {
    _screenWidth = width;
    _screenHeight = height;
  }
}

var essential = Essential();
