import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'hospital_detail_screen.dart';

// ─── Mock data (mirrors other screens) ──────────────────────────────────────

const _hospitals = [
  (
    name: 'City General Hospital',
    location: 'New York',
    distance: '2.3 km',
    tags: ['Cardiology', 'Orthopedics', 'Neurology'],
  ),
  (
    name: 'Metro Health Center',
    location: 'New York',
    distance: '3.1 km',
    tags: ['Endocrinology', 'Pediatrics', 'Dermatology'],
  ),
  (
    name: 'Sunrise Medical',
    location: 'New York',
    distance: '4.5 km',
    tags: ['General Medicine', 'Surgery', 'Radiology'],
  ),
  (
    name: 'Wellness Clinic',
    location: 'New York',
    distance: '5.2 km',
    tags: ['Family Medicine', 'Psychiatry'],
  ),
];

const _doctors = [
  (
    name: 'Dr. Emily Martinez',
    specialty: 'Cardiologist',
    hospital: 'City General Hospital',
  ),
  (
    name: 'Dr. Sarah Chen',
    specialty: 'General Physician',
    hospital: 'Sunrise Medical',
  ),
  (
    name: 'Dr. Michael Brown',
    specialty: 'Orthopedist',
    hospital: 'Metro Health Center',
  ),
  (
    name: 'Dr. Aisha Khan',
    specialty: 'Dermatologist',
    hospital: 'Wellness Clinic',
  ),
  (
    name: 'Dr. Rajesh Nair',
    specialty: 'Neurologist',
    hospital: 'City General Hospital',
  ),
];

// ─── Screen ─────────────────────────────────────────────────────────────────

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _activeTab = 'all'; // all | doctors | hospitals
  List<String> _recentSearches = ['Dr. Sarah', 'Cardiology', 'City General Hospital'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _query => _controller.text.trim().toLowerCase();

  List<dynamic> get _filteredDoctors {
    if (_query.isEmpty) return [];
    return _doctors.where((d) {
      return d.name.toLowerCase().contains(_query) ||
          d.specialty.toLowerCase().contains(_query) ||
          d.hospital.toLowerCase().contains(_query);
    }).toList();
  }

  List<dynamic> get _filteredHospitals {
    if (_query.isEmpty) return [];
    return _hospitals.where((h) {
      return h.name.toLowerCase().contains(_query) ||
          h.location.toLowerCase().contains(_query) ||
          h.tags.any((t) => t.toLowerCase().contains(_query));
    }).toList();
  }

  bool get _hasResults => _filteredDoctors.isNotEmpty || _filteredHospitals.isNotEmpty;

  void _clearSearch() {
    _controller.clear();
    setState(() {});
    _focusNode.requestFocus();
  }

  void _removeRecent(String s) {
    setState(() => _recentSearches.remove(s));
  }

  void _clearAllRecent() {
    setState(() => _recentSearches.clear());
  }

  void _setQuery(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: q.length),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _query.isEmpty ? _buildEmptyState() : _buildResultsState(),
          ),
        ],
      ),
    );
  }

  // ── Brown search header ─────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.brownDeep, AppColors.brownMid],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 16, 14),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.cream, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              // Search field
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search, color: AppColors.brownMid, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                            color: AppColors.brownDeep,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search doctors, hospitals...',
                            hintStyle: TextStyle(
                              color: Color(0xFFB69A83),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_controller.text.isNotEmpty)
                        GestureDetector(
                          onTap: _clearSearch,
                          child: Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 12, color: AppColors.brownDeep),
                          ),
                        )
                      else
                        const SizedBox(width: 10),
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

  // ── Empty state (no query) ──────────────────────────────────────────────

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Actions
        _buildSectionLabel('QUICK ACTIONS'),
        const SizedBox(height: 10),
        _buildQuickActions(),
        const SizedBox(height: 24),

        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: AppColors.brownLight, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'Recent Searches',
                    style: TextStyle(
                      color: AppColors.brownDeep,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _clearAllRecent,
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((s) => _buildRecentChip(s)).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Trending Specialties
        Row(
          children: [
            Icon(Icons.trending_up, color: AppColors.brownLight, size: 16),
            const SizedBox(width: 6),
            const Text(
              'Trending Specialties',
              style: TextStyle(
                color: AppColors.brownDeep,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildTrendingGrid(),
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.brownLight,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      (icon: Icons.medical_services_outlined, label: 'Find Doctor', color: const Color(0xFFE3F2FD), iconColor: const Color(0xFF1976D2)),
      (icon: Icons.local_hospital_outlined, label: 'Hospitals', color: const Color(0xFFFFF3E0), iconColor: const Color(0xFFE65100)),
      (icon: Icons.location_on_outlined, label: 'Nearby', color: const Color(0xFFE8F5E9), iconColor: const Color(0xFF2E7D32)),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: a == actions.last ? 0 : 10,
            ),
            child: GestureDetector(
              onTap: () {
                if (a.label == 'Find Doctor') {
                  Navigator.pushNamed(context, '/doctor-list');
                } else if (a.label == 'Hospitals') {
                  Navigator.pushNamed(context, '/hospital-list');
                } else if (a.label == 'Nearby') {
                  Navigator.pushNamed(context, '/hospital-list', arguments: {'nearbyOnly': true});
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surface),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: a.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(a.icon, size: 22, color: a.iconColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.label,
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentChip(String search) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _setQuery(search),
            child: Text(
              search,
              style: const TextStyle(
                color: AppColors.brownMid,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeRecent(search),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 10, color: AppColors.brownLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingGrid() {
    const specialties = ['Cardiology', 'Pediatrics', 'Neurology', 'Dermatology', 'Orthopedics', 'Psychiatry'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 50,
      ),
      itemCount: specialties.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () => _setQuery(specialties[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surface),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.medical_services_outlined, size: 16, color: AppColors.brownDeep),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    specialties[i],
                    style: const TextStyle(
                      color: AppColors.brownDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Results state (with query) ──────────────────────────────────────────

  Widget _buildResultsState() {
    return Column(
      children: [
        // Tab bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.warmWhite,
            border: Border(bottom: BorderSide(color: AppColors.surface, width: 1)),
          ),
          child: Row(
            children: [
              _buildTab('all', 'All'),
              const SizedBox(width: 8),
              _buildTab('doctors', 'Doctors'),
              const SizedBox(width: 8),
              _buildTab('hospitals', 'Hospitals'),
            ],
          ),
        ),
        // Results
        Expanded(
          child: _hasResults ? _buildResultsList() : _buildNoResults(),
        ),
      ],
    );
  }

  Widget _buildTab(String value, String label) {
    final isActive = _activeTab == value;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brownDeep : AppColors.cream,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: AppColors.surface),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.cream : AppColors.brownMid,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.cream,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off, size: 32, color: AppColors.surface),
          ),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(
              color: AppColors.brownDeep,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'We couldn\'t find anything matching "${_controller.text}". Try checking your spelling or use more general terms.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.brownMid.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    final showDoctors = (_activeTab == 'all' || _activeTab == 'doctors') && _filteredDoctors.isNotEmpty;
    final showHospitals = (_activeTab == 'all' || _activeTab == 'hospitals') && _filteredHospitals.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (showDoctors) ...[
          _buildResultSectionHeader('DOCTORS', _filteredDoctors.length),
          const SizedBox(height: 10),
          ..._filteredDoctors.map((d) => _buildDoctorResult(d)),
          const SizedBox(height: 20),
        ],
        if (showHospitals) ...[
          _buildResultSectionHeader('HOSPITALS', _filteredHospitals.length),
          const SizedBox(height: 10),
          ..._filteredHospitals.map((h) => _buildHospitalResult(h)),
        ],
      ],
    );
  }

  Widget _buildResultSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.brownLight,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count found',
            style: const TextStyle(
              color: AppColors.brownDeep,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorResult(dynamic doctor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/doctor-list', arguments: {'searchQuery': doctor.name});
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surface),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  doctor.name.toString().length > 3 ? doctor.name.toString()[3] : 'D',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        color: AppColors.brownMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.hospital,
                      style: const TextStyle(
                        color: AppColors.brownLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.surface, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalResult(dynamic hospital) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HospitalDetailScreen(hospitalName: hospital.name),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surface),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.local_hospital_outlined, size: 24, color: AppColors.brownDeep),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.brownMid),
                        const SizedBox(width: 3),
                        Text(
                          '${hospital.location} • ${hospital.distance}',
                          style: const TextStyle(
                            color: AppColors.brownMid,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (hospital.tags as List<String>).take(2).map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            t,
                            style: const TextStyle(
                              color: AppColors.brownLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
