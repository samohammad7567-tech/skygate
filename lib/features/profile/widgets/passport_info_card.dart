import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/profile/widgets/profile_card.dart';
import 'package:skygate/features/profile/widgets/profile_tile.dart';

class PassportInfoCard extends StatelessWidget {
  const PassportInfoCard({super.key, required this.passport});

  final PassportDataModel passport;
  static String? _formatted(DateTime? value) =>
      value == null ? null : AppFormat.numericDate(value);

  @override
  Widget build(BuildContext context) {
    final gender = passport.gender;

    return ProfileCard(
      children: [
        ProfileTile(
          icon: ProfileAssets.account,
          title: 'passport_full_name_ar'.tr(),
          subtitle: passport.fullNameAr,
        ),
        ProfileTile(
          icon: ProfileAssets.account,
          title: 'passport_full_name_en'.tr(),
          subtitle: passport.fullNameEn,
        ),
        ProfileTile(
          icon: ProfileAssets.calendar,
          title: 'birth_date'.tr(),
          subtitle: _formatted(passport.birthDate),
        ),
        ProfileTile(
          icon: ProfileAssets.man,
          title: 'gender'.tr(),
          // `male` / `female` travel as keys, so the row translates them.
          subtitle: gender == null || gender.isEmpty ? null : gender.tr(),
        ),
        ProfileTile(
          icon: ProfileAssets.globe,
          title: 'nationality'.tr(),
          subtitle: passport.nationality,
        ),
        ProfileTile(
          icon: ProfileAssets.passport,
          title: 'passport_number'.tr(),
          subtitle: passport.passportNumber,
        ),
        ProfileTile(
          icon: ProfileAssets.idCard,
          title: 'national_number'.tr(),
          subtitle: passport.nationalNumber,
        ),
        ProfileTile(
          icon: ProfileAssets.assignmentGlobe,
          title: 'passport_issue_place'.tr(),
          subtitle: passport.issuePlace,
        ),
        ProfileTile(
          icon: ProfileAssets.calendar,
          title: 'issue_date'.tr(),
          subtitle: _formatted(passport.issueDate),
        ),
        ProfileTile(
          icon: ProfileAssets.calendar,
          title: 'expiry_date'.tr(),
          subtitle: _formatted(passport.expiryDate),
        ),
      ],
    );
  }
}
