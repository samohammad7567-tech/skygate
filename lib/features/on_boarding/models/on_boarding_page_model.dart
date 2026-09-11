import 'package:skygate/core/constants/app_assets.dart';

class OnBoardingPageModel {
  final String image;
  final String titleKey;
  final String descriptionKey;

  const OnBoardingPageModel({
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
  });
  static const List<OnBoardingPageModel> pages = [
    OnBoardingPageModel(
      image: AppAssets.onboarding1,
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
    ),
    OnBoardingPageModel(
      image: AppAssets.onboarding2,
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
    ),
    OnBoardingPageModel(
      image: AppAssets.onboarding3,
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
    ),
    OnBoardingPageModel(
      image: AppAssets.onboarding4,
      titleKey: 'onboarding_title_4',
      descriptionKey: 'onboarding_desc_4',
    ),
    OnBoardingPageModel(
      image: AppAssets.onboarding5,
      titleKey: 'onboarding_title_5',
      descriptionKey: 'onboarding_desc_5',
    ),
  ];
}
