import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../services/patient_api_service.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  int _prescriptionCount = 0;
  int _labReportCount = 0;
  int _appointmentCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final records = await PatientApiService.getRecords();
      if (!mounted) return;
      setState(() {
        _prescriptionCount = records.prescriptions.length;
        _labReportCount = records.labReports.length;
        _appointmentCount = records.appointments.length;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = PatientApiService.friendlyError(error);
        _isLoading = false;
      });
    }
  }

  String _countLabel(int count) {
    return '$count record${count == 1 ? '' : 's'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadSummary,
          color: AppColors.accent,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.brownDeep,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.brownMid,
                      fontSize: 12,
                    ),
                  ),
                ),
              _HistoryCategoryCard(
                icon: Icons.description_outlined,
                title: 'Prescriptions',
                subtitle: _countLabel(_prescriptionCount),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrescriptionsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _HistoryCategoryCard(
                icon: Icons.science_outlined,
                title: 'Lab Reports',
                subtitle: _countLabel(_labReportCount),
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
                subtitle: _countLabel(_appointmentCount),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentHistoryScreen(),
                    ),
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
      loader: () async {
        final records = await PatientApiService.getRecords();
        return records.prescriptions.map((item) {
          final encounter = item['encounter'];
          final doctor =
              encounter is Map<String, dynamic> ? encounter['doctor'] : null;
          final hospital =
              encounter is Map<String, dynamic> ? encounter['hospital'] : null;
          return _HistoryRecord(
            primary: _nestedString(doctor, 'name', 'Prescription'),
            secondary:
                '${(item['medicines'] as List?)?.length ?? 0} medicine(s)',
            source: _nestedString(hospital, 'name', 'VITADATA'),
            date: _formatDate(
              item['generatedAt'] ??
                  (encounter is Map ? encounter['scheduledTime'] : null),
            ),
            pdfUrl: item['pdfUrl']?.toString(),
          );
        }).toList();
      },
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
      loader: () async {
        final records = await PatientApiService.getRecords();
        return records.labReports.map((item) {
          final encounter = item['encounter'];
          final hospital =
              encounter is Map<String, dynamic> ? encounter['hospital'] : null;
          return _HistoryRecord(
            primary: item['testName']?.toString() ?? 'Lab report',
            secondary: item['remarks']?.toString() ??
                item['resultValue']?.toString() ??
                'Uploaded',
            source: _nestedString(hospital, 'name', 'VITADATA Lab'),
            date: _formatDate(item['reportedAt']),
            pdfUrl: item['pdfUrl']?.toString(),
          );
        }).toList();
      },
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
      loader: () async {
        final appointments = await PatientApiService.getAppointments();
        return appointments.map((appointment) {
          return _HistoryRecord(
            primary: appointment.doctor?.name ?? 'Doctor appointment',
            secondary: '${appointment.status} - Token ${appointment.tokenNo}',
            source: appointment.hospital?.name ?? 'VITADATA Hospital',
            date: _formatDate(appointment.scheduledTime),
            pdfUrl: null,
          );
        }).toList();
      },
    );
  }
}

class _HistoryRecordsPage extends StatefulWidget {
  const _HistoryRecordsPage({
    required this.title,
    required this.searchHint,
    required this.loader,
  });

  final String title;
  final String searchHint;
  final Future<List<_HistoryRecord>> Function() loader;

  @override
  State<_HistoryRecordsPage> createState() => _HistoryRecordsPageState();
}

class _HistoryRecordsPageState extends State<_HistoryRecordsPage> {
  String _query = '';
  late Future<List<_HistoryRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = widget.loader();
  }

  @override
  Widget build(BuildContext context) {
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
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.brownLight,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.warmWhite,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 8,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.brownLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<_HistoryRecord>>(
                future: _recordsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  if (snapshot.hasError) {
                    return _HistoryMessage(
                      message: PatientApiService.friendlyError(
                        snapshot.error ?? Exception('Unable to load records.'),
                      ),
                      onRetry: () =>
                          setState(() => _recordsFuture = widget.loader()),
                    );
                  }

                  final normalized = _query.trim().toLowerCase();
                  final filtered = (snapshot.data ?? const <_HistoryRecord>[])
                      .where((record) {
                    final text =
                        '${record.primary} ${record.secondary} ${record.source}'
                            .toLowerCase();
                    return text.contains(normalized);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const _HistoryMessage(
                      message: 'No records found yet.',
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final record = filtered[index];
                      return _HistoryRecordCard(record: record);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.brownMid, fontSize: 13),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brownDeep,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: AppColors.warmWhite),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _nestedString(dynamic value, String key, String fallback) {
  if (value is Map<String, dynamic>) {
    final result = value[key]?.toString().trim();
    if (result != null && result.isNotEmpty) return result;
  }
  return fallback;
}

String _formatDate(dynamic value) {
  final date =
      value is DateTime ? value : DateTime.tryParse(value?.toString() ?? '');
  if (date == null) return 'Date not available';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
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

  Future<void> _showPdfLink(BuildContext context) async {
    final pdfUrl = (record.pdfUrl ?? '').trim();
    if (pdfUrl.isEmpty) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.warmWhite,
        title: Text(
          record.primary,
          style: const TextStyle(
            color: AppColors.brownDeep,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SelectableText(
          pdfUrl,
          style: const TextStyle(color: AppColors.brownMid, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: pdfUrl));
              if (!context.mounted) return;
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF link copied')),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy Link'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brownDeep,
              foregroundColor: AppColors.cream,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPdf = (record.pdfUrl ?? '').trim().isNotEmpty;
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
                onPressed: hasPdf ? () => _showPdfLink(context) : null,
                icon: const Icon(Icons.file_download_outlined, size: 20),
                color: AppColors.accent,
                disabledColor: AppColors.brownLight,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            record.secondary,
            style: const TextStyle(color: AppColors.brownMid, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            record.source,
            style: const TextStyle(color: AppColors.brownLight, fontSize: 12),
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
                onTap: hasPdf ? () => _showPdfLink(context) : null,
                child: Text(
                  hasPdf ? 'PDF link +' : 'PDF not uploaded',
                  style: TextStyle(
                    color: hasPdf ? AppColors.accent : AppColors.brownLight,
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
    required this.pdfUrl,
  });

  final String primary;
  final String secondary;
  final String source;
  final String date;
  final String? pdfUrl;
}
