import 'dart:async';

import 'package:brahmo/screens/item_issue/item_confirm_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
class ItemSelectionsScreen extends StatefulWidget {
  static const id = "/itemSelection";
  const ItemSelectionsScreen({Key? key}) : super(key: key);

  @override
  _ItemSelectionsScreenState createState() => _ItemSelectionsScreenState();
}

class _ItemSelectionsScreenState extends State<ItemSelectionsScreen> {
  StreamController gridDataController = StreamController();
  String selectedID = "";
  String selectedName = "";
  int selectedIndex = -1;
  int selectedQuantity = 0;
  bool confirmPressed = false;


  Widget GridItemTileMaker(String itemID,int index,int quantityAvailable, int totalQuantity, String itemName,var screenWidth, var incomingData){
    return Container(
      width: screenWidth*0.5 - 20,
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              if(selectedIndex!=index){
                selectedQuantity=0;
                selectedID=itemID;
                selectedIndex=index;
                selectedName=itemName;
                gridDataController.sink.add(incomingData);
              }
            },
            child: selectedIndex == index ? SvgPicture.asset("assets/images/tick_sign.svg") : SvgPicture.asset("assets/images/untick_sign.svg"),
          ),
          Text(itemName),
          Row(
            children: [
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
                      child: GestureDetector(
                        onTap: (){
                          if(selectedIndex==index && selectedQuantity>0){
                            --selectedQuantity;
                            gridDataController.sink.add(incomingData);
                          }
                        },
                        child: SvgPicture.asset("assets/images/minus_sign.svg",width: screenWidth*0.05,),
                      ),
                    ),
                    Text(selectedIndex==index ? selectedQuantity.toString() : "0"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
                      child: GestureDetector(
                        onTap: (){
                          if(selectedIndex==index && selectedQuantity<quantityAvailable){
                            ++selectedQuantity;
                            gridDataController.sink.add(incomingData);
                          }
                        },
                        child: SvgPicture.asset("assets/images/plus_sign.svg",width: screenWidth*0.05,),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Text("${selectedIndex==index ? selectedQuantity : 0}/${quantityAvailable}"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> afterQRShown() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).get();
  }

  void qrImageToScan(var screenWidth) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).get();
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
      content: Container(
        width: screenWidth*0.5,
        color: Colors.white,
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email!).snapshots(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(userSnapshot.get("issue_history").length<snapshot.data.get("issue_history").length){
                Navigator.popUntil(context, ModalRoute.withName(ItemSelectionsScreen.id));
              }
            }
            return QrImage(
              data: selectedID.toString() + "/" + selectedQuantity.toString(),
              size: screenWidth*0.5,
            );
          },
        )
      )
    ));
    afterQRShown();
  }

  void onConfirmPressed(var screenWidth){
    Widget OkButton(){
      return GestureDetector(
        onTap: (){
          Navigator.pop(context);
          qrImageToScan(screenWidth);
        },
        child: Text("OK"),
      );
    }
    AlertDialog alert = AlertDialog(
      content: Text("${selectedName} ${selectedQuantity}"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      actions: [
        OkButton(),
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sports_items').snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            gridDataController.sink.add(snapshot.data);
            return StreamBuilder(
              stream: gridDataController.stream,
              builder: (context, AsyncSnapshot dataSnapshot){
                if(dataSnapshot.hasData){
                  List<Widget> toShow = [];
                  for(int i=0;i<dataSnapshot.data.docs.length;i++){
                    var element = dataSnapshot.data.docs[i];
                    toShow.add(GridItemTileMaker(element.id,i,element.get("available"), element.get("total_quantity"), element.get("name"), screenWidth,snapshot.data));
                  }
                  return ListView(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              if(selectedIndex!=-1 && selectedQuantity>0){
                                onConfirmPressed(screenWidth);
                                // DocumentReference postRef = FirebaseFirestore.instance.collection('sports_items').doc(selectedID);
                              }
                            },
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: Text("Confirm"),
                            ),
                          )
                        ],
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: toShow,
                      )
                    ],
                  );
                }
                return Container();
              },
            );
          }
          return Container();
        },
      )
    );
  }
}
