import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/study_buddy.dart';
import '/screens/study-buddy/screens/buddies_suggestions.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
import '/constants/constants.dart';
import '/screens/study-buddy/cubit/study_buddy_cubit.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/wrap_chip.dart';
import '/screens/mentor-connect/widgets/header.dart';

class ConnectWithBuddies extends StatefulWidget {
  static const String routeName = '/buddies';
  const ConnectWithBuddies({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => StudyBuddyCubit(
          authBloc: context.read<AuthBloc>(),
          studyBuddyRepository: context.read<StudyBuddyRepository>(),
        )..loadProfile(),
        child: const ConnectWithBuddies(),
      ),
    );
  }

  @override
  State<ConnectWithBuddies> createState() => _ConnectWithBuddiesState();
}

class _ConnectWithBuddiesState extends State<ConnectWithBuddies> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      final _studyBuddyCubit = context.read<StudyBuddyCubit>();
      _studyBuddyCubit.register();
      final buddy = StudyBuddy(
        interests: _studyBuddyCubit.state.interests,
        user: context.read<AuthBloc>().state.user,
        degree: _studyBuddyCubit.state.degree,
      );
      Navigator.of(context).pushNamed(BuddiesSuggestions.routeName,
          arguments: BuddiesSuggestionsArgs(currentUser: buddy));
      //   Navigator.of(context).pop();
      // Navigator.of(context).pushNamed(MenteeSuggestions.routeName);
      // _formKey.currentState?.reset();
      // context.read<MentorConnectCubit>().clearInterests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudyBuddyCubit, StudyBuddyState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == StudyBuddyStatus.submitting) {
            return const LoadingIndicator();
          }

          print('Degreee -- ${state.degree}');
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 15.0,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Header(
                          title: 'Connect with Buddies',
                          onTap: () {},
                        ),
                        Image.asset(
                          'assets/images/study-buddy.jpg',
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                              .read<StudyBuddyCubit>()
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
                                        .read<StudyBuddyCubit>()
                                        .delteInterest(interest);
                                  } else {
                                    context
                                        .read<StudyBuddyCubit>()
                                        .addInterest(interest);
                                  }
                                },
                              );
                            }).toList()),
                        const SizedBox(height: 40.0),
                        Center(
                          child: GestureDetector(
                            onTap: () => _submitForm(context,
                                state.status == StudyBuddyStatus.submitting),
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
                                    '  Find the Mentee',
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
            ),
          );
        },
      ),
    );
  }
}
