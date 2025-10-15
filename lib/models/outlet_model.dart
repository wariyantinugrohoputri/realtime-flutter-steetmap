class Outlet {
  final int idoutlet;
  final String outlet;
  final String alamat;
  final double lat;
  final double lng;

  Outlet({
    required this.idoutlet,
    required this.outlet,
    required this.alamat,
    required this.lat,
    required this.lng,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      idoutlet: json['idoutlet'],
      outlet: json['outlet'],
      alamat: json['alamat'] ?? '',
      lat:
          double.tryParse(json['latitude'].toString().replaceAll(',', '')) ??
          0.0,
      lng:
          double.tryParse(json['longitude'].toString().replaceAll(',', '')) ??
          0.0,
    );
  }
}
