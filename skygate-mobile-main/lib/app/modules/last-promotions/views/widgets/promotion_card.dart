import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';

class PromotionCard extends StatelessWidget {
  PromotionCard(
      {super.key, this.from, this.to, this.image, this.price, this.currency});

  String? from;
  String? to;
  String? image;
  String? price;
  String? currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170.0.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(NetworkRoutesControl.imageUrl + image!),
          fit: BoxFit.fill,
          opacity: 0.3,
        ),
        boxShadow: const [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: Colors.grey,
            blurRadius: 15.0,
            offset: Offset(0, 0.0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 22.0.w, bottom: 22.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${from} - ${to}",
              style: context.textTheme.displaySmall!.copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "ابتداءً من ${price} ${currency}",
              style: context.textTheme.displaySmall!.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
