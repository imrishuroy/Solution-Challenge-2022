import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/enums/nav_item.dart';
import 'bloc/nav_bloc.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/switch_screen.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<NavBloc>(
        create: (context) => NavBloc(),
        child: const NavScreen(),
      ),
    );

    // return PageRouteBuilder(
    //   settings: const RouteSettings(name: routeName),
    //   pageBuilder: (context, _, __) => BlocProvider(
    //     create: (context) => NavBloc(),
    //     child: const NavScreen(),
    //   ),
    // );
  }

  const NavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<NavBloc, NavItem>(
        builder: (context, activeNavItem) {
          return Scaffold(
            // floatingActionButton: FloatingActionButton(onPressed: () async {
            //   await context.read<MentorRepository>().getMentors(user: null);
            // }),
            //backgroundColor: Colors.black45,
            //  backgroundColor: Color.fromRGBO(25, 23, 37, 1),
            body: SwitchScreen(navItem: activeNavItem),
            bottomNavigationBar: BottomNavBar(
              navItem: activeNavItem,
              onitemSelected: (item) => BlocProvider.of<NavBloc>(context)
                  .add(UpdateNavItem(item: item)),
            ),
          );
        },
      ),
    );
  }
}
