import 'package:flutter/material.dart';

import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';
import '../../tools/eregion.dart';
import '../../tools/region_title.dart';

class SelectRegionScreen extends StatefulWidget {
  const SelectRegionScreen({Key? key}) : super(key: key);

  @override
  State<SelectRegionScreen> createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  List<String> _selectedRegion = [];

  @override
  void initState() {
    _selectedRegion = SheredPreferencesService.preferences.getStringList("subscribe")!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        leading: _buildBackButton(),
        actions: [_buildSave()],
        backgroundColor: CustomColor.backgroundLight,
        title: const Text("Области"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: ERegion.values.length,
          itemBuilder: (BuildContext context, int item) {
            return _buildCard(ERegion.values[item], ERegion.values[item].name);
          }),
    );
  }

  Widget _buildCard(ERegion region, String regionName) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 20)),
          backgroundColor: MaterialStateProperty.all<Color>(CustomColor.backgroundLight),
        ),
        onPressed: () {
          setState(() {
            _selectedRegion.contains(regionName) ? _selectedRegion.remove(regionName) : _selectedRegion.add(regionName);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              RegionTitle.getRegionByEnum(region),
              style: TextStyle(
                color: CustomColor.textColor,
                fontSize: 15,
              ),
            ),
            _selectedRegion.contains(regionName) ? Icon(Icons.done, color: CustomColor.green) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildSave() {
    return IconButton(
        onPressed: () {
          SheredPreferencesService.preferences.setStringList("subscribe", _selectedRegion);
          Navigator.pop(context, true);
        },
        icon: const Icon(Icons.done));
  }

  Widget _buildBackButton() {
    return IconButton(onPressed: () => Navigator.pop(context, false), icon: const Icon(Icons.close));
  }
}
