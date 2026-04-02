import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.28, // Removed fixed height to allow for py-12 (approx 48)
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48), // py-12 is 48px
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.brownDeep, // #3B1F0A
            AppColors.brownMid,  // #6B3A1F
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24), // rounded-b-[24px]
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              softWrap: true,
              style: const TextStyle(
                color: AppColors.cream, // text-[#FBF6EC]
                fontSize: 32, // Adjusted for h2 feel
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8), // mb-2 approx
              Text(
                subtitle!,
                style: TextStyle(
                  color: AppColors.surface.withOpacity(0.7), // text-[#EFE2CC]/70
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
