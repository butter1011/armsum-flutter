import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> kDefaultRainbowColors = const [
      Colors.orange,
    ];
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.lineSpinFadeLoader,
          colors: kDefaultRainbowColors,
          strokeWidth: 1,
          backgroundColor: Colors.transparent,                
        ),
      ),
    ));
  }
}
