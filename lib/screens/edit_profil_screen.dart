import 'package:belajar02/services/guru_service.dart';
import 'package:flutter/material.dart';
import '../models/guru_model.dart';
import '../constants/app_colors.dart';

class EditProfilScreen extends StatefulWidget {
  final Guru guru;

  const EditProfilScreen({Key? key, required this.guru}) : super(key: key);

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final GuruService _guruService = GuruService();

  bool _isLoading = false;

  // Controllers untuk form
  late TextEditingController _namaController;
  late TextEditingController _namaPanggilanController;
  late TextEditingController _emailController;
  late TextEditingController _nohpController;
  late TextEditingController _tmptlahirController;
  late TextEditingController _tgllahirController;
  late TextEditingController _alamatController;
  late TextEditingController _tglmasukController;
  late TextEditingController _noRekeningController;
  late TextEditingController _anRekeningController;
  late TextEditingController _bankController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.guru.guru);
    _namaPanggilanController = TextEditingController(
      text: widget.guru.gurupanggilan,
    );
    _emailController = TextEditingController(text: widget.guru.email ?? '');
    _nohpController = TextEditingController(text: widget.guru.nohp ?? '');
    _tmptlahirController = TextEditingController(
      text: widget.guru.tmptlahir ?? '',
    );
    _tgllahirController = TextEditingController(
      text: widget.guru.tgllahir ?? '',
    );
    _alamatController = TextEditingController(text: widget.guru.alamat ?? '');
    _tglmasukController = TextEditingController(text: widget.guru.tglmasuk);
    _noRekeningController = TextEditingController(
      text: widget.guru.norekening ?? '',
    );
    _anRekeningController = TextEditingController(
      text: widget.guru.anrekening ?? '',
    );
    _bankController = TextEditingController(text: widget.guru.bank ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _namaPanggilanController.dispose();
    _emailController.dispose();
    _nohpController.dispose();
    _tmptlahirController.dispose();
    _tgllahirController.dispose();
    _alamatController.dispose();
    _tglmasukController.dispose();
    _noRekeningController.dispose();
    _anRekeningController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _guruService.updateGuru(
        idguru: widget.guru.idguru,
        guru: _namaController.text,
        gurupanggilan: _namaPanggilanController.text,
        email: _emailController.text,
        nohp: _nohpController.text,
        tmptlahir: _tmptlahirController.text,
        tgllahir: _tgllahirController.text,
        alamat: _alamatController.text,
        norekening: _noRekeningController.text,
        anrekening: _anRekeningController.text,
        bank: _bankController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Kembali dengan hasil true
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? initialDate;
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateTime.parse(controller.text);
      }
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteWithOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
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
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Informasi Pribadi'),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _namaController,
                          label: 'Nama Lengkap',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _namaPanggilanController,
                          label: 'Nama Panggilan',
                          icon: Icons.person_pin_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama panggilan tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _nohpController,
                          label: 'No. Telephone',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _tmptlahirController,
                          label: 'Tempat Lahir',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildDateField(
                          controller: _tgllahirController,
                          label: 'Tanggal Lahir',
                          icon: Icons.calendar_month_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _alamatController,
                          label: 'Alamat',
                          icon: Icons.home_outlined,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        _buildSectionTitle('Informasi Outlet'),
                        const SizedBox(height: 16),

                        // Outlet tidak bisa diubah
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.store_outlined,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Outlet',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.guru.outliet ?? '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.lock_outline,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildSectionTitle('Informasi Bank'),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _noRekeningController,
                          label: 'No. Rekening',
                          icon: Icons.account_balance_wallet_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _anRekeningController,
                          label: 'Atas Nama',
                          icon: Icons.person_4_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _bankController,
                          label: 'Nama Bank',
                          icon: Icons.account_balance_outlined,
                        ),
                        const SizedBox(height: 32),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _simpanPerubahan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Simpan Perubahan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue.withOpacity(0.8),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        suffixIcon: Icon(Icons.calendar_today, color: AppColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
