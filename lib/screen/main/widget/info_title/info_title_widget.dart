import 'package:alarm/tools/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/info_title_cubit.dart';

class InfoTitleWidget extends StatelessWidget {
  const InfoTitleWidget({super.key});

  Widget _buildTitle(String msg) {
    return Center(
      child: Text(msg, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildLoadInfo(String msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 17,
          width: 17,
          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(CustomColor.systemSecondary)),
        ),
        const SizedBox(width: 10),
        _buildTitle(msg),
      ],
    );
  }

  Widget _buildInfoIcon(String msg, Icon icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 10),
        _buildTitle(msg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget lastWidget = const SizedBox.shrink();
    return BlocBuilder<InfoTitleCubit, InfoTitleState>(
      builder: (context, InfoTitleState state) {
        return AnimatedOpacity(
            opacity: (state is InfoIdle) ? 0 : 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInExpo,
            child: switch (state) {
              InfoIdle() => lastWidget,
              InfoLoad(loadMessage: String msg) => lastWidget = _buildLoadInfo(msg),
              InfoError(errorMessage: String msg) => lastWidget =
                  _buildInfoIcon(msg, const Icon(Icons.error_outline_outlined, color: CustomColor.red)),
              InfoSuccess(successMessage: String msg) => lastWidget = _buildInfoIcon(msg, const Icon(Icons.download_done, color: CustomColor.green)),
              InfoMessage(infoMessage: String msg) => lastWidget = _buildTitle(msg),
            });
      },
      bloc: InfoTitleCubit(),
    );
  }
}
