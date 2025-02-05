import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/contributions_page.dart';
import 'package:flutter/material.dart';
// bottom_navigation.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_bo/core/constants/app_strings.dart';
import 'package:fireguard_bo/features/news_screen/presentation/presenter/page/news_page.dart';
import 'package:fireguard_bo/features/shared/app_shell/bloc/app_shell_bloc.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/page/home_page.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static final List<Widget> _pages = [
    const HomePage(),
    NewsPage(),
    ContributionsPage(),
    Center(
      child: Text('data 2'),
    ),
    Center(
      child: Text('data 3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppShellBloc(),
      child: BlocBuilder<AppShellBloc, AppShellState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentPageIndex,
              children: _pages,
            ),
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle:
                    WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(
                        color:
                            Colors.white,); // Color del texto cuando está activo
                  }
                  return const TextStyle(
                      color:
                          Colors.grey,); // Color del texto cuando está inactivo
                }),
              ),
              child: NavigationBar(
                indicatorColor: Colors.black,
                selectedIndex: state.currentPageIndex,
                backgroundColor: Colors.black,
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onDestinationSelected: (index) => context
                    .read<AppShellBloc>()
                    .add(AppShellPageChangedEvent(index)),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(
                      Icons.home,
                      color: Colors.red,
                    ),
                    label: AppStrings.home,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.newspaper_outlined),
                    selectedIcon: const Icon(
                      Icons.newspaper,
                      color: Colors.red,
                    ),
                    label: AppStrings.news,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.add_circle_outline_sharp),
                    selectedIcon: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.red,
                    ),
                    label: AppStrings.contribute,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_add),
                    selectedIcon: const Icon(
                      Icons.person_add_outlined,
                      color: Colors.red,
                    ),
                    label: AppStrings.follow,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.notifications),
                    selectedIcon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.red,
                    ),
                    label: AppStrings.updates,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
