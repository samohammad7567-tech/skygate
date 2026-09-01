import 'package:skygate/core/constants/app_assets.dart';

/// One onboarding page: an illustration plus its localized copy.
///
/// The five pages are fixed design content — the text is a localization key and
/// the image is a bundled asset — so they ship as a local [pages] catalogue
/// rather than coming down from the API.
class OnBoardingPageModel {
  final String image;
  final String titleKey;
  final String descriptionKey;

  const OnBoardingPageModel({
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
  });

  /// In page order. Page 1 is the first the user sees; with an RTL locale the
  /// indicator therefore highlights its right-most dot.
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
