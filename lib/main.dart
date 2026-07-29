import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
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
        appBarTheme: AppBarTheme(
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

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
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

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
