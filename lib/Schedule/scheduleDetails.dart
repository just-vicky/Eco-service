import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../api/communityList.dart';
import '../api/scheduleList.dart';
import '../api/scheduledata.dart';
import '../hive/schedule.dart';
import '../hive/scheduleData.dart';
import 'scheduleWidgets.dart';
import '../hive/community.dart';

class ScheduleDetailScreen extends StatefulWidget {
  const ScheduleDetailScreen({super.key});

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  String formattedDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String formattedDay = DateFormat('EEEE').format(DateTime.now());

  late ScheduleData scheduleData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    late String selectedValue;

    late List<Community> communities = [];
    late String scheduleId = '';

    final Box<Community> communityBox = Hive.box<Community>('communities');
    final Box<Schedule> box = Hive.box<Schedule>('schedule');
   

    Schedule? scheduleDetails = box.get('schedule');

    if (scheduleDetails != null) {
      communities = scheduleDetails.communities;
      scheduleId = scheduleDetails.scheduleId;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ECO Service',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xff204e22),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 140, 201, 143),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text(
                'Schedule of the Day',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            buildDateAndDayCards("Date", "Day", formattedDate, formattedDay),
            const SizedBox(height: 20),
            const Text(
              'List of Community',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: buildListTile(context, communities),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: const Text('Add Community'),
            //           content: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               CommunityListBuilder(
            //                 communities: communityBox.values.toList(),
            //                 onDropdownChanged: (community) {
            //                   if (community != null) {
            //                     setState(() {
            //                       selectedValue = community.id;
            //                     });
            //                   }
            //                 },
            //               ),
            //               const SizedBox(height: 20),
            //               ElevatedButton(
            //                 onPressed: () async {
            //                    scheduleData = ScheduleData(
            //                     communityId: selectedValue,
            //                     schedule_id: scheduleId,
            //                   );

            //                   await createScheduleData(scheduleData);
            //                   print('selected Value: $selectedValue');
            //                   Navigator.of(context).pop();
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     const SnackBar(
            //                       content: Text('Community Added'),
            //                     ),
            //                   );
            //                 },
            //                 child: const Text('Submit'),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            //   child: const Text('Add Community'),
            // ),
          ],
        ),
      ),
    );
  }
}
