import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/region_model.dart';
import '../../../../tools/custom_color.dart';
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
          child: AspectRatio(
            aspectRatio: 1.1,
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SvgPicture.string(
                    fit: BoxFit.fitWidth,
                    UkrainSvg.getSvgStr(regions: [], defaultColor: CustomColor.colorMapEmbossing, strokeColor: CustomColor.colorMapEmbossing),
                    placeholderBuilder: (BuildContext context) => const SizedBox.shrink(),
                  ),
                ),
                Positioned.fill(
                  child: SvgPicture.string(
                    UkrainSvg.getSvgStr(regions: allRegion),
                    placeholderBuilder: (BuildContext context) => Center(
                      child: Lottie.asset('assets/lottie/load2.json', width: 250, height: 250, frameRate: FrameRate(60)),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.759, 0.52),
                  child: _buildMapText(context, "Днепропетровск", "9", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.97, 0.44),
                  child: _buildMapText(context, "Луганск", "16", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.90, 0.56),
                  child: _buildMapText(context, "Донецк", "28"),
                ),
                Align(
                  alignment: FractionalOffset(0.785, 0.65),
                  child: _buildMapText(context, "Запорожье", "12", fontSize: 6.5),
                ),
                Align(
                  alignment: FractionalOffset(0.65, 0.695),
                  child: _buildMapText(context, "Херсон", "23"),
                ),
                Align(
                  alignment: FractionalOffset(0.68, 0.84),
                  child: _buildMapText(context, "АР Крым", "29", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.84, 0.37),
                  child: _buildMapText(context, "Харьков", "22", fontSize: 9),
                ),
                Align(
                  alignment: FractionalOffset(0.665, 0.37),
                  child: _buildMapText(context, "Полтава", "19", fontSize: 9),
                ),
                Align(
                  alignment: FractionalOffset(0.68, 0.24),
                  child: _buildMapText(context, "Сумы", "20", fontSize: 9),
                ),
                Align(
                  alignment: FractionalOffset(0.539, 0.19),
                  child: _buildMapText(context, "Чернигов", "25", fontSize: 7),
                ),
                Align(
                  alignment: FractionalOffset(0.46, 0.32),
                  child: _buildMapText(context, "Киев", "14", fontSize: 11),
                ),
                Align(
                  alignment: FractionalOffset(0.515, 0.43),
                  child: _buildMapText(context, "Черкасы", "24", fontSize: 8),
                ),
                Align(
                  alignment: FractionalOffset(0.548, 0.51),
                  child: _buildMapText(context, "Кировоград", "15"),
                ),
                Align(
                  alignment: FractionalOffset(0.55, 0.63),
                  child: _buildMapText(context, "Николаев", "17", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.445, 0.64),
                  child: _buildMapText(context, "Одесса", "18", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.325, 0.265),
                  child: _buildMapText(context, "Житомир", "10", fontSize: 7),
                ),
                Align(
                  alignment: FractionalOffset(0.35, 0.45),
                  child: _buildMapText(context, "Винница", "4", fontSize: 7),
                ),
                Align(
                  alignment: FractionalOffset(0.228, 0.19),
                  child: _buildMapText(context, "Ровно", "5", fontSize: 7),
                ),
                Align(
                  alignment: FractionalOffset(0.10, 0.21),
                  child: _buildMapText(context, "Волынская", "8", fontSize: 7),
                ),
                Align(
                  alignment: FractionalOffset(0.249, 0.378),
                  child: _buildMapText(context, "Хмель-\nницкий", "3", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.17, 0.41),
                  child: _buildMapText(context, "Терно-\nполь", "21", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.06, 0.37),
                  child: _buildMapText(context, "Львов", "27", fontSize: 8),
                ),
                Align(
                  alignment: FractionalOffset(0.02, 0.52),
                  child: _buildMapText(context, "Закарпат.", "11", fontSize: 6),
                ),
                Align(
                  alignment: FractionalOffset(0.11, 0.48),
                  child: _buildMapText(context, "Ивано-\nФранковск", "13", fontSize: 5),
                ),
                Align(
                  alignment: FractionalOffset(0.175, 0.54),
                  child: _buildMapText(context, "Черновцы", "26", fontSize: 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapText(BuildContext context, String region, String uid, {double fontSize = 7}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size(25, 25),
      alignment: Alignment.center,
      onPressed: () {
        onTap.call(allRegion.firstWhere((element) => element.uid == uid));
      },
      child: Text(
        region,
        style: TextStyle(fontSize: fontSize, color: Colors.white.withValues(alpha: (0.8)), fontWeight: FontWeight.w800, letterSpacing: 0.8),
      ),
    );
  }
}
