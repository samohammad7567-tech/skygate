import 'package:skygate/core/models/meta_model.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/user_profile_model.dart';
import 'package:skygate/core/utils/api_parse.dart';

class HomeModel {
  UserProfileModel? user;
  List<HomeCityModel> cities = const [];

  List<HomeNotificationModel> notifications = const [];
  HomeTripsPageModel trips = HomeTripsPageModel.empty();
  List<TripModel> vipTrips = const [];

  HomeModel.fromJson(Map<String, dynamic> json) {
    user = UserProfileModel.of(json['user']);
    cities = ApiParse.listOf(json['cities'], HomeCityModel.fromJson);
    notifications = ApiParse.listOf(
      json['notifications'],
      HomeNotificationModel.fromJson,
    );
    trips = HomeTripsPageModel.of(json['trips']);
    vipTrips = ApiParse.listOf(json['vip_trips'], TripModel.fromJson);
  }
  int get unreadNotifications => notifications.where((n) => !n.isRead).length;
}

class HomeTripsPageModel {
  HomeTripsPageModel({required this.items, required this.meta});

  HomeTripsPageModel.empty() : items = const [], meta = Meta.empty();

  final List<TripModel> items;
  final Meta meta;

  static HomeTripsPageModel of(dynamic value) {
    // A backend that has not been updated yet answers with a bare array.
    if (value is List) {
      return HomeTripsPageModel(
        items: ApiParse.listOf(value, TripModel.fromJson),
        meta: Meta.empty(),
      );
    }

    if (value is! Map) return HomeTripsPageModel.empty();

    return HomeTripsPageModel(
      items: ApiParse.listOf(value['items'], TripModel.fromJson),
      meta: Meta.of(value['meta']),
    );
  }
}

class HomeCityModel {
  int? id;
  int? countryId;
  String? country;

  String? city;

  HomeCityModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    countryId = ApiParse.intOf(json['country_id']);
    country = ApiParse.stringOf(json['country']);
    city = ApiParse.stringOf(json['city']);
  }
  bool matches(String query) {
    if (query.isEmpty) return true;
    return city?.toLowerCase().contains(query.toLowerCase()) ?? false;
  }
}

class HomeNotificationModel {
  int? id;
  String? title;
  String? body;
  String? type;

  DateTime? createdAt;
  DateTime? readAt;

  HomeNotificationModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    title = ApiParse.stringOf(json['title']);
    body = ApiParse.stringOf(json['body'] ?? json['message']);
    type = ApiParse.labelOf(json['type']);
    createdAt = ApiParse.dateOf(json['created_at']);
    readAt = ApiParse.dateOf(json['read_at']);
  }

  bool get isRead => readAt != null;
}
