import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final url = Uri.parse('https://tour-boost-api.vercel.app/login');

  //almacenar los datos de forma segura en el dispositivo movil
  final storage = new FlutterSecureStorage();

  // Si retornamos algo, es un error
  /*Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'correo': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if (decodedResp.containsKey('token')) {
      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['token']);
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }*/

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'correo': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'password': password,
        'correo': email,
      }),
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      print(decodedResp);

      if (decodedResp.containsKey('token')) {
        // Token hay que guardarlo en un lugar seguro
        // decodedResp['idToken'];
        await storage.write(key: 'token', value: decodedResp['token']);
        return "200";
      } else {
        return decodedResp['error']['message'];
      }
    }else{
      return null;
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
