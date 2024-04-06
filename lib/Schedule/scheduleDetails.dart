import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Community/communityList.dart';
import 'scheduleWidgets.dart';
import '../Community/dropdown.dart';

class ScheduleDetails extends StatefulWidget {
  @override
  State<ScheduleDetails> createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails> {
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  String formattedDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String formattedDay = DateFormat('EEEE').format(DateTime.now());

  String? selectedValue;

  late Future<List<Community>> communities;

  @override
  void initState() {
    super.initState();

    communities = fetchCommunities();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ECO Service',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xff204e22),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromARGB(255, 140, 201, 143),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Schedule of the Day',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            buildDateAndDayCards("Date", "Day", formattedDate, formattedDay),
            SizedBox(height: 20),
            Text(
              'List of Community',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child:buildListTile(context,)
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Community'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommunityListBuilder(
                            communities: communities,
                            onDropdownChanged: (community) {
                              if (community != null) {
                                setState(() {
                                  selectedValue = community.id;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              print('Selected Value: $selectedValue');
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Add Community'),
            ),
          ],
        ),
      ),
    );
  }
}
