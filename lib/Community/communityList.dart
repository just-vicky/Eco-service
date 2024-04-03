import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dropdown.dart';
import 'widgets.dart';
import 'package:http/http.dart' as http;

class CommunityListBuilder extends StatelessWidget {
  final Future<List<Community>> communities;
  final Function(Community?)? onDropdownChanged;

  const CommunityListBuilder({
    Key? key,
    required this.communities,
    required this.onDropdownChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Community>>(
      future: communities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Community> communityList = snapshot.data!;
          return SingleChildScrollView(
            child: CustomDropdown(
              dropdownItems: communityList,
              onChange: onDropdownChanged,
            ),
          );
        }
      },
    );
  }
}

class Community {
  final String id;
  final String location;
  final String name;
  final String day;

  Community({
    required this.id,
    required this.location,
    required this.name,
    required this.day,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
  return Community(
    id: json['community_id'] as String? ?? '',
    location: json['community_location'] as String? ?? '',
    name: json['community_name'] as String? ?? '',
    day: json['day_of_week'] as String? ?? '',
  );
}

  @override
  String toString() {
    return name;
  }
}

Future<List<Community>> fetchCommunities() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? storedData = prefs.getString('community_data');
  final int? storedTime = prefs.getInt('community_data_timestamp');

  if (storedData != null && storedTime != null) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final oneMinuteInMilliseconds = 60 * 1000;

    if (currentTime - storedTime <= oneMinuteInMilliseconds) {
      List<dynamic> jsonResponse = jsonDecode(storedData);
      List<Community> communities =
          jsonResponse.map((json) => Community.fromJson(json)).toList();
      return communities;
    } else {
      await prefs.remove('community_data');
      await prefs.remove('community_data_timestamp');
    }
  }

  final response = await http
      .get(Uri.parse('http://localhost:4000/api/schedule_details'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    List<Community> communities =
        jsonResponse.map((json) => Community.fromJson(json)).toList();

    await prefs.setString('community_data', jsonEncode(jsonResponse));
    await prefs.setInt('community_data_timestamp', DateTime.now().millisecondsSinceEpoch);

    return communities;
  } else {
    throw Exception('Failed to load communities');
  }
}

