import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class SplashOutlinedButton extends StatelessWidget {
  const SplashOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (height ?? 46.s),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.85)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.s),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 18.s,
                width: 18.s,
                child: CircularProgressIndicator(
                  strokeWidth: 2.s,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
