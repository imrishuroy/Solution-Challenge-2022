import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants/constants.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/opportunities/opportunities_repository.dart';
import '/screens/opportunities/cubit/opportunities_cubit.dart';

class SavedOpportunities extends StatelessWidget {
  static const String routeName = '/saved-opportunities';
  const SavedOpportunities({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => OpportunitiesCubit(
          authBloc: context.read<AuthBloc>(),
          opportunitiesRepository: context.read<OpportunitiesRepository>(),
        )..loadSavedOpportunities(),
        child: const SavedOpportunities(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OpportunitiesCubit, OpportunitiesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == OpportunitiesStatus.succuss) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        const Text(
                          'Saved Opportunity',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: GridView.builder(
                        itemCount: state.opportunities.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                          // childAspectRatio: 0.87,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          final opportunity = state.opportunities[index];
                          print('Opp - $opportunity');
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    opportunity?.photoUrl ?? errorImage,
                                    height: 130.0,
                                    width: 170.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                opportunity?.name ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const LoadingIndicator();
        },
      ),
    );
  }
}
