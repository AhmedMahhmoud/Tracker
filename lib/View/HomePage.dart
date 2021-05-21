import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_app/Controllers/FirebaseService/Firebase.dart';

import 'package:track_app/Widgets/AvailableDrivers.dart';
import 'package:track_app/Widgets/Drawer.dart';
import 'package:track_app/constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firebaseProv = Provider.of<FirebaseServices>(context, listen: false);
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff1F242F),
        title: Text("Home Page"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  "https://img.freepik.com/free-vector/city-map-background-blue-tone_99087-101.jpg?size=626&ext=jpg",
                ),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Align(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: firebaseProv.userType == "user"
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Available Drivers",
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              alignment: Alignment.centerLeft,
            ),
            firebaseProv.userType == "user"
                ? StreamBuilder<QuerySnapshot>(
                    stream: firebaseProv.getDrivers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      return Expanded(
                        child: AvailableDriversWidget(
                          firebaseProv: firebaseProv,
                          snapshot: snapshot,
                        ),
                      );
                    },
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () {
                            firebaseProv.startTracking();
                          },
                          child: Card(
                            elevation: 15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Provider.of<FirebaseServices>(context)
                                              .trackingStatus ==
                                          false
                                      ? "Start Tracking"
                                      : "Stop Tracking",
                                  style: kTextStyle,
                                ),
                                Divider(),
                                Icon(Icons.location_on, color: Colors.red),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
