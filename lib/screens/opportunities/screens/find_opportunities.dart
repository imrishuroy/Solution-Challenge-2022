import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/display_image.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/opportunities/opportunities_repository.dart';
import '/screens/opportunities/screens/saved_opportunity.dart';
import '/screens/opportunities/screens/opportunity_details.dart';
import '/models/opportunity.dart';
import '/screens/opportunities/cubit/opportunities_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/custom_text_field.dart';
import '/constants/constants.dart';

class FindOpportunities extends StatelessWidget {
  static const String routeName = '/find-opportunities';
  const FindOpportunities({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => OpportunitiesCubit(
          authBloc: context.read<AuthBloc>(),
          opportunitiesRepository: context.read<OpportunitiesRepository>(),
        )..loadOpportunities(),
        child: const FindOpportunities(),
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
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: primaryColor,
                      ),
                      child: const Center(
                        child: Text(
                          'Find Opportunities',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(primary: primaryColor),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(SavedOpportunities.routeName),
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        label: const Text('Saved Opportunities'),
                      ),
                    ),
                    CustomTextField(
                      onChanged: (value) {},
                      textInputType: TextInputType.name,
                      validator: (value) {
                        return null;
                      },
                      hintText: '  Name/Month',
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.opportunities.length,
                        itemBuilder: (context, index) {
                          final opportunity = state.opportunities[index];
                          return OpportunityCard(opportunity: opportunity);
                        },
                      ),
                    ),
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

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    Key? key,
    required this.opportunity,
  }) : super(key: key);

  final Opportunity? opportunity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            OpportunityDetails.routeName,
            arguments: OpportunityDetailsArgs(opportunity: opportunity)),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: const Color(0xffF8EAFF),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: DisplayImage(
                    imageUrl: opportunity?.photoUrl ?? errorImage,
                    width: 120.0,
                    fit: BoxFit.cover,
                    height: 100,
                  )),
              const Spacer(),
              Text(
                opportunity?.name ?? 'N/A',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 17.0,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
