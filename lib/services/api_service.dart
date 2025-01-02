import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = Constants.baseUrl;

  // Fetch all employees
  Future<List<Employee>> fetchEmployees() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/v1.0/Employees'), headers: {
      'apiToken': Constants.apiKey,
    });

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  // Add employee
  Future<void> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1.0/Employee'),
      headers: {
        'apiToken': Constants.apiKey,
        'Content-Type': 'application/json',
      },
      body: json.encode(employee.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add employee: ${response.body}');
    }
  }

  // Update employee
  Future<void> updateEmployee(Employee employee) async {
    final updatedEmployeeJson = employee.toJson();

    if (!updatedEmployeeJson.containsKey('empNo')) {
      throw Exception('Employee number is required for updating.');
    }

    final employeeResponse = await http.get(
      Uri.parse('$baseUrl/api/v1.0/Employee/${employee.empNo}'),
      headers: {
        'apiToken': Constants.apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (employeeResponse.statusCode != 200) {
      throw Exception('Employee not found for update.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/v1.0/Employee/${employee.empNo}'),
      headers: {
        'apiToken': Constants.apiKey,
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedEmployeeJson),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update employee: ${response.body}');
    }
  }

  // Delete employee
  Future<void> deleteEmployee(String empNo) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1.0/Employee/$empNo'),
      headers: {'apiToken': Constants.apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}
