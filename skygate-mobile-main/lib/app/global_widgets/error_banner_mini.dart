import 'package:flutter/material.dart';

class ErrorBannerMini extends StatelessWidget {
  final tryAgain;

  const ErrorBannerMini({Key? key, this.tryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red,)
      ),
      padding: const EdgeInsets.all(4),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(
              width: 10,
            ),
            if (tryAgain != null)
              IconButton(
                icon:  Icon(Icons.refresh,color: Colors.red,),
                onPressed: tryAgain
              ),
          ],
        ),
      ),
    );
  }
}
