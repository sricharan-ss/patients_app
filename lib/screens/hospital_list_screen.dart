import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'hospital_detail_screen.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String _searchQuery = '';
  
  // Filter states
  String? _appliedLocation;
  String _appliedRating = 'Any';
  Set<String> _appliedSpecialties = {};

  static const _hospitals = [
    (
      name: 'City General Hospital',
      location: 'New York',
      distance: '2.3 km',
      rating: '4.5',
      reviews: '856 reviews',
      tags: ['Cardiology', 'Orthopedics', 'Neurology'],
    ),
    (
      name: 'Metro Health Center',
      location: 'New York',
      distance: '3.1 km',
      rating: '4.7',
      reviews: '612 reviews',
      tags: ['Endocrinology', 'Pediatrics', 'Dermatology'],
    ),
    (
      name: 'Sunrise Medical',
      location: 'New York',
      distance: '4.5 km',
      rating: '4.6',
      reviews: '493 reviews',
      tags: ['General Medicine', 'Surgery', 'Radiology'],
    ),
    (
      name: 'Wellness Clinic',
      location: 'New York',
      distance: '5.2 km',
      rating: '4.4',
      reviews: '287 reviews',
      tags: ['Family Medicine', 'Psychiatry'],
    ),
  ];

  List<String> get _allTags {
    final tags = <String>{};
    for (final h in _hospitals) {
      tags.addAll(h.tags);
    }
    return tags.toList()..sort();
  }

  List<String> get _allLocations {
    final locs = <String>{};
    for (final h in _hospitals) locs.add(h.location);
    return locs.toList()..sort();
  }

  List<dynamic> get _filteredHospitals {
    return _hospitals.where((h) {
      // 1. Search Query
      final matchesQuery = _searchQuery.isEmpty ||
          h.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      // 2. Rating
      bool matchesRating = true;
      if (_appliedRating != 'Any') {
        double minRating = double.tryParse(_appliedRating.replaceAll('+', '')) ?? 0.0;
        double hospitalRating = double.tryParse(h.rating) ?? 0.0;
        if (hospitalRating < minRating) matchesRating = false;
      }

      // 3. Location
      bool matchesLocation = true;
      if (_appliedLocation != null) {
        matchesLocation = h.location == _appliedLocation;
      }

      // 4. Specialties
      bool matchesSpecialty = true;
      if (_appliedSpecialties.isNotEmpty) {
        matchesSpecialty = h.tags.any((t) => _appliedSpecialties.contains(t));
      }
      
      return matchesQuery && matchesRating && matchesLocation && matchesSpecialty;
    }).toList();
  }

  void _showFilterSheet() {
    String? tempLocation = _appliedLocation;
    String tempRating = _appliedRating;
    Set<String> tempSpecialties = Set.from(_appliedSpecialties);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.warmWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          
          Widget buildChip(String title, bool isSelected, VoidCallback onTap) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : const Color(0xFFFBF6EC), // Light cream
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.surface,
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.brownDeep,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          Widget buildSectionTitle(String title) {
            return Text(
              title,
              style: const TextStyle(
                color: AppColors.brownDeep,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            );
          }

          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Hospitals',
                          style: TextStyle(
                            color: AppColors.brownDeep,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.brownDeep),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.surface, height: 1),
                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSectionTitle('Location'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allLocations.map((loc) {
                              return buildChip(
                                loc,
                                tempLocation == loc,
                                () => setModalState(() => tempLocation = tempLocation == loc ? null : loc),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          
                          buildSectionTitle('Minimum Rating'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Any', '3+', '3.5+', '4+', '4.5+'].map((rating) {
                              return buildChip(
                                rating,
                                tempRating == rating,
                                () => setModalState(() => tempRating = rating),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          buildSectionTitle('Specialties'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allTags.map((tag) {
                              final isSelected = tempSpecialties.contains(tag);
                              return buildChip(
                                tag,
                                isSelected,
                                () {
                                  setModalState(() {
                                    if (isSelected) {
                                      tempSpecialties.remove(tag);
                                    } else {
                                      tempSpecialties.add(tag);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.surface, height: 1),
                  // Bottom Actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setModalState(() {
                                tempLocation = null;
                                tempRating = 'Any';
                                tempSpecialties.clear();
                              });
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBF6EC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.surface),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Clear All',
                                style: TextStyle(
                                  color: AppColors.brownDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _appliedLocation = tempLocation;
                                _appliedRating = tempRating;
                                _appliedSpecialties = tempSpecialties;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Apply Filters',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.warmWhite,
        title: const Text(
          'Hospitals',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.surface),
                    ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.brownMid, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              style: const TextStyle(
                                color: AppColors.brownDeep,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search hospitals...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFB69A83),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(14),
                        border: (() {
                          final isFilterActive = _appliedLocation != null || _appliedRating != 'Any' || _appliedSpecialties.isNotEmpty;
                          return Border.all(
                            color: isFilterActive ? AppColors.accent : AppColors.surface,
                          );
                        })(),
                      ),
                      child: Icon(
                        Icons.filter_alt_outlined, 
                        color: (() {
                          final isFilterActive = _appliedLocation != null || _appliedRating != 'Any' || _appliedSpecialties.isNotEmpty;
                          return isFilterActive ? AppColors.accent : AppColors.brownMid;
                        })(), 
                        size: 20
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredHospitals.isEmpty
                  ? const Center(
                      child: Text(
                        'No hospitals found',
                        style: TextStyle(
                          color: AppColors.brownMid,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
                      itemCount: _filteredHospitals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final h = _filteredHospitals[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HospitalDetailScreen(hospitalName: h.name),
                            ),
                          ),
                          child: _HospitalRowCard(
                            name: h.name,
                            location: h.location,
                            distance: h.distance,
                            rating: h.rating,
                            reviews: h.reviews,
                            tags: h.tags,
                          ),
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

class _HospitalRowCard extends StatelessWidget {
  const _HospitalRowCard({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.tags,
  });

  final String name;
  final String location;
  final String distance;
  final String rating;
  final String reviews;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.brownDeep,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DFCC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'VITADATA ✓',
                  style: TextStyle(
                    color: AppColors.brownLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.brownMid, size: 12),
              const SizedBox(width: 4),
              Text(
                '$location · $distance',
                style: const TextStyle(
                  color: AppColors.brownMid,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.accent, size: 16),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(
                  color: AppColors.brownDeep,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '($reviews)',
                style: const TextStyle(
                  color: AppColors.brownLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9DCCA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.brownLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
