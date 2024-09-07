import 'package:cloud_firestore/cloud_firestore.dart';

import 'subscription_type_enum.dart';

class OrganizationModel {
  String? id;
  String? name;
  String? address;
  double?
      geoLocationLat; //the the geolocation is stored separately as double because firestore does not support Position class
  double? geoLocationLong;
  DateTime? createdOn;
  String? createdBy;
  SubscriptionType? subscription;

  OrganizationModel({
    this.id,
    this.name,
    this.address,
    this.geoLocationLat,
    this.geoLocationLong,
    this.createdOn,
    this.createdBy,
    this.subscription,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'geoLocationLat': geoLocationLat ?? '',
      'geoLocationLong': geoLocationLong ?? '',
      'createdOn': createdOn?.toIso8601String(),
      'createdBy': createdBy,
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
        createdBy: data['createdBy'],
        subscription: data['subscription'] == null
            ? null
            : SubscriptionType.values
                .byName(data['subscription'])); //converts the string to enum
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
        createdBy = json['createdBy'].toString(),
        subscription = json['subscription'] == null
            ? null
            : SubscriptionType.values.byName(
                json['subscription'].toString()); //converts the string to enum

  @override
  String toString() {
    return toJson().toString();
  }
}
