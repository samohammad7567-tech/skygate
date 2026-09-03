import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/failures/base_failure.dart';
import '../core/utils/helpers/parse_helpers/failure_parser.dart';

class ErrorPanel extends StatelessWidget {
  final Failure? failure;
  final onTryAgain;


  ErrorPanel({required this.failure, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/error.png",
              height: 100.h,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 15.0.h,
            ),
            Text(
              FailureParser.mapFailureToString(failure: failure, context: context),
              style:
                  Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
            ),
            SizedBox(
              height: 15.0.h,
            ),
            if (onTryAgain != null)
              OutlinedButton(
                onPressed: onTryAgain,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(150.w, 50.h),
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color:Theme.of(context).colorScheme.error, )
                ),
                child: Text(
                  tr('tryAgain'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
