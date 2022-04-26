import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/opportunities/opportunities_repository.dart';
import '/screens/opportunities/cubit/opportunities_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '/constants/constants.dart';
import '/models/opportunity.dart';

class OpportunityDetailsArgs {
  final Opportunity? opportunity;

  OpportunityDetailsArgs({required this.opportunity});
}

class OpportunityDetails extends StatelessWidget {
  static const String routeName = '/opportunityDetails';
  final Opportunity? opportunity;
  const OpportunityDetails({Key? key, required this.opportunity})
      : super(key: key);

  static Route route({required OpportunityDetailsArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => OpportunitiesCubit(
          authBloc: context.read<AuthBloc>(),
          opportunitiesRepository: context.read<OpportunitiesRepository>(),
        ),
        child: OpportunityDetails(opportunity: args.opportunity),
      ),
    );
  }

  void _launchURL(String? url) async {
    if (url != null) {
      if (!await launch(url)) throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                opportunity?.photoUrl ?? errorImage,
                height: 250.0,
                width: double.infinity,
              ),
              Positioned(
                top: 40.0,
                left: 20.0,
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
          SizedBox(
            height: _canvas.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      opportunity?.name ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      opportunity?.description ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 17.0,
                        color: Color(0xff555555),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 60.0,
                width: 130.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onPressed: () => _launchURL(opportunity?.link),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
                width: 130.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onPressed: () {
                    context.read<OpportunitiesCubit>().saveOpportunity(
                        opportunityId: opportunity?.opportunityId);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Image.asset(
                            'assets/images/done.png',
                            height: 70.0,
                            width: 70.0,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Opportunity\nSaved!!!',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    // DisplayMessage.succussMessage(context,
                    //     title: 'Opportunity Saved');
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
