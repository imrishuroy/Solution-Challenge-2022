import 'package:flutter/material.dart';
import '/screens/mentor-connect/screens/choose_usertype.dart';
import '/models/dashboard_item.dart';
import '/screens/opportunities/screens/find_opportunities.dart';

const primaryColor = Color(0xff4D2C5C);
const String mentor = 'mentor';
const String mentee = 'mentee';

InputDecoration inputDecorator = InputDecoration(
  fillColor: primaryColor,

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: Colors.red),
  ),
  contentPadding: const EdgeInsets.all(8),

  // prefixIcon:
  //     prefixIcon != null ? Icon(prefixIcon, color: Colors.white) : null,
  // suffixIcon: suffixIcon,
  labelStyle: const TextStyle(
    color: Colors.white,
    fontFamily: 'Montserrat',
    fontSize: 14.0,
    letterSpacing: 1.0,
  ),
  // hintText: hintText,
  hintStyle: const TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
);

const String errorImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjMD6Pl7n4lSFFphlDlRz7o4ULYlNrAC9KJN4sfz9mRDDgU_FzGrA-DNgLL8keHh90KJg&usqp=CAU';

const List<String> areasOfInteres = [
  'java',
  'python',
  'ml',
  'dart',
  'c',
  'c++',
  'aws',
  'gcp'
];

const List<DashBoardItem> dashBoardItems = [
  DashBoardItem(
    label: 'Opportunities',
    photoUrl:
        'https://media.istockphoto.com/vectors/vector-illustration-direction-sign-in-different-destination-choice-of-vector-id1249620665?k=20&m=1249620665&s=612x612&w=0&h=h2ybJz2rIkA3mBqaxSNYdYg5B7ZF_Nc7e5I5xzOFewY=',
    routeName: FindOpportunities.routeName,
  ),
  DashBoardItem(
    label: 'Study Buddy',
    photoUrl:
        'https://cdni.iconscout.com/illustration/premium/thumb/two-girls-hugging-each-other-2948418-2438555.png',
    routeName: ChooseUserType.routeName,
  ),
];

const String loremIpsum =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';
