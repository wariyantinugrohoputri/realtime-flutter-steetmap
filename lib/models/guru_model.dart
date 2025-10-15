class Guru {
  final int idguru;
  final String? jamluang;
  final String status;
  final String guru;
  final String gurupanggilan;
  final int outlet_idoutlet;
  final String? outliet; // Added field
  final int programIdprogram;
  final String? program; // Added field
  final String? alamat;
  final String? nohp;
  final String? tmptlahir;
  final String? tgllahir;
  final int jabatanIdjabatan;
  final String? jabatan; // Added field
  final int iq;
  final String tipeIdtipe;
  final String? tipe; // Added field
  final int skor;
  final int subtraitIdsubtrait;
  final String? subtrait; // Added field
  final int komtraitIdkomtrait;
  final String? komtrait; // Added field
  final String? grafik;
  final int discnaikIddiscnaik;
  final String? discnaik; // Added field
  final int discturunIddiscturun;
  final String? discturun; // Added field
  final String tglmasuk;
  final String statusguru;
  final String? email;
  final int akreditasiIdakreditasi;
  final String? akreditasi; // Added field
  final int? akreditasiIdakreditasierb;
  final String? akreditasierb; // Added field
  final String password;
  final String penguji;
  final String ketpenguji;
  final String? norekening;
  final String? anrekening;
  final String? bank;
  final String? filename;
  final String? createdAt;
  final String? updatedAt;
  final int devisiIddevisi;
  final String? devisi; // Added field

  Guru({
    required this.idguru,
    this.jamluang,
    required this.status,
    required this.guru,
    required this.gurupanggilan,
    required this.outlet_idoutlet,
    this.outliet,
    required this.programIdprogram,
    this.program,
    this.alamat,
    this.nohp,
    this.tmptlahir,
    this.tgllahir,
    required this.jabatanIdjabatan,
    this.jabatan,
    required this.iq,
    required this.tipeIdtipe,
    this.tipe,
    required this.skor,
    required this.subtraitIdsubtrait,
    this.subtrait,
    required this.komtraitIdkomtrait,
    this.komtrait,
    this.grafik,
    required this.discnaikIddiscnaik,
    this.discnaik,
    required this.discturunIddiscturun,
    this.discturun,
    required this.tglmasuk,
    required this.statusguru,
    this.email,
    required this.akreditasiIdakreditasi,
    this.akreditasi,
    this.akreditasiIdakreditasierb,
    this.akreditasierb,
    required this.password,
    required this.penguji,
    required this.ketpenguji,
    this.norekening,
    this.anrekening,
    this.bank,
    this.filename,
    this.createdAt,
    this.updatedAt,
    required this.devisiIddevisi,
    this.devisi,
  });

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      idguru: json['idguru'] ?? 0,
      jamluang: json['jamluang'],
      status: json['status'] ?? '',
      guru: json['guru'] ?? '',
      gurupanggilan: json['gurupanggilan'] ?? '',
      outlet_idoutlet: json['outlet_idoutlet'] ?? 0,
      outliet: json['outliet'],
      programIdprogram: json['program_idprogram'] ?? 0,
      program: json['program'],
      alamat: json['alamat'],
      nohp: json['nohp'],
      tmptlahir: json['tmptlahir'],
      tgllahir: json['tgllahir'],
      jabatanIdjabatan: json['jabatan_idjabatan'] ?? 0,
      jabatan: json['jabatan'],
      iq: json['iq'] ?? 0,
      tipeIdtipe: json['tipe_idtipe'] ?? '',
      tipe: json['tipe'],
      skor: json['skor'] ?? 0,
      subtraitIdsubtrait: json['subtrait_idsubtrait'] ?? 0,
      subtrait: json['subtrait'],
      komtraitIdkomtrait: json['komtrait_idkomtrait'] ?? 0,
      komtrait: json['komtrait'],
      grafik: json['grafik'],
      discnaikIddiscnaik: json['discnaik_iddiscnaik'] ?? 0,
      discnaik: json['discnaik'],
      discturunIddiscturun: json['discturun_iddiscturun'] ?? 0,
      discturun: json['discturun'],
      tglmasuk: json['tglmasuk'] ?? '',
      statusguru: json['statusguru'] ?? '',
      email: json['email'],
      akreditasiIdakreditasi: json['akreditasi_idakreditasi'] ?? 0,
      akreditasi: json['akreditasi'],
      akreditasiIdakreditasierb: json['akreditasi_idakreditasierb'],
      akreditasierb: json['akreditasierb'],
      password: json['password'] ?? '',
      penguji: json['penguji'] ?? '',
      ketpenguji: json['ketpenguji'] ?? '',
      norekening: json['norekening'],
      anrekening: json['anrekening'],
      bank: json['bank'],
      filename: json['filename'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      devisiIddevisi: json['devisi_iddevisi'] ?? 0,
      devisi: json['devisi'],
    );
  }
}
