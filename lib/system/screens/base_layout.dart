import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:get/get.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/controllers/theme.dart';
import '../widgets/image.dart';
import '../../system/widgets/lunch_url.dart';

class BaseLayout extends StatefulWidget {
  final String title;
  final Widget child;

  const BaseLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final GlobalKey<ScaffoldState> baseLayoutScaffoldKey =
      GlobalKey<ScaffoldState>();
  late ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = Get.find<ThemeController>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: baseLayoutScaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: CustomDrawer(),
      drawerEnableOpenDragGesture: true,
      body: Column(
        children: [
          _buildHeader(theme),
          Expanded(child: widget.child),
          _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      color: theme.appBarTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomAssetImage(assetPath: "assets/logo.png", height: 50),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: 10),
              _buildStoreButtons(),
            ],
          ),
          const SizedBox(height: 8),
          DottedLine(dashColor: theme.dividerColor),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  themeController.switchTheme();
                },
                icon:
                    Icon(Icons.nightlight_round, color: theme.iconTheme.color),
              ),
              IconButton(
                icon: Icon(Icons.menu, color: theme.iconTheme.color),
                onPressed: () =>
                    baseLayoutScaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreButtons() {
    return Wrap(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () => launchURL(
              'https://apps.apple.com/us/app/example-app/id123456789'),
          child:
              SvgPicture.asset('assets/appstore.svg', height: 50, width: 120),
        ),
        GestureDetector(
          onTap: () => launchURL(
              'https://play.google.com/store/apps/details?id=com.example.app'),
          child:
              CustomAssetImage(assetPath: 'assets/googleplay.png', height: 50),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        'جميع الحقوق محفوظة © 2025 نظام أهل القرآن',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
