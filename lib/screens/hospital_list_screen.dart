import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class HospitalListScreen extends StatelessWidget {
  const HospitalListScreen({super.key});

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
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppColors.brownMid, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Search hospitals...',
                            style: TextStyle(
                              color: Color(0xFFB69A83),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surface),
                    ),
                    child: const Icon(Icons.filter_alt_outlined, color: AppColors.brownMid, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
                itemCount: _hospitals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final h = _hospitals[index];
                  return _HospitalRowCard(
                    name: h.name,
                    location: h.location,
                    distance: h.distance,
                    rating: h.rating,
                    reviews: h.reviews,
                    tags: h.tags,
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
