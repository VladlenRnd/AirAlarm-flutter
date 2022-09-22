import 'package:flutter/material.dart';

void showFullScreanDialog(BuildContext context, List<String> imgList) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: _buildDescription(imgList, context),
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Закрыть'.toUpperCase(),
              )),
        ],
      );
    },
  );
}

Widget _buildDescription(List<String> url, BuildContext context) {
  return SizedBox(
    height: 400,
    width: MediaQuery.of(context).size.width,
    child: PageView.builder(
        itemCount: url.length,
        pageSnapping: true,
        itemBuilder: (context, pagePosition) {
          return Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  maxScale: 4,
                  minScale: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Image.network(
                      url[pagePosition],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text("${pagePosition + 1} / ${url.length}"),
                ),
              ),
            ],
          );
        }),
  );
}
