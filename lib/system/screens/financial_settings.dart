import 'package:flutter/material.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/salary_types_management_page.dart';
import 'base_layout.dart';
import 'subscription_types_management.dart';
import 'expense_types_management_page.dart';
import 'salary_types_management_page.dart'; 

class FinancialSettingsPage extends StatelessWidget {
  const FinancialSettingsPage({Key? key}) : super(key: key);

  static const Color tealColor = Color(0xFF19A598);
  static const Color goldColor = Color(0xFFBE9656);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'إعدادات المالية',
      child: Center(
        child: Container(
          width: 970,
          margin: const EdgeInsets.symmetric(vertical: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Breadcrumb
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: goldColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Text(
                  'الصفحة الرئيسية / الشؤون المالية / إعدادات المالية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Cards Grid
              Column(
                children: [
                  // Row 1: أنواع الاشتراكات
                  Row(
                    children: [
                      Expanded(
                        child: _SettingsTile(
                          label: 'أنواع الاشتراكات',
                          icon: Icons.menu,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  const SubscriptionTypesManagementPage(),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Row 2: أنواع الرواتب
                  Row(
                    children: [
                      Expanded(
                        child: _SettingsTile(
                          label: 'أنواع الرواتب',
                          icon: Icons.menu,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const SalaryTypesManagementPage(),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Row 3: إدارة أنواع المصاريف
                  Row(
                    children: [
                      Expanded(
                        child: _SettingsTile(
                          label: 'إدارة أنواع المصاريف',
                          icon: Icons.menu,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  const ExpenseTypesManagementPage(),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _SettingsTile(
      {required this.label, required this.icon, this.onTap, Key? key})
      : super(key: key);

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final double scale = _hovering ? 1.03 : 1.0;
    final double iconScale = _hovering ? 1.15 : 1.0;
    final double iconRotation = _hovering ? 0.07 : 0.0; // ~25deg
    final duration = const Duration(milliseconds: 180);

    Widget tile = AnimatedScale(
      scale: scale,
      duration: duration,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: FinancialSettingsPage.tealColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: AnimatedRotation(
                  turns: iconRotation,
                  duration: duration,
                  child: AnimatedScale(
                    scale: iconScale,
                    duration: duration,
                    child: Opacity(
                      opacity: 0.13,
                      child: Icon(
                        widget.icon,
                        size: 54,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(widget.icon, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.onTap != null) {
      tile = MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: tile,
        ),
      );
    } else {
      tile = MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: tile,
      );
    }

    return tile;
  }
}
