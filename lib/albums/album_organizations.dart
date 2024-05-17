import 'package:cloud_firestore/cloud_firestore.dart';

import 'enum_subscription_type.dart';

class AlbumOrganization {
  final String name;
  final String address;
  final double?
      geoLocationLat; //the the geolocation is stores separately as doubles because firestore does not support Position class
  final double? geoLocationLong;
  final DateTime createdOn;
  final String createdBy;
  final SubscriptionType subscription;

  AlbumOrganization({
    required this.name,
    required this.address,
    this.geoLocationLat,
    this.geoLocationLong,
    required this.createdOn,
    required this.createdBy,
    required this.subscription,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'geoLocationLat': geoLocationLat ?? '',
      'geoLocationLong': geoLocationLong ?? '',
      'createdOn': createdOn.toIso8601String(),
      'createdBy': createdBy,
      'subscription': subscription.name,
    };
  }

  factory AlbumOrganization.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AlbumOrganization(
        name: data?['name'],
        address: data?['address'],
        geoLocationLat: data?['geoLocationLat'],
        geoLocationLong: data?['geoLocationLong'],
        createdOn: DateTime.parse(data!['createdOn'].toString()),
        createdBy: data['createdBy'],
        subscription: SubscriptionType.values
            .byName(data['subscription'])); //converts the string to enum
  }

  AlbumOrganization.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        address = json['address'].toString(),
        geoLocationLat = double.parse(json['geoLocationLat'].toString()),
        geoLocationLong = double.parse(json['geoLocationLong'].toString()),
        createdOn = DateTime.parse(json['createdOn'].toString()),
        createdBy = json['createdBy'].toString(),
        subscription = SubscriptionType.values.byName(
            json['subscription'].toString()); //converts the string to enum

  @override
  String toString() {
    return toJson().toString();
  }
}
