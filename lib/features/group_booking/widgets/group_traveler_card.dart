import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';
import 'package:skygate/core/components/audience_chip.dart';
import 'package:skygate/features/group_booking/widgets/group_detail_row.dart';

class GroupTravelerCard extends StatelessWidget {
  const GroupTravelerCard({
    super.key,
    required this.traveler,
    required this.position,
    required this.guardianName,
  });

  final GroupTravelerModel traveler;
  final int position;
  final String? guardianName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final passport = traveler.passport;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            traveler: traveler,
            position: position,
            isLeader: position == 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GroupDetailRow(
                  icon: AuthAssets.accountCircle,
                  label: 'full_name_ar'.tr(),
                  value: passport.fullNameAr,
                ),
                GroupDetailRow(
                  icon: AuthAssets.calendar,
                  label: 'birth_date'.tr(),
                  value: AppFormat.shortDate(passport.birthDate, locale),
                ),
                GroupDetailRow(
                  icon: AuthAssets.passport,
                  label: 'passport_number'.tr(),
                  value: passport.passportNumber,
                ),
                GroupDetailRow(
                  icon: AuthAssets.calendar,
                  label: 'expiry_date'.tr(),
                  value: AppFormat.shortDate(passport.expiryDate, locale),
                  showDivider: guardianName != null,
                ),
                if (guardianName != null)
                  GroupDetailRow(
                    icon: AuthAssets.man,
                    label: 'guardian_label'.tr(),
                    value: guardianName,
                    showDivider: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.traveler,
    required this.position,
    required this.isLeader,
  });

  final GroupTravelerModel traveler;
  final int position;
  final bool isLeader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(14.s, 10.s, 14.s, 10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.s)),
      ),
      child: Row(
        children: [
          PositionBadge(position: position),
          Gap(12.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  traveler.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (isLeader)
                  Text(
                    'group_leader'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Gap(10.s),
          AudienceChip(audience: traveler.audience),
        ],
      ),
    );
  }
}
