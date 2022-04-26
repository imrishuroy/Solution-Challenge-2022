import 'package:flutter/material.dart';
import '/constants/constants.dart';
import '/screens/study-buddy/screens/connect_with_buddies.dart';
import '/screens/study-group/connect_with_group.dart';

class ChooseBuddyType extends StatelessWidget {
  const ChooseBuddyType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/study.jpg',
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 40.0),
            UserTypeTile(
              imgPath: 'assets/images/study-buddy.jpg',
              label: 'Search for a\nStudy Buddy',
              onTap: () =>
                  Navigator.of(context).pushNamed(ConnectWithBuddies.routeName),
            ),
            const Spacer(),
            UserTypeTile(
              imgPath: 'assets/images/study-group.jpg',
              label: 'Search for a\nStudy Group',
              onTap: () =>
                  Navigator.of(context).pushNamed(ConnectWithGroup.routeName),
            ),
            const Spacer(),
            SizedBox(
              height: 50.0,
              width: 200.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Search on Map'),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.location_on),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class UserTypeTile extends StatelessWidget {
  final String imgPath;
  final String label;
  final VoidCallback onTap;

  const UserTypeTile({
    Key? key,
    required this.imgPath,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 10.0,
            ),
          ],
          color: primaryColor,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.white, width: 0.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Image.asset(
                imgPath,
                fit: BoxFit.cover,
                width: 170.0,
                height: double.infinity,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
