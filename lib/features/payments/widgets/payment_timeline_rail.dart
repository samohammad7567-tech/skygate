import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PaymentTimelineRail extends StatelessWidget {
  const PaymentTimelineRail({
    super.key,
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.isDue,
  });

  final Color color;
  final bool isFirst;
  final bool isLast;
  final bool isDue;

  static const double _dot = 28;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _dot,
      child: Column(
        children: [
          Expanded(
            child: _Connector(color: color, show: !isFirst),
          ),
          Container(
            height: _dot,
            width: _dot,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              isDue ? Icons.schedule : Icons.check_rounded,
              size: 16.s,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Expanded(
            child: _Connector(color: color, show: !isLast),
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.color, required this.show});

  final Color color;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(width: 3.s, color: show ? color : Colors.transparent),
    );
  }
}
