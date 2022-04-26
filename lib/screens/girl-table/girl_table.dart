import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/girl-table/discussion_screen.dart';
import '/widgets/display_image.dart';
import '/screens/girl-table/cubit/girl_table_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/constants/constants.dart';

import '/widgets/custom_text_field.dart';

class GirlTable extends StatelessWidget {
  const GirlTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              //SizedBox(height: 10.0),
              const Center(
                child: Text(
                  'Community',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                contentPadding: const EdgeInsets.all(8.0),
                onChanged: (value) {},
                textInputType: TextInputType.name,
                validator: (value) {
                  return null;
                },
                hintText: '  Search for topic',
              ),

              const SizedBox(height: 20.0),
              Expanded(
                child: BlocConsumer<GirlTableCubit, GirlTableState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.status == GirlTableStatus.loading) {
                      return const LoadingIndicator();
                    }
                    final topics = state.topics;

                    return GridView.builder(
                      itemCount: topics.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            DiscussionScreen.routeName,
                            arguments: DiscussionScreenArgs(
                              topic: topic,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 160.0,
                                width: 160.0,
                                child: DisplayImage(
                                  fit: BoxFit.cover,
                                  imageUrl: topic?.labelImg,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                topic?.title ?? '',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
