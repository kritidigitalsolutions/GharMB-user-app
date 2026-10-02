import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/home/providers/home_provider.dart';
import 'package:gharmb_app/features/home/views/home_screen.dart';
import 'package:gharmb_app/features/home/views/wishlist_page.dart';
import 'package:gharmb_app/features/profile/views/profile_screen.dart';
import 'package:gharmb_app/features/project/views/project_list_page.dart';
import 'package:gharmb_app/features/property/views/add_property/property_list_type.dart';
import 'package:gharmb_app/routes/app_routes.dart';
import 'package:gharmb_app/shared/bottom_nav_bar/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 83, 64, 64),
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.light, // iOS

      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}

// main pages

class MyHomePage extends ConsumerStatefulWidget {
  final int? initialIndex;

  const MyHomePage({super.key, this.initialIndex});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = const [
      HomePage(),
      WishlistPage(),
      PropertyListType(),
      ProjectListPage(),
      ProfilePage(),
    ];

    // optional initial index set
    if (widget.initialIndex != null) {
      Future.microtask(() {
        ref.read(currentIndexProvider.notifier).state = widget.initialIndex!;
      });
    }
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text('Exit App?', style: text18(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to exit the app?',
                style: text13(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text(
                        'Cancel',
                        style: text14(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                      ),
                      child: Text(
                        'Yes, Exit',
                        style: text14(
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (currentIndex != 0) {
          // If on another tab, go to Home screen
          ref.read(currentIndexProvider.notifier).state = 0;
        } else {
          // If on Home screen, show exit confirmation dialog
          final shouldExit = await _showExitDialog(context);
          if (shouldExit == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: currentIndex == 4
                ? AppColors.primary
                : AppColors.white,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: AppColors.white,

          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(currentIndexProvider.notifier).state = index;
            },
          ),

          body: IndexedStack(index: currentIndex, children: screens),

          floatingActionButton: Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: FloatingActionButton(
              onPressed: () {
                ref.read(currentIndexProvider.notifier).state = 2;
              },
              backgroundColor: AppColors.primary,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: AppColors.white, size: 30),
            ),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
