import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SecureVaultScreen extends StatefulWidget {
  const SecureVaultScreen({super.key});

  @override
  State<SecureVaultScreen> createState() => _SecureVaultScreenState();
}

class _SecureVaultScreenState extends State<SecureVaultScreen> {
  final List<Map<String, String>> _files = [
    {'id': '1', 'name': 'Insurance Card.pdf', 'type': 'pdf', 'date': '2026-03-15', 'size': '245 KB'},
    {'id': '2', 'name': 'X-Ray Results.jpg', 'type': 'image', 'date': '2026-03-10', 'size': '1.2 MB'},
    {'id': '3', 'name': 'Vaccination Record.pdf', 'type': 'pdf', 'date': '2026-02-28', 'size': '180 KB'},
    {'id': '4', 'name': 'MRI Scan.pdf', 'type': 'pdf', 'date': '2026-02-15', 'size': '3.4 MB'},
    {'id': '5', 'name': 'Blood Test.pdf', 'type': 'pdf', 'date': '2026-01-20', 'size': '120 KB'},
    {'id': '6', 'name': 'ECG Report.pdf', 'type': 'pdf', 'date': '2026-01-10', 'size': '95 KB'},
    {'id': '7', 'name': 'Ultrasound.jpg', 'type': 'image', 'date': '2025-12-18', 'size': '890 KB'},
    {'id': '8', 'name': 'Allergy Test.pdf', 'type': 'pdf', 'date': '2025-12-05', 'size': '156 KB'},
  ];

  Future<void> _addFile() async {
    try {
      // Use file_picker which works on both Mobile and Web
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        final file = result.files.single;
        final fileName = file.name;
        final ext = fileName.split('.').last.toLowerCase();
        final isPdf = ext == 'pdf';
        
        String sizeStr;
        if (kIsWeb) {
          final sizeKb = file.size / 1024;
          sizeStr = sizeKb >= 1024
              ? '${(sizeKb / 1024).toStringAsFixed(1)} MB'
              : '${sizeKb.toStringAsFixed(0)} KB';
        } else {
          // On mobile, size is also in bytes
          final sizeKb = file.size / 1024;
          sizeStr = sizeKb >= 1024
              ? '${(sizeKb / 1024).toStringAsFixed(1)} MB'
              : '${sizeKb.toStringAsFixed(0)} KB';
        }

        setState(() {
          _files.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'name': fileName,
            'type': isPdf ? 'pdf' : 'image',
            'date': DateTime.now().toIso8601String(),
            'size': sizeStr,
          });
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File added successfully'),
            backgroundColor: Color(0xFF3B1F0A),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: const Text(
          'Secure Vault',
          style: TextStyle(
            color: Color(0xFFFBF6EC),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF3B1F0A),
        iconTheme: const IconThemeData(color: Color(0xFFFBF6EC)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  'Your medical documents stored securely on VITADATA',
                  style: TextStyle(
                    color: Color(0xFF6B3A1F),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _files.length,
                itemBuilder: (context, index) {
                  final file = _files[index];
                  final isPdf = file['type'] == 'pdf';

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF6EC),
                        border: Border.all(color: const Color(0xFFEFE2CC)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFE2CC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              isPdf ? Icons.description_outlined : Icons.image_outlined,
                              color: const Color(0xFF6B3A1F),
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            file['name']!,
                            style: const TextStyle(
                              color: Color(0xFF3B1F0A),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFFA0622A),
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(file['date']!),
                                style: const TextStyle(
                                  color: Color(0xFFA0622A),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            file['size']!,
                            style: const TextStyle(
                              color: Color(0xFFA0622A),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: _addFile,
              backgroundColor: const Color(0xFF3B1F0A),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFFFBF6EC),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
