import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
     List<Color> kDefaultRainbowColors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return Center(
        child: SizedBox(
      width: 80,
      height: 80,
      child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,
        colors: kDefaultRainbowColors,
        strokeWidth: 0.5,
        backgroundColor: Colors.transparent,
        pause: false,
      ),
    ));
  }
}

