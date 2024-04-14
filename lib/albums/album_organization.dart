class AlbumOrganization {
  final String name;
  final String address;
  final String geoLocation;

  AlbumOrganization({
    required this.name,
    required this.address,
    required this.geoLocation,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'geo_location': geoLocation,
      };

  AlbumOrganization.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        address = json['address'].toString(),
        geoLocation = json['geo_location'].toString();

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
