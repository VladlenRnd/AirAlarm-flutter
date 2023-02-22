import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../tools/connection/response/config_response.dart';
import '../../../tools/custom_color.dart';
import '../../../tools/repository/config_repository.dart';

class NotWarWidget extends StatefulWidget {
  const NotWarWidget({super.key});

  @override
  State<NotWarWidget> createState() => _NotWarWidgetState();
}

class _NotWarWidgetState extends State<NotWarWidget> with TickerProviderStateMixin {
  ConfigResponse config = ConfigRepository.instance.config;
  late final AnimationController controller;
  late final AnimationController controller2;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    controller2 = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    controller2.addListener(() {
      if (controller2.status == AnimationStatus.completed) {
        controller.reset();
        controller2.reset();
      }
    });

    Future.delayed(const Duration(seconds: 1)).then((value) async {
      controller.forward();
      await Future.delayed(const Duration(seconds: 1));
      controller2.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () async {
              if (controller2.status == AnimationStatus.forward || controller.status == AnimationStatus.forward) return;
              controller.forward();
              await Future.delayed(const Duration(seconds: 1));
              controller2.forward();
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Colors.yellowAccent.withOpacity(0.5),
                      Colors.blueAccent..withOpacity(0.5),
                    ],
                  )),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Война окончена!", style: TextStyle(fontSize: 30, color: CustomColor.backgroundLight)),
                        if (config.startWarDate != null && config.endWarDate != null)
                          Text("${DateFormat("dd/MM/yyyy").format(config.startWarDate!)} - ${DateFormat("dd/MM/yyyy").format(config.endWarDate!)}",
                              style: const TextStyle(fontSize: 24, color: CustomColor.backgroundLight)),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: OverflowBox(
                    child: Lottie.asset(
                      'assets/lottie/salute.json',
                      controller: controller2,
                      fit: BoxFit.fill,
                      frameRate: FrameRate(120),
                      repeat: false,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: OverflowBox(
                    child: Lottie.asset(
                      'assets/lottie/salute.json',
                      controller: controller,
                      fit: BoxFit.fill,
                      frameRate: FrameRate(120),
                      repeat: false,
                    ),
                  ),
                ),
              ],
            )));
  }
}
