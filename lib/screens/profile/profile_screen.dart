import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/screens/mentor-connect/widgets/ask_to_action.dart';
import '/screens/profile/cubit/profile_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/constants/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    final result = await AskToAction.deleteAction(
        context: context, title: 'Logout', content: 'Do you want to logout');

    if (result) {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == ProfileStatus.succuss) {
            final user = state.user;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 420.0,
                        decoration: const BoxDecoration(
                          color: Color(0xffF8EBFF),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xffF8EBFF),
                                  ),
                                ),
                                CircleAvatar(
                                  ///  backgroundColor: Colors.transparent,
                                  radius: 45.0,
                                  child: ClipOval(
                                    child: Image.network(
                                      user?.photUrl ?? errorImage,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              user?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     // const Icon(Icons.phone),
                                //     // const SizedBox(width: 5.0),
                                //     // Text(user?.phNumber ?? 'N/A'),
                                //     // const SizedBox(width: 5.0),
                                //   ],
                                // ),
                                SizedBox(
                                  width: _canvas.width * 0.8,
                                  height: 40.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.email),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        user?.email ?? 'N/A',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 10.0,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 20.0,
                                    ),
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor deserunt '),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 10.0,
                                  ),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.github,
                                          color: Colors.black,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.linkedin,
                                          color: Colors.blue,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.twitter,
                                          color: Colors.blue,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.globe,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 17.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Settings',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Icon(Icons.settings),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 17.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Notifications',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Icon(Icons.notifications),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: primaryColor,
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () => _logout(context),
                        child: const Text('Logout'),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return const LoadingIndicator();
        },
      ),
    );
  }

  //    Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       actions: [
  //         IconButton(
  //           onPressed: () async {
  //             await _authRepo.signOut();
  //             //await FirebaseAuth.instance.signOut();
  //           },
  //           icon: const Icon(Icons.logout),
  //         ),
  //       ],
  //     ),
  //     body: const Center(
  //       child: Text(
  //         'Profile',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     ),
  //   );
  // }
}
