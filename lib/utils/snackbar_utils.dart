import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../presentation/themes/colors.dart';

class SnackbarUtils {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerState =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccessSnackbar({
    required String title,
    String? subTitle,
    bool? showButton,
    String? buttonLabel,
  }) {
    _showSnackbar(
      title: title,
      backgroundColor: AppColors.success.shade500,
      startIcon: const Icon(Icons.check, color: Colors.white, size: 40),
      subTitle: subTitle,
      showButton: showButton,
      buttonLabel: buttonLabel ?? 'Done',
    );
  }

  static void showErrorSnackbar({
    required String title,
    String? subTitle,
    bool? showButton,
    String? buttonLabel,
  }) {
    _showSnackbar(
      title: title,
      backgroundColor: AppColors.error.shade700,
      startIcon: const Icon(
        CupertinoIcons.clear_circled,
        color: Colors.white,
        size: 40,
      ),
      subTitle: subTitle,
      showButton: showButton,
      buttonLabel: buttonLabel ?? 'Dismiss',
    );
  }

  static void _showSnackbar({
    required String title,
    required Color backgroundColor,
    required Icon startIcon,
    String? subTitle,
    bool? showButton,
    String? buttonLabel,
  }) {
    scaffoldMessengerState.currentState?.showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Row(
              children: [
                const Gap(16),
                startIcon,
                const Gap(8),
                Expanded(
                  child: SizedBox(
                    width: 244,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(16),
                        Text(
                          title,
                          style: Theme.of(
                            scaffoldMessengerState.currentContext!,
                          ).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subTitle != null)
                          Text(
                            subTitle,
                            style: Theme.of(
                              scaffoldMessengerState.currentContext!,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        const Gap(16),
                      ],
                    ),
                  ),
                ),
                if (showButton == true)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(4),
                    ),
                    onPressed: () {
                      scaffoldMessengerState.currentState
                          ?.hideCurrentSnackBar();
                    },
                    child: Text(buttonLabel ?? ''),
                  ),
                const Gap(16),
              ],
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.zero,
        width: 400.0,
      ),
    );
  }
}
