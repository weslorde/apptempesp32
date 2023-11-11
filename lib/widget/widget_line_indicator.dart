import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class LineTemperatureProgress extends StatefulWidget {
  const LineTemperatureProgress({super.key, this.temp = 0, required this.name});

  final int temp;
  final String name;

  @override
  State<LineTemperatureProgress> createState() =>
      _LineTemperatureProgressState();
}

class _LineTemperatureProgressState extends State<LineTemperatureProgress> {
  int totalSteps = 310;

  @override
  Widget build(BuildContext context) {
    int currentStep = widget.temp;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.temp}º',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Stack(children: [
          StepProgressIndicator(
            size: 15,
            roundedEdges: const Radius.circular(10),
            padding: 0,
            currentStep: currentStep,
            totalSteps: totalSteps,
            selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amber,
                  Color.lerp(
                      Colors.amber, Colors.red, (currentStep / totalSteps))!
                ]),
            unselectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(Colors.amber.withAlpha(70),
                      Colors.red.withAlpha(70), (currentStep / totalSteps))!,
                  Colors.red.withAlpha(70)
                ]),
            //customColor: ColorCircularProgress,
          ),
          /*Transform(
              transform: Matrix4.translationValues(340, 1.5, 0),
              child: const Icon(
                Icons.circle,
                color: Colors.white,
                size: 12,
              ))*/
        ]),
      ],
    );
  }
}
