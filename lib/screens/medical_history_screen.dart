import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Text(
                      'VITADATA',
                      style: TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                      icon: const Icon(Icons.settings_outlined, color: AppColors.brownDeep, size: 22),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _HistoryCategoryCard(
                icon: Icons.description_outlined,
                title: 'Prescriptions',
                subtitle: '3 records',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrescriptionsScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _HistoryCategoryCard(
                icon: Icons.science_outlined,
                title: 'Lab Reports',
                subtitle: '3 records',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LabReportsScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _HistoryCategoryCard(
                icon: Icons.calendar_today_outlined,
                title: 'Appointment History',
                subtitle: '3 records',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppointmentHistoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HistoryRecordsPage(
      title: 'Prescriptions',
      searchHint: 'Search prescriptions...',
      records: const [
        _HistoryRecord(
          primary: 'Dr. Emily Martinez',
          secondary: 'Cardiologist',
          source: 'City General Hospital',
          date: 'March 15, 2026',
        ),
        _HistoryRecord(
          primary: 'Dr. James Wilson',
          secondary: 'Endocrinologist',
          source: 'Metro Health Center',
          date: 'February 28, 2026',
        ),
        _HistoryRecord(
          primary: 'Dr. Sarah Chen',
          secondary: 'General Physician',
          source: 'Sunrise Medical',
          date: 'February 10, 2026',
        ),
      ],
    );
  }
}

class LabReportsScreen extends StatelessWidget {
  const LabReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HistoryRecordsPage(
      title: 'Lab Reports',
      searchHint: 'Search lab reports...',
      records: const [
        _HistoryRecord(
          primary: 'Complete Blood Count',
          secondary: 'Normal',
          source: 'City Lab Diagnostics',
          date: 'March 16, 2026',
        ),
        _HistoryRecord(
          primary: 'Thyroid Profile',
          secondary: 'Pending Review',
          source: 'Metro Path Lab',
          date: 'March 02, 2026',
        ),
        _HistoryRecord(
          primary: 'Lipid Profile',
          secondary: 'Borderline High',
          source: 'Wellness Lab Center',
          date: 'February 11, 2026',
        ),
      ],
    );
  }
}

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HistoryRecordsPage(
      title: 'Appointment History',
      searchHint: 'Search appointments...',
      records: const [
        _HistoryRecord(
          primary: 'Dr. Emily Martinez',
          secondary: 'Cardiologist',
          source: 'City General Hospital',
          date: 'March 15, 2026',
        ),
        _HistoryRecord(
          primary: 'Dr. James Wilson',
          secondary: 'Endocrinologist',
          source: 'Metro Health Center',
          date: 'February 28, 2026',
        ),
        _HistoryRecord(
          primary: 'Dr. Sarah Chen',
          secondary: 'General Physician',
          source: 'Sunrise Medical',
          date: 'February 10, 2026',
        ),
      ],
    );
  }
}

class _HistoryRecordsPage extends StatefulWidget {
  const _HistoryRecordsPage({
    required this.title,
    required this.searchHint,
    required this.records,
  });

  final String title;
  final String searchHint;
  final List<_HistoryRecord> records;

  @override
  State<_HistoryRecordsPage> createState() => _HistoryRecordsPageState();
}

class _HistoryRecordsPageState extends State<_HistoryRecordsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final normalized = _query.trim().toLowerCase();
    final filtered = widget.records.where((record) {
      final text = '${record.primary} ${record.secondary} ${record.source}'.toLowerCase();
      return text.contains(normalized);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.brownDeep, AppColors.brownMid],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: const TextStyle(color: AppColors.brownLight),
                prefixIcon: const Icon(Icons.search, color: AppColors.brownLight, size: 20),
                filled: true,
                fillColor: AppColors.warmWhite,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.brownLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final record = filtered[index];
                  return _HistoryRecordCard(record: record);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCategoryCard extends StatelessWidget {
  const _HistoryCategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cream,
            border: Border.all(color: AppColors.surface),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.brownMid, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.brownMid,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.brownLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryRecordCard extends StatelessWidget {
  const _HistoryRecordCard({required this.record});

  final _HistoryRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.primary,
                  style: const TextStyle(
                    color: AppColors.brownDeep,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined, color: AppColors.accent, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            record.secondary,
            style: const TextStyle(
              color: AppColors.brownMid,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            record.source,
            style: const TextStyle(
              color: AppColors.brownLight,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  record.date,
                  style: const TextStyle(
                    color: AppColors.brownLight,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View PDF +',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryRecord {
  const _HistoryRecord({
    required this.primary,
    required this.secondary,
    required this.source,
    required this.date,
  });

  final String primary;
  final String secondary;
  final String source;
  final String date;
}
