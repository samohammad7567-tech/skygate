import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/controller/cubit/sos_cubit.dart';

class SosHoldButton extends StatelessWidget {
  const SosHoldButton({super.key});

  static const double _size = 168;
  static const double _halo = 232;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        final cubit = context.read<SosCubit>();
        final isSending = state is SosSending;
        final isRaised = cubit.isRaised;

        return GestureDetector(
          onTapDown: isSending || isRaised ? null : (_) => cubit.startHold(),
          onTapUp: (_) => cubit.cancelHold(),
          onTapCancel: cubit.cancelHold,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: _halo,
            width: _halo,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _Halo(diameter: _halo, opacity: 0.12),
                _Halo(diameter: (_halo + _size) / 2, opacity: 0.20),
                CustomPaint(
                  size: const Size.square(_size + 14),
                  painter: _HoldRingPainter(progress: cubit.holdProgress),
                ),
                _Disc(isSending: isSending, isRaised: isRaised),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.diameter, required this.opacity});

  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
    height: diameter,
    width: diameter,
    decoration: BoxDecoration(
      color: AppColors.error.withValues(alpha: opacity),
      shape: BoxShape.circle,
    ),
  );
}

class _Disc extends StatelessWidget {
  const _Disc({required this.isSending, required this.isRaised});

  final bool isSending;
  final bool isRaised;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: SosHoldButton._size,
      width: SosHoldButton._size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // The design's disc is lit from the top, which a flat fill loses.
        gradient: RadialGradient(
          center: Alignment(0, -0.4),
          radius: 1,
          colors: [Color(0xFFE04A4A), AppColors.error, Color(0xFF9E1B1B)],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Center(
        child: isSending
            ? SizedBox(
                height: 34.s,
                width: 34.s,
                child: CircularProgressIndicator(
                  strokeWidth: 3.s,
                  color: Colors.white,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppImage(
                    isRaised ? SosAssets.read : SosAssets.quickSos,
                    height: 30.s,
                    width: 30.s,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6.s),
                  Text(
                    'sos'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 2.s),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.s),
                    child: Text(
                      isRaised ? 'sos_raised_short'.tr() : 'sos_hold_hint'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  _HoldRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 3,
    );

    canvas.drawArc(
      rect,
      // Starts at twelve o'clock and sweeps clockwise, which reads as filling
      // up in either text direction.
      -1.5707963,
      6.2831853 * progress.clamp(0, 1),
      false,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_HoldRingPainter old) => old.progress != progress;
}
