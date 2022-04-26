import 'package:flutter/material.dart';
import '/screens/mentor-connect/screens/choose_usertype.dart';
import '/screens/opportunities/screens/find_opportunities.dart';
import '/screens/opportunities/screens/opportunity_details.dart';
import '/screens/opportunities/screens/saved_opportunity.dart';
import '/screens/study-group/connect_with_group.dart';
import '/screens/study-group/groups_suggestions.dart';
import '/screens/study-group/screens/join_group.dart';
import '/screens/girl-table/screens/comments_screen.dart';
import '/screens/study-buddy/screens/buddies_suggestions.dart';
import '/screens/study-buddy/screens/buddy_connected.dart';
import '/screens/study-buddy/screens/connect_with_buddies.dart';
import '/screens/mentor-connect/screens/mentor/mentor_profile.dart';
import '/screens/mentor-connect/screens/mentor/mentee_connected.dart';
import '/screens/mentor-connect/screens/mentor/mentee_suggestions.dart';
import '/screens/girl-table/screens/choose_post_type.dart';
import '/screens/girl-table/share_your_problems.dart';
import '/screens/girl-table/discussion_screen.dart';
import '/screens/mentor-connect/screens/mentee/mentee_profile.dart';
import '/screens/mentor-connect/screens/mentor/create_mentor_profile.dart';
import '/screens/mentor-connect/screens/mentor/mentor_screen.dart';
import '/screens/chat/chat_screen.dart';
import '/screens/mentor-connect/screens/mentee/mentee_screen.dart';
import '/screens/mentor-connect/screens/mentee/mentor_connected.dart';
import '/nav/nav_screen.dart';
import '/screens/login/login_screen.dart';
import '/screens/signup/signup_screen.dart';
import 'auth_wrapper.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => const Scaffold());

      case AuthWrapper.routeName:
        return AuthWrapper.route();

      case NavScreen.routeName:
        return NavScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignupScreen.routeName:
        return SignupScreen.route();

      case CreateMentorProfile.routeName:
        return CreateMentorProfile.route();

      case MentorScreen.routeName:
        return MentorScreen.route();

      case MenteeScreen.routeName:
        return MenteeScreen.route();

      case DiscussionComments.routeName:
        return DiscussionComments.route(
            args: settings.arguments as DiscussionCommentsArgs);

      // case MenteeSuggestedMentors.routeName:
      //   return MenteeSuggestedMentors.route();

      case MenteeSuggestions.routeName:
        return MenteeSuggestions.route();

      case MentorConnected.routeName:
        return MentorConnected.route(
            args: settings.arguments as MentorConnectedArgs);

      case MenteeProfile.routeName:
        return MenteeProfile.route();

      case MentorProfile.routeName:
        return MentorProfile.route(
            args: settings.arguments as MentorProfileArgs);

      case MenteeConnected.routeName:
        return MenteeConnected.route(
            args: settings.arguments as MenteeConnectedArgs);

      case ChatScreen.routeName:
        return ChatScreen.route(args: settings.arguments as ChatScreenArgs);

      case ConnectWithBuddies.routeName:
        return ConnectWithBuddies.route();

      case BuddiesSuggestions.routeName:
        return BuddiesSuggestions.route(
            args: settings.arguments as BuddiesSuggestionsArgs);

      case DiscussionScreen.routeName:
        return DiscussionScreen.route(
            args: settings.arguments as DiscussionScreenArgs);

      case ShareYourProblems.routeName:
        return ShareYourProblems.route();

      case ChoosePostType.routeName:
        return ChoosePostType.route(
            args: settings.arguments as ChoosePostTypeArgs);

      case BuddyConnected.routeName:
        return BuddyConnected.route(
            args: settings.arguments as BuddyConnectedArgs);

      case ConnectWithGroup.routeName:
        return ConnectWithGroup.route();

      case StudyGroupsSuggestions.routeName:
        return StudyGroupsSuggestions.route(
            args: settings.arguments as GroupSuggestionsArgs);

      case JoinGroup.routeName:
        return JoinGroup.route(args: settings.arguments as JoinGroupArgs);

      case OpportunityDetails.routeName:
        return OpportunityDetails.route(
            args: settings.arguments as OpportunityDetailsArgs);

      case SavedOpportunities.routeName:
        return SavedOpportunities.route();

      case FindOpportunities.routeName:
        return FindOpportunities.route();

      case ChooseUserType.routeName:
        return ChooseUserType.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRouter(RouteSettings settings) {
    print('NestedRoute: ${settings.name}');
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Error',
          ),
        ),
        body: const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
