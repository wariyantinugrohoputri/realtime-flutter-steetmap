class Absensi {
  final int? idabsensiguru;
  final String? tanggal;
  final int? guruIdguru;
  final int? outletIdoutlet;
  final String? jadwalbelajar;
  final String? jamdatang;
  final String? jampulang;
  final String? tglentry;
  final String? status;
  final int? fee;

  Absensi({
    this.idabsensiguru,
    this.tanggal,
    this.guruIdguru,
    this.outletIdoutlet,
    this.jadwalbelajar,
    this.jamdatang,
    this.jampulang,
    this.tglentry,
    this.status,
    this.fee,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      idabsensiguru: json['idabsensiguru'],
      tanggal: json['tanggal'],
      guruIdguru: json['guru_idguru'],
      outletIdoutlet: json['outlet_idoutlet'],
      jadwalbelajar: json['jadwalbelajar'],
      jamdatang: json['jamdatang'],
      jampulang: json['jampulang'],
      tglentry: json['tglentry'],
      status: json['status'],
      fee: json['fee'],
    );
  }
}
