

import 'package:flutter/material.dart';
import 'widgets.dart'; 
import 'dropdown.dart'; 
import 'communityList.dart'; 
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'communityData.dart';

class CommunityData {
  final String date;
  final String communityId;
  final int mixedBags;
  final int glassBags;
  final int plasticBags;
  final int paperBags;
  final int segLfBags;
  final int sanitoryBags;
  final double kgOfGlass;
  final double kgOfMixed;
  final double kgOfPlastic;
  final double kgOfPaper;
  final double kgOfSegLf;
  final double kgOfSanitory;
  final String? comments;

  CommunityData({
    required this.date,
    required this.communityId,
    required this.mixedBags,
    required this.glassBags,
    required this.plasticBags,
    required this.paperBags,
    required this.segLfBags,
    required this.sanitoryBags,
    required this.kgOfGlass,
    required this.kgOfMixed,
    required this.kgOfPlastic,
    required this.kgOfPaper,
    required this.kgOfSegLf,
    required this.kgOfSanitory,
    this.comments,
  });

  factory CommunityData.fromJson(Map<String, dynamic> json) {
    return CommunityData(
      date: json['date'],
      communityId: json['community_id'],
      mixedBags: json['mixed_bags'],
      glassBags: json['glass_bags'],
      plasticBags: json['plastic_bags'],
      paperBags: json['paper_bags'],
      segLfBags: json['seg_lf_bags'],
      sanitoryBags: json['sanitory_bags'],
      kgOfGlass: json['kg_of_glass'],
      kgOfMixed: json['kg_of_mixed'],
      kgOfPlastic: json['kg_of_plastic'],
      kgOfPaper: json['kg_of_paper'],
      kgOfSegLf: json['kg_of_seg_lf'],
      kgOfSanitory: json['kg_of_sanitory'],
      comments: json['comments'],
    );
  }
}
Future<CommunityData?> createCommunityData( CommunityData communityData,BuildContext context) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://localhost:4000/api/add_waste'));
    request.body = json.encode({
      'date': communityData.date,
      'community_id': communityData.communityId,
      'mixed_bags': communityData.mixedBags,
      'glass_bags': communityData.glassBags,
      'plastic_bags': communityData.plasticBags,
      'paper_bags': communityData.paperBags,
      'seg_lf_bags': communityData.segLfBags,
      'sanitory_bags': communityData.sanitoryBags,
      'kg_of_glass': communityData.kgOfGlass,
      'kg_of_mixed': communityData.kgOfMixed,
      'kg_of_plastic': communityData.kgOfPlastic,
      'kg_of_paper': communityData.kgOfPaper,
      'kg_of_seg_lf': communityData.kgOfSegLf,
      'kg_of_sanitory': communityData.kgOfSanitory,
      'comments': communityData.comments,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response);

    if (response.statusCode == 201) {
      final responseBody = await utf8.decodeStream(response.stream);
      print(responseBody);

      // Parse the response body to create a CommunityData object if needed
      // For example:
      // CommunityData createdData = CommunityData.fromJson(json.decode(responseBody));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("$responseBody"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to create community data: ${response.reasonPhrase}"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      
    }
  } catch (e) {
    print('Error: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred: $e"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    
  }
}

