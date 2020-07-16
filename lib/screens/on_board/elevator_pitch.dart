import 'package:bowie/screens/on_board/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = new PageController();

    final pages = [
      OnBoardPage(
        asset: "assets/onboard/give.svg",
        mainTitle: "Give to those in need",
        subTitle:
            "Food is a basic human right. We work towards a stronger, more nourished Alameda County, where no one worries where their next meal will come from.",
      ),
      OnBoardPage(
        asset: "assets/onboard/community.svg",
        mainTitle: "Give back to your community",
        subTitle:
            "We run on your support. 100% of your gift stays local to help our most vulnerable communities.",
      ),
      OnBoardPage(
        asset: "assets/onboard/secure.svg",
        mainTitle: "Security",
        subTitle:
            "Your security is very important to us. We're PCI compliant,  just one of our steps to protect your sensitive information.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("ACCFB")),
      body: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return pages[index % pages.length];
        },
      ),
    );
  }
}

class OnBoardPage extends StatelessWidget {
  final String asset;
  final String mainTitle;
  final String subTitle;
  final String buttonText;

  OnBoardPage(
      {@required this.asset,
      @required this.mainTitle,
      @required this.subTitle,
      this.buttonText = "GET STARTED"});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: SvgPicture.asset(asset),
            ),
            Spacer(flex: 3),
            Text(
              mainTitle,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black),
            ),
            Spacer(),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
            ),
            Spacer(flex: 4),
            RaisedButton(
              child: Text(buttonText,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            ),
            Spacer(flex: 3)
          ],
        ),
      ),
    );
  }
}
