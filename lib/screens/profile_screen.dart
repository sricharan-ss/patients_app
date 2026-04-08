import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'my_information_screen.dart';
import 'order_history_screen.dart';
import 'secure_vault_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDF8), Color(0xFFEFE2CC)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF3B1F0A), Color(0xFF6B3A1F)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4822A),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'C',
                        style: TextStyle(
                          color: Color(0xFFFBF6EC),
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Charan',
                      style: TextStyle(
                        color: Color(0xFFFBF6EC),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'VITADATA ID: VD-892401',
                      style: TextStyle(
                        color: const Color(0xFFEFE2CC).withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // My Information
                      _buildSectionCard(
                        context,
                        title: 'My Information',
                        preview: '28 years • O+',
                        icon: Icons.person_outline,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyInformationScreen()),
                          );
                        },
                        isInformation: true,
                        details: [
                          {'label': 'Age', 'value': '28 years'},
                          {'label': 'Gender', 'value': 'Male'},
                          {'label': 'Phone', 'value': '+91 98765 43210'},
                          {'label': 'Email', 'value': 'charan@example.com'},
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Order History
                      _buildSectionCard(
                        context,
                        title: 'Order History',
                        preview: '2 orders',
                        icon: Icons.inventory_2_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Secure Vault
                      _buildSectionCard(
                        context,
                        title: 'Secure Vault',
                        preview: '8 files stored',
                        icon: Icons.lock_outline,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SecureVaultScreen()),
                          );
                        },
                      ),
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

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String preview,
    required IconData icon,
    required VoidCallback onTap,
    bool isInformation = false,
    List<Map<String, String>>? details,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF6EC),
          border: Border.all(color: const Color(0xFFEFE2CC)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFE2CC),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: const Color(0xFF6B3A1F), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF3B1F0A),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        style: const TextStyle(
                          color: Color(0xFF6B3A1F),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFA0622A), size: 20),
              ],
            ),
            if (isInformation && details != null) ...[
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFEFE2CC), height: 1),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['label']!,
                        style: const TextStyle(
                          color: Color(0xFFA0622A),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detail['value']!,
                        style: const TextStyle(
                          color: Color(0xFF3B1F0A),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
