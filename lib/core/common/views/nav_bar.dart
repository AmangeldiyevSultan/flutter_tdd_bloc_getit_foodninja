import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/common/app/providers/user_provider.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/exports/blocs.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/extension/context_extension.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/colours.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/services/injection_container.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/bloc/dashboard_bloc.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/presentation/admin_panel/views/create_restaurant_screen.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/dashboard/features/presentation/dashboard/views/dashboard_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const routeName = '/navbar';

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pageAdmin = [
    BlocProvider(
      create: (_) => sl<DashboardBloc>(),
      child: const CreateRestaurantScreen(),
    ),
    const CreateRestaurantScreen(),
  ];

  final List<Widget> _page = [
    BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(const FetchRestaurantsEvent()),
      child: const DashBoardScreen(),
    ),
    const DashBoardScreen(),
    const DashBoardScreen(),
    const DashBoardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userStatus = context.read<UserProvider>().user;

    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: _navItem(
          0,
          MediaRes.svgIconHome,
          'Home',
          _page.length,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: _navItem(
          1,
          MediaRes.svgIconProfile,
          'Profile',
          _page.length,
        ),
        label: 'Profle',
      ),
      BottomNavigationBarItem(
        icon: _navItem(
          2,
          MediaRes.svgIconBuy,
          'Buy',
          _page.length,
        ),
        label: 'Buy',
      ),
      BottomNavigationBarItem(
        icon: _navItem(
          3,
          MediaRes.svgIconChat,
          'Chat',
          _page.length,
        ),
        label: 'Chat',
      ),
    ];

    final itemsAdmin = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: _navItem(
          0,
          MediaRes.svgIconHome,
          'Home',
          _pageAdmin.length,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: _navItem(
          1,
          MediaRes.svgIconProfile,
          'Profile',
          _pageAdmin.length,
        ),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      backgroundColor: Colours.backgroundColour,
      body: userStatus?.status == 'admin'
          ? _pageAdmin[_selectedIndex]
          : _page[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colours.shadowPurpleColour,
              blurRadius: 20,
              spreadRadius: 20,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(22),
            topLeft: Radius.circular(22),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
          child: BottomNavigationBar(
            elevation: 10,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: userStatus?.status == 'admin' ? itemsAdmin : items,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.greenAccent,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int selectedIndex,
    String svgIcon,
    String label,
    int pageLength,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(
        maxWidth: _selectedIndex == selectedIndex
            ? context.width * 1 / _pageAdmin.length
            : context.width * 0.5 / _pageAdmin.length,
      ),
      child: Container(
        margin: selectedIndex == 0
            ? const EdgeInsets.only(left: 10)
            : selectedIndex == 3
                ? const EdgeInsets.only(right: 10)
                : null,
        height: context.height * 0.07,
        decoration: _selectedIndex == selectedIndex
            ? BoxDecoration(
                gradient: Colours.gradientNavBar,
                borderRadius: BorderRadius.circular(14),
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              svgIcon,
              colorFilter: _selectedIndex != selectedIndex
                  ? ColorFilter.mode(
                      Colours.underLineColor.withOpacity(0.5),
                      BlendMode.modulate,
                    )
                  : null,
            ),
            if (_selectedIndex == selectedIndex) ...[
              Text(
                label,
                style: const TextStyle(
                  fontFamily: Fonts.inter,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
