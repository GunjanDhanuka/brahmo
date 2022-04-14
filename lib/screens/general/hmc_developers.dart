import 'dart:async';

import 'package:flutter/material.dart';
class HmcAndDevelopersInfo extends StatefulWidget {
  static const id = "/hmcAndDevelopers";
  const HmcAndDevelopersInfo({Key key}) : super(key: key);

  @override
  _HmcAndDevelopersInfoState createState() => _HmcAndDevelopersInfoState();
}

class _HmcAndDevelopersInfoState extends State<HmcAndDevelopersInfo> {
  int currentIndex=0;
  StreamController communityTypeController = StreamController();
  StreamController communityListController = StreamController();
  List<List<Widget>> communityInfo = [];

  Future<void> getCommunityInfo() async {
    communityInfo = [[Text("Anshul Kumar"), Text("Aman Raj")], [Text("Kunal Pal"), Text("Gunjan Dhanuka")]];
    communityListController.sink.add(communityInfo[0]);
  }

  Widget onHmcSelected(var screenWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          child: Container(
            width: screenWidth*0.35,
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
            margin: EdgeInsets.only(right: screenWidth*0.03,top: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
                "HMC members",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth*0.04,
                fontFamily: "Nunito",
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            print("Tapped");
            currentIndex=1;
            addRelevantRow(screenWidth);
            communityListController.sink.add(communityInfo[1]);
          },
          child: Container(
            width: screenWidth*0.35,
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
            margin: EdgeInsets.only(right: screenWidth*0.06,top: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
              "Developer group",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: screenWidth*0.04,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget onDevelopersSelected(var screenWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: (){
            currentIndex=0;
            addRelevantRow(screenWidth);
            communityListController.sink.add(communityInfo[0]);
          },
          child: Container(
            width: screenWidth*0.35,
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
            margin: EdgeInsets.only(right: screenWidth*0.03,top: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
              "HMC members",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: screenWidth*0.04,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        InkWell(
          child: Container(
            width: screenWidth*0.35,
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
            margin: EdgeInsets.only(right: screenWidth*0.06,top: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
              "Developer group",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth*0.04,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }

  void addRelevantRow(var screenWidth){
    if(currentIndex==0){
      communityTypeController.sink.add(onHmcSelected(screenWidth));
    }
    else{
      communityTypeController.sink.add(onDevelopersSelected(screenWidth));
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    getCommunityInfo();
    communityTypeController.sink.add(onHmcSelected(screenWidth));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder(
        future: getCommunityInfo(),
        builder: (context, snapshot){
          return ListView(
            children: [
              StreamBuilder(
                stream: communityTypeController.stream,
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return snapshot.data;
                  }
                  return Container();
                },
              ),
              StreamBuilder(
                stream: communityListController.stream,
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: snapshot.data,
                    );
                  }
                  return Container();
                },
              ),
            ],
          );
        },
      )
    );
  }
}
