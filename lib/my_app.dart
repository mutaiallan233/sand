import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SAND'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;




  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CollectionReference uploads = FirebaseFirestore.instance.collection('uploads');
  late String counter;

  final myController = TextEditingController();


  Future<void> _futureUploads() async {
    uploads
        .add({"details": myController.value.text})
        .then((value) => print("collection add success"))
        .catchError((onError) => print(onError));
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('uploads').snapshots();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'Create a collection to the database:',
              ),
            StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                //return Text("Loading");
                return CircularProgressIndicator();
              }

              return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                     height: 150,
                     padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    // color: Colors.pinkAccent,
                     child: Card(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(data['details']),
                              leading: Icon(Icons.message_outlined),
                            ),
                            ButtonBar(
                              children: [
                                ElevatedButton(onPressed: () async{
                                  Navigator.pushNamed(context, '/slidablePage');
                                },
                                    child: Icon(Icons.comment)
                                ),
                                ElevatedButton(onPressed: (){},
                                    child: Icon(Icons.thumb_up)
                                ),
                                ElevatedButton(onPressed: (){},
                                    child: Icon(Icons.thumb_down)
                                )
                              ],
                            )
                          ],
                        ),
                      )
                  );
                }).toList(),
              );
            },
          ),
              /* Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Message here...',
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                        onPressed: _futureUploads,
                        icon: Icon(
                          Icons.send_outlined,
                          color: Colors.pink,
                          size: 24.0,
                        ),
                        label: Text('')),
                  )
                ],
              ),*/
            ],
          ),
        ],
      ),
    // This trailing comma makes auto-formatting nicer for build methods.

    );
  }
}







