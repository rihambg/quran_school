import 'package:flutter/material.dart';
import 'financial_settings.dart';
import 'base_layout.dart';
import 'student_subscriptions_page.dart'; 

class FinancialManagement extends StatelessWidget {
  const FinancialManagement({Key? key}) : super(key: key);

  static const Color tealColor = Color(0xFF19A598);
  static const Color goldColor = Color(0xFFBE9656);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'الشؤون المالية',
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
                  'الصفحة الرئيسية / الشؤون المالية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Cards Grid 
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      // Row 1
                      Row(
                        children: [
                          const Expanded(
                            child: _FinancialTile(
                              color: tealColor,
                              icon: Icons.credit_card,
                              label: 'المتأخرون عن الدفع',
                              iconOpacity: 0.13,
                              bigBgIcon: Icons.credit_card,
                              bigIconAlignment: Alignment.centerLeft,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _FinancialTile(
                              color: tealColor,
                              icon: Icons.credit_card,
                              label: 'اشتراكات الطلاب',
                              iconOpacity: 0.13,
                              bigBgIcon: Icons.credit_card,
                              bigIconAlignment: Alignment.centerLeft,
                              onTap: (context) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentSubscriptionsPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Row 2
                      Row(
                        children: const [
                          Expanded(
                            child: _FinancialTile(
                              color: goldColor,
                              icon: Icons.arrow_downward,
                              label: 'المصاريف',
                              iconOpacity: 0.14,
                              bigBgIcon: Icons.arrow_downward,
                              bigIconAlignment: Alignment.centerLeft,
                            ),
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: _FinancialTile(
                              color: goldColor,
                              icon: Icons.arrow_upward,
                              label: 'المداخيل',
                              iconOpacity: 0.14,
                              bigBgIcon: Icons.arrow_upward,
                              bigIconAlignment: Alignment.centerLeft,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Row 3
                      Row(
                        children: const [
                          Expanded(
                            child: _FinancialTile(
                              color: tealColor,
                              icon: Icons.description,
                              label: 'التقارير المالية',
                              iconOpacity: 0.13,
                              bigBgIcon: Icons.credit_card,
                              bigIconAlignment: Alignment.centerLeft,
                            ),
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: _FinancialTile(
                              color: tealColor,
                              icon: Icons.credit_card,
                              label: 'رواتب المعلمين والموظفين',
                              iconOpacity: 0.13,
                              bigBgIcon: Icons.credit_card,
                              bigIconAlignment: Alignment.centerLeft,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // إعدادات المالية 
                      _FinancialTile(
                        color: tealColor,
                        icon: Icons.settings,
                        label: 'إعدادات المالية',
                        iconOpacity: 0.13,
                        bigBgIcon: Icons.settings,
                        bigIconAlignment: Alignment.centerLeft,
                        isWide: true,
                        onTap: (context) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FinancialSettingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
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

class _FinancialTile extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String label;
  final double iconOpacity;
  final bool isWide;
  final IconData bigBgIcon;
  final Alignment bigIconAlignment;
  final void Function(BuildContext context)? onTap;

  const _FinancialTile({
    required this.color,
    required this.icon,
    required this.label,
    this.iconOpacity = 0.13,
    this.isWide = false,
    required this.bigBgIcon,
    this.bigIconAlignment = Alignment.centerLeft,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_FinancialTile> createState() => _FinancialTileState();
}

class _FinancialTileState extends State<_FinancialTile>
    with SingleTickerProviderStateMixin {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final double scale = _hovering ? 1.04 : 1.0;
    final double iconScale = _hovering ? 1.14 : 1.0;
    final double iconRotation = _hovering
        ? 0.05
        : 0.0; // small turn in turns (1 turn = 360 deg, so 0.05 = 18deg)
    final duration = const Duration(milliseconds: 200);

    Widget tileContent = AnimatedScale(
      scale: scale,
      duration: duration,
      curve: Curves.ease,
      child: Container(
        height: 70,
        margin: widget.isWide ? EdgeInsets.zero : null,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                      color: widget.color.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8))
                ]
              : [],
        ),
        child: Stack(
          children: [
            
            Align(
              alignment: widget.bigIconAlignment,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 14, top: 0, right: 0, bottom: 0),
                child: AnimatedRotation(
                  turns: iconRotation,
                  duration: duration,
                  curve: Curves.ease,
                  child: AnimatedScale(
                    scale: iconScale,
                    duration: duration,
                    curve: Curves.ease,
                    child: Opacity(
                      opacity: widget.iconOpacity,
                      child: Icon(
                        widget.bigBgIcon,
                        size: 62,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Content
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
      tileContent = MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: () => widget.onTap!(context),
          child: tileContent,
        ),
      );
    } else {
      tileContent = MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: tileContent,
      );
    }

    return tileContent;
  }
}
