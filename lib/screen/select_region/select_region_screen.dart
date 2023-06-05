import 'package:flutter/material.dart';

import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';
import '../../tools/region/eregion.dart';

class SelectRegionWidget extends StatefulWidget {
  final void Function(String)? selectRegion;
  const SelectRegionWidget({Key? key, this.selectRegion}) : super(key: key);

  @override
  State<SelectRegionWidget> createState() => _SelectRegionWidgetState();
}

class _SelectRegionWidgetState extends State<SelectRegionWidget> {
  String _selectedRegion = "";

  @override
  void initState() {
    _selectedRegion = SheredPreferencesService.preferences.getString("subscribeRegion")!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: ERegion.values.length,
          itemBuilder: (BuildContext context, int item) {
            return _buildCard(ERegion.values[item], ERegion.values[item].name);
          }),
    );
  }

  Widget _buildCard(ERegion region, String regionName) {
    return Column(
      children: [
        const Divider(height: 2, thickness: 1),
        SizedBox(
          height: 80,
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 20)),
              backgroundColor: MaterialStateProperty.all<Color>(CustomColor.background),
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
                  region.title,
                  style: const TextStyle(
                    color: CustomColor.textColor,
                    fontSize: 15,
                  ),
                ),
                _selectedRegion.contains(regionName) ? const Icon(Icons.done, color: CustomColor.green) : const SizedBox.shrink(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
