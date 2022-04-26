import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/study_group_user.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
import '/screens/study-buddy/cubit/study_buddy_cubit.dart';
import '/screens/study-group/cubit/study_group_cubit.dart';
import '/screens/study-group/groups_suggestions.dart';
import '/widgets/loading_indicator.dart';
import '/constants/constants.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/wrap_chip.dart';
import '/screens/mentor-connect/widgets/header.dart';

class ConnectWithGroup extends StatelessWidget {
  static const String routeName = '/connectWithGroup';
  ConnectWithGroup({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => StudyGroupCubit(
          authBloc: context.read<AuthBloc>(),
          studyBuddyRepository: context.read<StudyBuddyRepository>(),
        )..loadProfile(),
        child: ConnectWithGroup(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      final _studyBuddyCubit = context.read<StudyGroupCubit>();
      _studyBuddyCubit.register();
      final user = StudyGroupUser(
        interests: _studyBuddyCubit.state.interests,
        user: context.read<AuthBloc>().state.user,
        degree: _studyBuddyCubit.state.degree,
      );
      Navigator.of(context).pushNamed(StudyGroupsSuggestions.routeName,
          arguments: GroupSuggestionsArgs(user: user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudyGroupCubit, StudyGroupState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == StudyGroupStatus.loading) {
            return const LoadingIndicator();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Header(title: 'Connect with Group', onTap: () {}),
                      const SizedBox(height: 10.0),
                      Image.asset(
                        'assets/images/study-buddy.jpg',
                        height: 250.0,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 14.0),
                      CustomTextField(
                        initialValue: state.degree,
                        hintText: 'Enter your pursuing degree',
                        onChanged: (value) => context
                            .read<StudyGroupCubit>()
                            .degreeNameChanged(value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pursuing degree can\t be empty';
                          }
                          return null;
                        },
                        textInputType: TextInputType.name,
                      ),
                      const SizedBox(height: 20.0),
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
                                      .read<StudyGroupCubit>()
                                      .delteInterest(interest);
                                } else {
                                  context
                                      .read<StudyGroupCubit>()
                                      .addInterest(interest);
                                }
                              },
                            );
                          }).toList()),
                      //const Spacer(),

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
                      ),
                      //  const Spacer(),
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
