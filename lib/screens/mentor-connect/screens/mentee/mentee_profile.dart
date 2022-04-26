import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/services.dart';
import '/widgets/wrap_chip.dart';
import '/enums/user_type.dart';
import '/widgets/custom_text_field.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/constants/constants.dart';

class MenteeProfile extends StatelessWidget {
  static const String routeName = '/mentee-profile';
  MenteeProfile({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => MentorConnectCubit(
            authBloc: context.read<AuthBloc>(),
            mentorConnectRepository: context.read<MentorConnectRepository>())
          ..loadMentee(),
        child: MenteeProfile(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      print('This runs mentee profile');
      await context
          .read<MentorConnectCubit>()
          .register(userType: UserType.mentee);
      Navigator.of(context).pop(true);

      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(MenteeScreen.routeName, (route) => false);

      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(NavScreen.routeName, (route) => false);
      // Navigator.of(context).pop();
      //Navigator.of(context).pushNamed(MentorsSuggestions.routeName);
      // _formKey.currentState?.reset();
      //context.read<MentorConnectCubit>().clearInterests();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build runs');
    return Scaffold(
      body: BlocConsumer<MentorConnectCubit, MentorConnectState>(
        listener: (context, state) {
          // if (state.mentee != null) {
          //   Navigator.of(context).pushNamed(MentorsSuggestions.routeName);
          // }
        },
        builder: (context, state) {
          if (state.status == MentorConnectStatus.submitting ||
              state.status == MentorConnectStatus.loading) {
            return const LoadingIndicator();
          }

          print('Mentee oo -- ${state.mentee}');
          print('Mentee ----- ${state.mentee}');
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        title: 'Connect with Mentor',
                        onTap: () {},
                        // onTap: () => Navigator.of(context)
                        //     .pushNamed(MentorsSuggestions.routeName),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Pursuing a Degree',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      CustomTextField(
                        initialValue: state.degree,
                        hintText: 'Enter your pursuing degree',
                        onChanged: (value) => context
                            .read<MentorConnectCubit>()
                            .degreeNameChanged(value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pursuing degree can\t be empty';
                          }
                          return null;
                        },
                        textInputType: TextInputType.name,
                      ),
                      const SizedBox(height: 14.0),
                      CustomTextField(
                        initialValue: state.phNo,
                        hintText: 'Enter your phone number',
                        onChanged: (value) => context
                            .read<MentorConnectCubit>()
                            .phNoChanged(value),
                        validator: (value) => Services.validateMobile(value!),
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 14.0),
                      const Text(
                        'Area of Interest',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      Wrap(
                          spacing: 7.0,
                          children: areasOfInteres.map((interest) {
                            bool isSelected =
                                state.interests.contains(interest);
                            return WrapChip(
                              isSelected: isSelected,
                              label: interest,
                              onTap: () {
                                if (isSelected) {
                                  context
                                      .read<MentorConnectCubit>()
                                      .delteInterest(interest);
                                } else {
                                  context
                                      .read<MentorConnectCubit>()
                                      .addInterest(interest);
                                }
                              },
                            );
                          }).toList()),
                      const SizedBox(height: 14.0),
                      const Text(
                        'Reason you want to be a mentor',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      TextFormField(
                        initialValue: state.reason,
                        maxLength: 250,
                        maxLines: 7,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                        onChanged: (value) => context
                            .read<MentorConnectCubit>()
                            .reasonChanged(value),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Let us know what\'s your motivation';
                          }
                          return null;
                        },
                        decoration: inputDecorator.copyWith(
                            hintText: 'What\'s your motivation'),
                      ),
                      const SizedBox(height: 40.0),
                      Center(
                        child: GestureDetector(
                          onTap: () => _submitForm(context,
                              state.status == MentorConnectStatus.submitting),
                          child: Container(
                            height: 45.0,
                            width: 180.0,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '  Find Your Mentor',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
