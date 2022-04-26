import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/topic.dart';
import '/screens/girl-table/share_your_problems.dart';
import '/widgets/loading_indicator.dart';
import '/repositories/girl-table/girl_table_repository.dart';
import '/screens/girl-table/cubit/girl_table_cubit.dart';
import '/constants/constants.dart';
import 'widgets/discussion_card.dart';
import 'widgets/discussion_header.dart';

class DiscussionScreenArgs {
  final Topic? topic;

  DiscussionScreenArgs({required this.topic});
}

class DiscussionScreen extends StatelessWidget {
  final Topic? topic;
  static const String routeName = '/discussions';
  const DiscussionScreen({
    Key? key,
    required this.topic,
  }) : super(key: key);

  static Route route({required DiscussionScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider<GirlTableCubit>(
        create: (context) => GirlTableCubit(
          girlTableRepository: context.read<GirlTableRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..loadDiscussions(topicId: args.topic?.topicId),
        child: DiscussionScreen(
          topic: args.topic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () =>
            Navigator.of(context).pushNamed(ShareYourProblems.routeName),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const DiscussionHeader(),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25.0,
                  ),
                ),
                Text(
                  topic?.title ?? '',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 20.0,
                  ),
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<GirlTableCubit, GirlTableState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == GirlTableStatus.loading) {
                return const LoadingIndicator();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: state.discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = state.discussions[index];
                    print('Users -- ${discussion?.users}');
                    return DicussionCard(
                      discussion: state.discussions[index],
                      onTap: () {
                        context.read<GirlTableCubit>().joinDiscussion(
                            discussion: state.discussions[index]);

                        context
                            .read<GirlTableCubit>()
                            .loadDiscussions(topicId: discussion?.topicId);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
