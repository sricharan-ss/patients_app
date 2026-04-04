import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'book_appointment_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final int experience;
  final int totalPatients;
  final int fee;
  final bool verified;
  final bool aiRecommended;

  const DoctorProfileScreen({
    super.key,
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.experience,
    required this.totalPatients,
    required this.fee,
    this.verified = true, // default to true to match design 
    this.aiRecommended = false,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isFavorite = false;

  final _schedule = [
    {'day': 'Mon – Fri', 'time': '9:00 AM – 6:00 PM', 'available': true, 'isWeekday': true},
    {'day': 'Saturday', 'time': 'Leave', 'available': false, 'isWeekday': false},
    {'day': 'Sunday', 'time': 'Leave', 'available': false, 'isWeekday': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: Stack(
        children: [
          Column(
            children: [
              // ─── Brown Header ──────────────────────────────────────────
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [AppColors.brownDeep, AppColors.brownMid],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 56,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? const Color(0xFFD4822A) : const Color(0xFFFBF6EC),
                            ),
                            onPressed: () => setState(() => _isFavorite = !_isFavorite),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Content ───────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100), // space for bottom bar
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF6EC),
                            border: Border.all(color: const Color(0xFFEFE2CC)),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFFD4822A), Color(0xFFA0622A)],
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.name.startsWith('Dr. ') && widget.name.length > 4 
                                          ? widget.name[4] 
                                          : (widget.name.isNotEmpty ? widget.name[0] : 'D'),
                                      style: const TextStyle(
                                        color: Color(0xFFFBF6EC),
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Playfair Display',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name,
                                          style: const TextStyle(
                                            color: Color(0xFF3B1F0A),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Playfair Display',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.specialty,
                                          style: const TextStyle(
                                            color: Color(0xFF6B3A1F),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: [
                                            if (widget.verified)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFD4822A).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.workspace_premium, color: Color(0xFFD4822A), size: 10),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'VITADATA Verified',
                                                      style: TextStyle(
                                                        color: Color(0xFFD4822A),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (widget.aiRecommended)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.purple.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.auto_awesome, color: Colors.purple, size: 10),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'AI Recommended',
                                                      style: TextStyle(
                                                        color: Colors.purple,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: Color(0xFFEFE2CC), height: 1),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.work_outline, color: Color(0xFFA0622A), size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${widget.experience}y',
                                              style: const TextStyle(
                                                color: Color(0xFF3B1F0A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'experience',
                                          style: TextStyle(color: Color(0xFFA0622A), fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(width: 1, height: 30, color: const Color(0xFFEFE2CC)),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.people_outline, color: Color(0xFFA0622A), size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${widget.totalPatients}+',
                                              style: const TextStyle(
                                                color: Color(0xFF3B1F0A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'patients',
                                          style: TextStyle(color: Color(0xFFA0622A), fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(width: 1, height: 30, color: const Color(0xFFEFE2CC)),
                                  const Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.school_outlined, color: Color(0xFFA0622A), size: 14),
                                            SizedBox(width: 4),
                                            Text(
                                              'MD',
                                              style: TextStyle(
                                                color: Color(0xFF3B1F0A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'credential',
                                          style: TextStyle(color: Color(0xFFA0622A), fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Fee & Hospital Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBF6EC),
                                  border: Border.all(color: const Color(0xFFEFE2CC)),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.attach_money, color: Color(0xFFA0622A), size: 14),
                                        SizedBox(width: 4),
                                        Text('Consultation Fee', style: TextStyle(color: Color(0xFFA0622A), fontSize: 11)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${widget.fee}',
                                      style: const TextStyle(
                                        color: Color(0xFF3B1F0A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBF6EC),
                                  border: Border.all(color: const Color(0xFFEFE2CC)),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Affiliated Hospital', style: TextStyle(color: Color(0xFFA0622A), fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.hospital,
                                      style: const TextStyle(
                                        color: Color(0xFF3B1F0A),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Video Intro
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF6EC),
                            border: Border.all(color: const Color(0xFFEFE2CC)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFEFE2CC),
                                      const Color(0xFFD4822A).withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF3B1F0A),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.play_arrow, color: Color(0xFFFBF6EC), size: 32),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text('2:00', style: TextStyle(color: Colors.white, fontSize: 10)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Watch doctor's clinical introduction",
                                style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Practice Hours
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Color(0xFF3B1F0A), size: 16),
                            const SizedBox(width: 8),
                            const Text(
                              'Practice Hours',
                              style: TextStyle(
                                color: Color(0xFF3B1F0A),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF6EC),
                            border: Border.all(color: const Color(0xFFEFE2CC)),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: _schedule.map((item) {
                              final isLast = _schedule.last == item;
                              final available = item['available'] as bool;
                              final isWeekday = item['isWeekday'] as bool;
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFEFE2CC))),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: available ? Colors.green : Colors.red.shade400,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          item['day'] as String,
                                          style: TextStyle(
                                            color: isWeekday ? const Color(0xFF3B1F0A) : const Color(0xFF6B3A1F),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (available)
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, color: Color(0xFFA0622A), size: 14),
                                          const SizedBox(width: 8),
                                          Text(
                                            item['time'] as String,
                                            style: const TextStyle(
                                              color: Color(0xFF3B1F0A),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      const Text(
                                        'Leave',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '* Timings may vary on holidays. Confirm at the time of booking.',
                            style: TextStyle(color: Color(0xFFA0622A), fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── Pinned Bottom Button ──────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFDF8),
                border: Border(top: BorderSide(color: Color(0xFFEFE2CC))),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentScreen(
                        doctorId: widget.id,
                        doctorName: widget.name,
                        doctorSpecialty: widget.specialty,
                        hospitalName: widget.hospital,
                        fee: widget.fee,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B1F0A),
                  foregroundColor: const Color(0xFFFBF6EC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.calendar_month, size: 18),
                label: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
