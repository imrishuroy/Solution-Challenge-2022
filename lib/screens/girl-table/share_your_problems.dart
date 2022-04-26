import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/discussion.dart';
import '/widgets/custom_text_field.dart';
import '/constants/constants.dart';
import '/repositories/girl-table/girl_table_repository.dart';
import '/screens/girl-table/cubit/girl_table_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/wrap_chip.dart';
import '/screens/mentor-connect/widgets/header.dart';
import 'screens/choose_post_type.dart';

class ShareYourProblems extends StatelessWidget {
  static const String routeName = '/share-problems';
  const ShareYourProblems({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => GirlTableCubit(
          girlTableRepository: context.read<GirlTableRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..loadTopics(),
        child: const ShareYourProblems(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
          child: BlocConsumer<GirlTableCubit, GirlTableState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == GirlTableStatus.succuss) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(
                        title: 'Share Your Problems',
                        onTap: null,
                        tralingIconColor: Colors.white,
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Topic',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Wrap(
                        spacing: 7.0,
                        children: state.topics.map((topic) {
                          print('Problem topic ${state.problemTopic}');
                          bool isSelected = topic == state.problemTopic;
                          print('is selected $isSelected');
                          return WrapChip(
                            isSelected: isSelected,
                            label: topic?.title ?? 'N/A',
                            onTap: () {
                              if (isSelected) {
                                print('This runs aaa');
                                // context
                                //     .read<GirlTableCubit>()
                                //     .deleteProblemTopic();

                                print('is selected $isSelected');
                              } else {
                                context
                                    .read<GirlTableCubit>()
                                    .addProblemTopic(topic);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Heading',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        onChanged: (value) => context
                            .read<GirlTableCubit>()
                            .problemTitleChanged(value),
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Title can\'t be empty';
                          }
                          return null;
                        },
                        hintText: 'Add your title',
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        maxLines: 5,
                        onChanged: (value) => context
                            .read<GirlTableCubit>()
                            .problemDescriptionChanged(value),
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description can\'t be empty';
                          }
                          return null;
                        },
                        hintText: 'Add your title',
                      ),
                      const SizedBox(height: 30.0),
                      Center(
                        child: SizedBox(
                          height: 52.0,
                          width: 120.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                            onPressed: () {
                              final discussion = Discussion(
                                title: state.problemTitle,
                                description: state.problemDescription,
                                users: const [],
                                topicId: state.problemTopic?.topicId,
                              );
                              print('Discussion problem --$discussion');

                              Navigator.of(context).pushNamed(
                                  ChoosePostType.routeName,
                                  arguments: ChoosePostTypeArgs(
                                      discussion: discussion));

                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (_) =>
                              //         ChoosePostType(discussion: discussion),
                              //   ),
                              // );
                            },
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return const LoadingIndicator();
            },
          ),
        ),
      ),
    );
  }
}
