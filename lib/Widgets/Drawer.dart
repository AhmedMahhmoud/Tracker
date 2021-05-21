import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_app/Controllers/FirebaseService/Firebase.dart';

import '../constants.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userType =
        Provider.of<FirebaseServices>(context, listen: false).userType;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 23,
          ),
          Container(
            width: 90,
            height: 90,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.black),
                image: DecorationImage(
                    image: NetworkImage(
                        "https://lh3.googleusercontent.com/proxy/vj4kDfwPb4EcMPuZu01pVAvC8sflXeYd1lMwx4gOVZvpzmZSfmgS0TkaQneb9bqW3zk6LtlB1rO-kKKH1jxkDEBDdZs1QnANimqwS5gSlqA6IHDXlQpe"))),
          ),
          Divider(
            thickness: 3,
          ),
          userType == "user"
              ? ListTile(
                  title: Text(
                    "My Drivers",
                    style: kTextStyle,
                  ),
                  trailing: Icon(Icons.car_rental),
                )
              : Container(),
          userType == "user"
              ? Divider(
                  thickness: 1,
                )
              : Container(),
          ListTile(
            onTap: () {
              Provider.of<FirebaseServices>(context, listen: false)
                  .signOut(context);
            },
            title: Text(
              "Logout",
              style: kTextStyle,
            ),
            trailing: Icon(Icons.logout),
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
