import 'package:belajar02/services/guru_service.dart';
import 'package:flutter/material.dart';
import '../models/guru_model.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';
import 'login_screen.dart';
import 'edit_profil_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final AuthService _authService = AuthService();
  final GuruService _guruService = GuruService();
  Guru? _guru;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGuru();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadGuru() async {
    final guru = await _guruService.getGuru();
    setState(() {
      _guru = guru;
      _isLoading = false;
    });
  }

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  String capitalizeEachWord(String text) {
    if (text.isEmpty) return '';
    return text
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // LOADING STATE
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryBlue, AppColors.darkBlue],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          ),
        ),
      );
    }

    // DATA TIDAK ADA
    if (_guru == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryBlue, AppColors.darkBlue],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.whiteWithOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: AppColors.whiteWithOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Data guru tidak ditemukan",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final namaGuru = capitalizeEachWord(_guru!.guru);

    // ✅ FIXED LAYOUT PROFIL SCREEN
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Column(
        children: [
          SafeArea(
            bottom: false, // Hanya padding atas
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(height: 10),
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.whiteWithOpacity(0.9),
                        AppColors.whiteWithOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackWithOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      namaGuru.isNotEmpty
                          ? namaGuru
                                .split(' ')
                                .map((e) => e.isNotEmpty ? e[0] : '')
                                .take(2)
                                .join()
                          : '?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Nama dan Email
                Text(
                  namaGuru,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _guru!.email ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.whiteWithOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // Kontainer putih full bawah
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                  child: _buildProfilContent(namaGuru),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 AppBar Reusable
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profil',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteWithOpacity(0.1),
              border: Border.all(color: AppColors.whiteWithOpacity(0.2)),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Konten Profil (dibungkus agar rapih)
  Widget _buildProfilContent(String namaGuru) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSectionTitle('Informasi Pribadi'),
            // Tombol Edit
            TextButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilScreen(guru: _guru!),
                  ),
                );

                // Reload data jika berhasil update
                if (result == true) {
                  _loadGuru();
                }
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit', style: TextStyle(fontSize: 18)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.person_outline,
          label: 'Nama Guru',
          value: namaGuru,
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          icon: Icons.person_pin_outlined,
          label: 'Nama Panggilan',
          value: _guru!.gurupanggilan,
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.email_outlined,
          label: 'Email',
          value: _guru!.email ?? '-',
          color: AppColors.accentTeal,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.phone_outlined,
          label: 'No. Telephone',
          value: _guru!.nohp ?? '-',
          color: AppColors.accentPurple,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.location_on_outlined,
          label: 'Tempat Lahir',
          value: _guru!.tmptlahir ?? '-',
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.calendar_month_outlined,
          label: 'Tanggal Lahir',
          value: _guru!.tgllahir ?? '-',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.home_outlined,
          label: 'Alamat',
          value: _guru!.alamat ?? '-',
          color: AppColors.accentTeal,
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('Informasi Pekerjaan'),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.store_outlined,
          label: 'Outlet',
          value: _guru!.outliet ?? '-',
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.work_outline,
          label: 'Jabatan',
          value: _guru!.jabatan ?? '-',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.calendar_today_outlined,
          label: 'Tanggal Masuk',
          value: _guru!.tglmasuk,
          color: AppColors.accentTeal,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.star_outline,
          label: 'Status Guru',
          value: _guru!.statusguru,
          color: AppColors.accentPurple,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.school_outlined,
          label: 'Program',
          value: _guru!.program ?? '-',
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('Informasi Lainnya'),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.psychology_outlined,
          label: 'IQ',
          value: _guru!.iq.toString(),
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.psychology_alt_outlined,
          label: 'Tipe',
          value: _guru!.tipe ?? '-',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.score_outlined,
          label: 'Skor',
          value: _guru!.skor.toString(),
          color: AppColors.accentTeal,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.trending_up_outlined,
          label: 'Subtrait',
          value: _guru!.subtrait ?? '-',
          color: AppColors.accentPurple,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.compare_arrows_outlined,
          label: 'Komtrait',
          value: _guru!.komtrait ?? '-',
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.show_chart_outlined,
          label: 'Grafik',
          value: _guru!.grafik ?? '-',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.arrow_upward_outlined,
          label: 'Discnaik',
          value: _guru!.discnaik ?? '-',
          color: AppColors.accentTeal,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.arrow_downward_outlined,
          label: 'Discturun',
          value: _guru!.discturun ?? '-',
          color: AppColors.accentPurple,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.verified_outlined,
          label: 'Akreditasi',
          value: _guru!.akreditasi ?? '-',
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.verified_user_outlined,
          label: 'Akreditasi ERB',
          value: _guru!.akreditasierb ?? '-',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.person_search_outlined,
          label: 'Penguji',
          value: _guru!.penguji,
          color: AppColors.accentTeal,
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('Informasi Bank'),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.account_balance_wallet_outlined,
          label: 'No. Rekening',
          value: _guru!.norekening ?? '-',
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.person_4_outlined,
          label: 'Atas Nama',
          value: _guru!.anrekening ?? '-',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.account_balance_outlined,
          label: 'Bank',
          value: _guru!.bank ?? '-',
          color: AppColors.accentTeal,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue.withOpacity(0.8),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkBlue.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
