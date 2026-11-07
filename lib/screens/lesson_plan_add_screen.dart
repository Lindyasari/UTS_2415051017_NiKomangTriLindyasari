import 'package:flutter/material.dart';

class LessonPlanAddScreen extends StatefulWidget {
  const LessonPlanAddScreen({super.key});

  @override
  State<LessonPlanAddScreen> createState() => _LessonPlanAddScreenState();
}

class _LessonPlanAddScreenState extends State<LessonPlanAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _kelasController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String _status = 'planned'; // Pilihan: planned, active, done

  @override
  void dispose() {
    _judulController.dispose();
    _kelasController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Materi Ajar',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rencana Pembelajaran Baru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan detail materi yang akan diajarkan ke siswa.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _judulController,
                label: 'Judul Materi (Topik Utama)',
                hint: 'Contoh: Pengantar Jaringan Dasar',
                icon: Icons.book_outlined,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _kelasController,
                label: 'Target Kelas / Fase',
                hint: 'Contoh: Kelas X / Fase E',
                icon: Icons.class_outlined,
              ),
              const SizedBox(height: 20),

              const Text('Status Pelaksanaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.shade50,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _status,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    items: const [
                      DropdownMenuItem(value: 'planned', child: Text('Direncanakan (Planned)')),
                      DropdownMenuItem(value: 'active', child: Text('Sedang Berjalan (Active)')),
                      DropdownMenuItem(value: 'done', child: Text('Selesai (Done)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value != null) _status = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _deskripsiController,
                label: 'Tujuan / Deskripsi Pembelajaran',
                hint: 'Tuliskan capaian pembelajaran atau instruksi singkat...',
                icon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Nanti kita tambahkan logika Supabase di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tampilan Form Berhasil! Lanjut hubungkan ke Supabase.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Materi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.deepPurple.shade300) : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bagian ini wajib diisi oleh guru';
            }
            return null;
          },
        ),
      ],
    );
  }
}