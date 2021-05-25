import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:gas_gameappstore/models/Users/user.dart';

class Services {
  static const ROOT = 'http://10.0.2.2/UsersDB/Users_Actions.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_USER_ACTION = 'ADD_USER';
  static const _UPDATE_PROFILE_ACTION = 'UPDATE_PROFILE';
  

  //method create table
  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Create Table Response: ${response.body}');
      return response.body;
    } catch (e) {
      return "error";
    }
  }

  static Future<List<User>> getUsers() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body);
        return list;
      } else {
        return List<User>();
      }
    } catch (e) {
      return List<User>();
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  // Method to add user to the database...
  static Future<String> addUser(
      String userEmail, String userName, String userPassword) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_USER_ACTION;
      map['UserEmail'] = userEmail;
      map['UserName'] = userName;
      map['UserPassword'] = userPassword;
      map['UserRole'] = "Customer";
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update user profile in Database...
  static Future<String> updateUser(
      BigInt userId,
      String userName,
      String userPhoneNumber,
      String userAddress,
      String userTransactionPIN,
      String userProfilePicture) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_PROFILE_ACTION;
      map['UserId'] = userId;
      map['UserName'] = userName;
      map['UserPhoneNumber'] = userPhoneNumber;
      map['UserAddress'] = userAddress;
      map['UserTransactionPIN'] = userTransactionPIN;
      map['UserProfilePicture'] = userProfilePicture;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
