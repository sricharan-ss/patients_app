import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_colors.dart';
import '../screens/hospital_detail_screen.dart';
import 'profile_screen.dart';
import 'medications_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;
  bool _locationChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    if (_locationChecked) return;
    _locationChecked = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Show custom dialog first
      if (!mounted) return;
      final shouldRequest = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          backgroundColor: AppColors.warmWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Color(0xFF2E7D32), size: 32),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Enable Location',
                  style: TextStyle(
                    color: AppColors.brownDeep,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'VITADATA uses your location to find nearby hospitals and doctors for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.brownMid,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownDeep,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Allow Location',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx, false),
                  child: const Text(
                    'Not Now',
                    style: TextStyle(
                      color: AppColors.brownLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (shouldRequest == true) {
        await Geolocator.requestPermission();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeTab(),
          MedicationsScreen(),
          _PlaceholderTab(label: 'Medical History', icon: Icons.folder_outlined),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Home Tab
// ─────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HomeHeader(),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(title: 'Your Appointments', onSeeAll: null),
                const SizedBox(height: 12),
                const _AppointmentCard(
                  doctorName: 'Dr. Emily Martinez',
                  specialty: 'Cardiologist',
                  hospital: 'City General Hospital',
                  date: 'Mar 25',
                  time: '10:00 AM',
                  status: 'Confirmed',
                  statusColor: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 12),
                const _AppointmentCard(
                  doctorName: 'Dr. James Wilson',
                  specialty: 'Endocrinologist',
                  hospital: 'Metro Health Center',
                  date: 'Mar 28',
                  time: '2:30 PM',
                  status: 'Pending',
                  statusColor: AppColors.accent,
                ),
                const SizedBox(height: 24),
                _SectionHeader(
                  title: 'Hospitals on VITADATA',
                  onSeeAll: () => Navigator.pushNamed(context, '/hospital-list'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _HospitalGrid(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SectionHeader(
              title: 'AI Recommended Doctors',
              onSeeAll: () => Navigator.pushNamed(context, '/doctor-list'),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _DoctorPreviewCard(
                  name: 'Dr. Emily Martinez',
                  specialty: 'Cardiologist',
                  hospital: 'City General Hospital',
                  aiPick: true,
                ),
                SizedBox(height: 10),
                _DoctorPreviewCard(
                  name: 'Dr. Sarah Chen',
                  specialty: 'General Physician',
                  hospital: 'Sunrise Medical',
                  aiPick: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _MedicationCard(),
                SizedBox(height: 16),
                _RecentOrderCard(),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.brownDeep, AppColors.brownMid],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: logo + title + settings
              Row(
                children: [
                  Image.asset('assets/images/onlyicon.png', height: 32, width: 32, fit: BoxFit.contain),
                  const SizedBox(width: 8),
                  const Text(
                    'VITADATA',
                    style: TextStyle(
                      color: AppColors.warmWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.settings_outlined, color: AppColors.cream, size: 26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Greeting row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening',
                          style: TextStyle(
                            color: AppColors.cream.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Charan',
                          style: TextStyle(
                            color: AppColors.warmWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search bar
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/search-results'),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const IgnorePointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search doctors, hospitals...',
                        hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                        prefixIcon: Icon(Icons.search, color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.brownDeep,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'See all →',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Appointment Card
// ─────────────────────────────────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String hospital;
  final String date;
  final String time;
  final String status;
  final Color statusColor;

  const _AppointmentCard({
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brownDeep,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  doctorName,
                  style: const TextStyle(
                    color: AppColors.warmWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$specialty · $hospital',
            style: TextStyle(
              color: AppColors.cream.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.cream.withOpacity(0.8), size: 14),
              const SizedBox(width: 6),
              Text(
                date,
                style: TextStyle(color: AppColors.cream.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Icon(Icons.access_time_outlined, color: AppColors.cream.withOpacity(0.8), size: 14),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(color: AppColors.cream.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Hospital Grid
// ─────────────────────────────────────────────────────────────
class _HospitalGrid extends StatelessWidget {
  const _HospitalGrid();

  static const _hospitals = [
    {'name': 'City General Hospital', 'location': 'New York', 'dist': '2.3 km', 'rating': '4.5', 'tags': ['Cardiology', 'Orthopedics']},
    {'name': 'Metro Health Center', 'location': 'New York', 'dist': '3.1 km', 'rating': '4.7', 'tags': ['Endocrinology', 'Pediatrics']},
    {'name': 'Sunrise Medical', 'location': 'New York', 'dist': '4.5 km', 'rating': '4.6', 'tags': ['General Medicine', 'Surgery']},
    {'name': 'Wellness Clinic', 'location': 'New York', 'dist': '5.2 km', 'rating': '4.4', 'tags': ['Family Medicine', 'Psychiatry']},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _hospitals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 145,
      ),
      itemBuilder: (context, index) {
        final h = _hospitals[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HospitalDetailScreen(hospitalName: h['name'] as String),
              ),
            );
          },
          child: _HospitalCard(
            name: h['name'] as String,
            location: h['location'] as String,
            distance: h['dist'] as String,
            rating: h['rating'] as String,
            tags: h['tags'] as List<String>,
          ),
        );
      },
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final String name;
  final String location;
  final String distance;
  final String rating;
  final List<String> tags;

  const _HospitalCard({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                  name,
                  style: const TextStyle(
                    color: AppColors.brownDeep,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✓',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.brownMid, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$location • $distance',
                  style: const TextStyle(color: AppColors.brownMid, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.accent, size: 12),
              const SizedBox(width: 4),
              Text(
                rating, 
                style: const TextStyle(color: AppColors.brownDeep, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: tags.take(2).map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: const TextStyle(color: AppColors.brownMid, fontSize: 9, fontWeight: FontWeight.w500),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Medication Card
// ─────────────────────────────────────────────────────────────
class _DoctorPreviewCard extends StatelessWidget {
  const _DoctorPreviewCard({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.aiPick,
  });

  final String name;
  final String specialty;
  final String hospital;
  final bool aiPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.brownDeep,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  specialty,
                  style: const TextStyle(
                    color: AppColors.brownMid,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hospital,
                  style: const TextStyle(
                    color: AppColors.brownLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (aiPick)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1E7FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'AI Pick',
                style: TextStyle(
                  color: Color(0xFF8F3AF8),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Orange left accent bar
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.medication_outlined, color: AppColors.accent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next medication',
                                style: TextStyle(color: AppColors.brownMid, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Metformin 500mg',
                                style: TextStyle(color: AppColors.brownDeep, fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '2:00 PM',
                                style: TextStyle(color: AppColors.brownMid, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brownDeep,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          child: const Text(
                            'Mark Taken',
                            style: TextStyle(color: AppColors.warmWhite, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'View all medications +',
                      style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Recent Order Card
// ─────────────────────────────────────────────────────────────
class _RecentOrderCard extends StatelessWidget {
  const _RecentOrderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Order',
                      style: TextStyle(color: AppColors.brownDeep, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'ORD-001234',
                      style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Metformin 500mg x 60',
                  style: TextStyle(color: AppColors.brownDeep, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Out for Delivery',
                  style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: AppColors.brownMid, size: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom Navigation
// ─────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: onTap,
          selectedItemColor: AppColors.brownDeep,
          unselectedItemColor: AppColors.brownMid.withOpacity(0.5),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined),
              activeIcon: Icon(Icons.medication),
              label: 'Medications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder),
              label: 'Medical History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Placeholder Tabs
// ─────────────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PlaceholderTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.brownMid, size: 64),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(color: AppColors.brownMid, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Coming soon', style: TextStyle(color: AppColors.brownLight)),
        ],
      ),
    );
  }
}
