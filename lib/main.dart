import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaplant/widgets.dart/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'instaplant',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor Data')),
      drawer: Container(width: 200, child: SideDrawer()),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('sensor').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        print('Streaming Snapshots');
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    Widget verticalList = ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) => _buildListItemVertical(context, data))
          .toList(),
    );

    Widget horizontalList = ListView(
      scrollDirection: Axis.horizontal,
      children: _getHorizontalItems(context),
    );

    var layout = Column(
      children: [
        Flexible(flex: 1, child: horizontalList),
        Divider(
          thickness: 0,
        ),
        Flexible(flex: 4, child: verticalList),
      ],
    );

    return layout;
  }

  /// builds a list item to be emplaced into a list
  Widget _buildListItemVertical(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    String description, value;
    Icon icon;

    switch (record.name) {
      case 'pH':
        description = 'Current Alkalinity (pH)';
        value = record.value.toString();
        icon = Icon(Icons.grain);
        break;
      case 'light':
        description = 'Light Sensitivity';
        value = record.value.toString() + ' lumens';
        icon = Icon(Icons.flare);
        break;
      case 'humidity':
        description = 'Humidity Level';
        value = record.value.toString() + '%';
        icon = Icon(Icons.cloud);
        break;
      case 'temperature':
        description = 'Temperature';
        value = record.value.toString() + ' °C';
        icon = Icon(Icons.ac_unit);
        break;
      case 'health':
        description = 'Health';
        value = record.value.toString() + '%';
        icon = Icon(Icons.battery_std);
        break;
      default:
        description = record.name;
        icon = Icon(Icons.warning);
        value = 'N/A';
    }

    //cards
    Widget vertical = Container(
        padding: EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 0),
        child: Card(
          borderOnForeground: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                //padding: EdgeInsets.only(left:5, right:5, top:5),

                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: ListTile(
                        title: Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          value,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 27, top: 5),
                          child: Center(
                            child: IconButton(
                              icon: icon,
                              color: Colors.black,
                              padding: EdgeInsets.only(left: 0),
                              iconSize: 60,
                              onPressed: () {},
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              ButtonBar(
                buttonPadding: EdgeInsets.only(),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10, bottom: 0),
                    child: FlatButton(
                      highlightColor: Colors.white,
                      child: const Text('DETAILS'),
                      padding: EdgeInsets.only(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () => {print('Details were requested.')},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));

    return vertical;
  }

  List<Widget> _getHorizontalItems(BuildContext context) {
    String description, value;
    Icon icon;

    var images = ['web/icons/cactus.png', 'web/icons/aloe-vera-copy.png'];

    //cards

    List<Widget> answer = new List<Widget>();

    for (int i = 0 ; i < images.length; i++) {

      Widget vertical = Container(

          decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),

        width: MediaQuery
          .of(context)
          .size
          .width,

        child: Image.asset(
          images[i],
        ));

      answer.addAll([vertical]);
    }

    return answer;
  }
}

class Record {
  final String name;
  final int value;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['value'] != null),
        name = map['name'],
        value = map['value'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$value>";
}
