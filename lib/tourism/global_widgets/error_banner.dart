import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/failures/base_failure.dart';
import '../core/utils/helpers/parse_helpers/failure_parser.dart';

class ErrorBanner extends StatelessWidget {
  final Failure? failure;
  final VoidCallback? tryAgain;

  const ErrorBanner({super.key, required this.failure, this.tryAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red),
      ),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10.h, top: 10.h),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  FailureParser.mapFailureToString(
                    failure: failure,
                    context: context,
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
            if (tryAgain != null)
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.red),
                  onPressed: tryAgain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
