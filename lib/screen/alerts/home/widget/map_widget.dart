import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/region_model.dart';
import '../../../../tools/custom_color.dart';
import '../../../../tools/region/eregion.dart';
import '../../../../tools/ukrain_svg.dart';

class MapWidget extends StatelessWidget {
  final List<RegionModel> allRegion;
  final Function(RegionModel) onTap;
  const MapWidget({super.key, required this.allRegion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        maxScale: 3,
        minScale: 1,
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: CustomColor.background,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300, maxWidth: 380, minHeight: 300, minWidth: 380),
              child: LayoutBuilder(builder: ((context, constraints) {
                double w = constraints.maxWidth;
                double h = constraints.minHeight;

                return Stack(
                  children: [
                    Positioned(
                      top: 38,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SvgPicture.string(
                        fit: BoxFit.fitWidth,
                        UkrainSvg.getSvgStr(regions: [], defaultColor: CustomColor.colorMapEmbossing, strokeColor: CustomColor.colorMapEmbossing),
                        placeholderBuilder: (BuildContext context) => const SizedBox.shrink(),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SvgPicture.string(
                        fit: BoxFit.fitWidth,
                        UkrainSvg.getSvgStr(regions: allRegion),
                        placeholderBuilder: (BuildContext context) => Center(
                          child: Lottie.asset('assets/lottie/load2.json', width: 250, height: 250, frameRate: FrameRate(60)),
                        ),
                      ),
                    ),
                    Positioned(top: h * 0.55, left: w * 0.645, child: _buildMapText(context, "Днепропетровск", ERegion.dnipro, fontSize: 6)),
                    Positioned(top: h * 0.48, left: w * 0.87, child: _buildMapText(context, "Луганск", ERegion.lugan, fontSize: 6)),
                    Positioned(top: h * 0.6, left: w * 0.80, child: _buildMapText(context, "Донецк", ERegion.donetsk)),
                    Positioned(top: h * 0.66, left: w * 0.69, child: _buildMapText(context, "Запорожье", ERegion.zapor, fontSize: 6.5)),
                    Positioned(top: h * 0.72, left: w * 0.58, child: _buildMapText(context, "Херсон", ERegion.herson)),
                    Positioned(top: h * 0.85, left: w * 0.60, child: _buildMapText(context, "АР Крым", ERegion.krim, fontSize: 6)),
                    Positioned(top: h * 0.4, left: w * 0.74, child: _buildMapText(context, "Харьков", ERegion.harkiv, fontSize: 9)),
                    Positioned(top: h * 0.4, left: w * 0.59, child: _buildMapText(context, "Полтава", ERegion.poltava, fontSize: 9)),
                    Positioned(top: h * 0.27, left: w * 0.595, child: _buildMapText(context, "Сумы", ERegion.sumska, fontSize: 9)),
                    Positioned(top: h * 0.24, left: w * 0.481, child: _buildMapText(context, "Чернигов", ERegion.chernigev, fontSize: 7)),
                    Positioned(top: h * 0.34, left: w * 0.415, child: _buildMapText(context, "Киев", ERegion.kyiv, fontSize: 11)),
                    Positioned(top: h * 0.46, left: w * 0.46, child: _buildMapText(context, "Черкасы", ERegion.cherkasy, fontSize: 8)),
                    Positioned(top: h * 0.54, left: w * 0.49, child: _buildMapText(context, "Кировоград", ERegion.kirovograd)),
                    Positioned(top: h * 0.66, left: w * 0.49, child: _buildMapText(context, "Николаев", ERegion.mikolaev, fontSize: 6)),
                    Positioned(top: h * 0.67, left: w * 0.391, child: _buildMapText(context, "Одесса", ERegion.odesa, fontSize: 6)),
                    Positioned(top: h * 0.31, left: w * 0.285, child: _buildMapText(context, "Житомир", ERegion.jitomer, fontSize: 7)),
                    Positioned(top: h * 0.5, left: w * 0.30, child: _buildMapText(context, "Винница", ERegion.vinetsk, fontSize: 7)),
                    Positioned(top: h * 0.24, left: w * 0.195, child: _buildMapText(context, "Ровно", ERegion.rivno, fontSize: 7)),
                    Positioned(top: h * 0.25, left: w * 0.10, child: _buildMapText(context, "Волынская", ERegion.volinska, fontSize: 7)),
                    Positioned(top: h * 0.40, left: w * 0.21, child: _buildMapText(context, "Хмель-\nницкий", ERegion.hmelnytsk, fontSize: 6)),
                    Positioned(top: h * 0.44, left: w * 0.14, child: _buildMapText(context, "Терно-\nполь", ERegion.ternopil, fontSize: 6)),
                    Positioned(top: h * 0.4, left: w * 0.05, child: _buildMapText(context, "Львов", ERegion.lvow, fontSize: 8)),
                    Positioned(top: h * 0.555, left: w * 0.001, child: _buildMapText(context, "Закарпат.", ERegion.zakarpatska, fontSize: 6)),
                    Positioned(
                        top: h * 0.51, left: w * 0.09, child: _buildMapText(context, "Ивано-\nФранковск", ERegion.ivanoFrankowsk, fontSize: 5)),
                    Positioned(top: h * 0.58, left: w * 0.15, child: _buildMapText(context, "Черновцы", ERegion.chernivets, fontSize: 5)),
                  ],
                );
              })),
            )));
  }

  Widget _buildMapText(BuildContext context, String region, ERegion eregion, {double fontSize = 7}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      onPressed: () {
        onTap.call(allRegion.firstWhere((element) => element.region == eregion));
      },
      child: Text(
        region,
        style: TextStyle(fontSize: fontSize, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w800, letterSpacing: 0.8),
      ),
    );
  }
}
