import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/constants/constants.dart';
import 'widgets/carousel.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.white,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light,
        ), //)
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'DashBoard',
          style: TextStyle(color: primaryColor),
        ),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      drawer: const Drawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              const Carousel(
                imgList: [
                  'https://user-images.githubusercontent.com/1790822/28984617-e789fa78-792c-11e7-9c9f-17c23a70e6cc.png',
                  'https://developers.google.com/community/images/gdsc-solution-challenge/solutionchallenge-homepage.png',
                  'https://leverageedu.com/blog/wp-content/uploads/2019/12/Student-Exchange-Program-1.jpg',
                ],
              ),
              const SizedBox(height: 40.0),
              Container(
                height: 182.0,
                decoration: BoxDecoration(
                  color: const Color(0xffF8EBFF),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(child: Text(loremIpsum)),
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: GridView.builder(
                  itemCount: dashBoardItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final item = dashBoardItems[index];
                    return GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(item.routeName),
                      child: Column(
                        children: [
                          Card(
                            child: Image.network(
                              item.photoUrl,
                              height: 120.0,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            item.label,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
