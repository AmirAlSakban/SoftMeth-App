import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutorial_management_app/models/tutorial.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8080/api"; // Spring Boot default port
  static const String tutorialsEndpoint = "$baseUrl/tutorials";

  // Get all tutorials
  Future<List<Tutorial>> getAllTutorials({String? title}) async {
    try {
      String url = tutorialsEndpoint;
      if (title != null && title.isNotEmpty) {
        url += "?title=$title";
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Tutorial.fromJson(item)).toList();
      } else if (response.statusCode == 204) {
        return []; // No content
      } else {
        throw Exception('Failed to load tutorials: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get tutorial by ID
  Future<Tutorial> getTutorialById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$tutorialsEndpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Tutorial.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tutorial not found');
      } else {
        throw Exception('Failed to load tutorial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create new tutorial
  Future<Tutorial> createTutorial(Tutorial tutorial) async {
    try {
      final response = await http.post(
        Uri.parse(tutorialsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tutorial.toJson()),
      );

      if (response.statusCode == 201) {
        return Tutorial.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create tutorial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update tutorial
  Future<Tutorial> updateTutorial(int id, Tutorial tutorial) async {
    try {
      final response = await http.put(
        Uri.parse('$tutorialsEndpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tutorial.toJson()),
      );

      if (response.statusCode == 200) {
        return Tutorial.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tutorial not found');
      } else {
        throw Exception('Failed to update tutorial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete tutorial
  Future<void> deleteTutorial(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$tutorialsEndpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return; // Success
      } else if (response.statusCode == 404) {
        throw Exception('Tutorial not found');
      } else {
        throw Exception('Failed to delete tutorial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete all tutorials
  Future<void> deleteAllTutorials() async {
    try {
      final response = await http.delete(
        Uri.parse(tutorialsEndpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return; // Success
      } else {
        throw Exception('Failed to delete all tutorials: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get published tutorials
  Future<List<Tutorial>> getPublishedTutorials() async {
    try {
      final response = await http.get(
        Uri.parse('$tutorialsEndpoint/published'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Tutorial.fromJson(item)).toList();
      } else if (response.statusCode == 204) {
        return []; // No content
      } else {
        throw Exception('Failed to load published tutorials: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
