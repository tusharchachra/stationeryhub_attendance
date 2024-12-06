import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

import 'subscription_type_enum.dart';

class OrganizationModel {
  String? id;
  String? name;
  String? address;
  double?
      geoLocationLat; //the the geolocation is stored separately as double because firestore does not support Position class
  double? geoLocationLong;
  DateTime? createdOn;
  DateTime? lastUpdatedOn;
  String? createdBy;
  String? profilePicPath;
  SubscriptionType? subscription;
  List<UsersModel>? users;

  OrganizationModel({
    this.id,
    this.name,
    this.address,
    this.geoLocationLat,
    this.geoLocationLong,
    this.createdOn,
    this.lastUpdatedOn,
    this.createdBy,
    this.profilePicPath,
    this.subscription,
    this.users,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address ?? '',
      'geoLocationLat': geoLocationLat ?? '',
      'geoLocationLong': geoLocationLong ?? '',
      'createdOn': createdOn?.toIso8601String(),
      'lastUpdatedOn': lastUpdatedOn?.toIso8601String(),
      'createdBy': createdBy,
      'profilePicPath': profilePicPath,
      'subscription': subscription?.name,
    };
  }

  factory OrganizationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return OrganizationModel(
        id: data?['id'],
        name: data?['name'],
        address: data?['address'],
        geoLocationLat: data?['geoLocationLat'] == ''
            ? null
            : double.parse(data?['geoLocationLat']),
        geoLocationLong: data?['geoLocationLong'] == ''
            ? null
            : double.parse(data?['geoLocationLong']),
        createdOn: DateTime.parse(data!['createdOn'].toString()),
        lastUpdatedOn: data['lastUpdatedOn'].toString() == ''
            ? null
            : DateTime.parse(data['lastUpdatedOn'].toString()),
        createdBy: data['createdBy'],
        profilePicPath: data['profilePicPath'],
        //converts the string to enum
        subscription: data['subscription'] == null
            ? null
            : SubscriptionType.values.byName(data['subscription']));
  }

  OrganizationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'].toString(),
        address = json['address'].toString(),
        geoLocationLat = json['geoLocationLat'] == ''
            ? null
            : double.parse(json['geoLocationLat'].toString()),
        geoLocationLong = json['geoLocationLong'] == ''
            ? null
            : double.parse(json['geoLocationLong'].toString()),
        createdOn = DateTime.parse(json['createdOn'].toString()),
        lastUpdatedOn = json['lastUpdatedOn'] == ''
            ? null
            : DateTime.parse(json['lastUpdatedOn'].toString()),
        createdBy = json['createdBy'].toString(),
        profilePicPath = json['profilePicPath'].toString() == ''
            ? ''
            : json['profilePicPath'].toString(),
        //converts the string to enum
        subscription = json['subscription'] == null
            ? null
            : SubscriptionType.values.byName(json['subscription'].toString());

  @override
  String toString() {
    return toJson().toString();
  }
}
