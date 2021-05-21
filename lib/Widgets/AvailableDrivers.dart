import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:track_app/Controllers/FirebaseService/Firebase.dart';

class AvailableDriversWidget extends StatelessWidget {
  AvailableDriversWidget(
      {Key? key, required this.firebaseProv, required this.snapshot})
      : super(key: key);
  final AsyncSnapshot snapshot;
  final FirebaseServices firebaseProv;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        return snapshot.data!.docs[index]["available"]
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 100,
                child: Card(
                  elevation: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn1.iconfinder.com/data/icons/male-profession-colour/1063/11-512.png")),
                            border: Border.all(
                              color: Colors.purple,
                            )),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(snapshot.data!.docs[index]["username"]),
                                Text(snapshot.data!.docs[index]["email"]),
                                Text(snapshot.data!.docs[index]["phone"]),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => new CupertinoAlertDialog(
                                          title: new Text(
                                              "Are you sure you want to add this driver ?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                final snackBar =
                                                    Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              onPressed: () async {
                                                await firebaseProv
                                                    .updateDriverStatus(
                                                        snapshot.data!
                                                            .docs[index].id,
                                                        !snapshot.data!
                                                                .docs[index]
                                                            ["available"],
                                                        context,
                                                        false);
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                      'Driver added successfully !'),
                                                  action: SnackBarAction(
                                                    label: 'Undo',
                                                    onPressed: () async {
                                                      print("undoing !");
                                                      await firebaseProv
                                                          .updateDriverStatus(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["available"],
                                                              context,
                                                              true);
                                                      // Some code to undo the change.
                                                    },
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              },
                                            ),
                                          ],
                                        ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            : snapshot.data!.docs.length == 0
                ? Container(
                    child: Card(
                      elevation: 10,
                      color: Colors.blueAccent[100],
                      child: Center(
                          child: Text(
                        "No drivers available now please try again later ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      )),
                    ),
                  )
                : Container();
      },
    );
  }
}
