import 'package:flutter/material.dart';

import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';
import '../../tools/eregion.dart';
import '../../tools/region_title_tools.dart';

class SelectRegionScreen extends StatefulWidget {
  final void Function(String)? selectRegion;
  const SelectRegionScreen({Key? key, this.selectRegion}) : super(key: key);

  @override
  State<SelectRegionScreen> createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  String _selectedRegion = "";

  @override
  void initState() {
    _selectedRegion = SheredPreferencesService.preferences.getString("subscribeRegion")!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ERegion.values.length,
        itemBuilder: (BuildContext context, int item) {
          return _buildCard(ERegion.values[item], ERegion.values[item].name);
        });
  }

  Widget _buildCard(ERegion region, String regionName) {
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 20)),
          backgroundColor: MaterialStateProperty.all<Color>(CustomColor.backgroundLight),
        ),
        onPressed: () {
          setState(() {
            _selectedRegion = regionName;
            widget.selectRegion?.call(_selectedRegion);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              RegionTitleTools.getRegionByEnum(region),
              style: TextStyle(
                color: CustomColor.textColor,
                fontSize: 15,
              ),
            ),
            _selectedRegion.contains(regionName) ? const Icon(Icons.done, color: CustomColor.green) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
