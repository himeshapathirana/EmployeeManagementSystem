import 'package:flutter/material.dart';
import 'add_employee_screen.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String searchText = '';
  final ApiService apiService = ApiService();
  late Future<List<Employee>> employees;

  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    _refreshEmployees();
  }

  void _refreshEmployees() {
    setState(() {
      employees = apiService.fetchEmployees();
    });
  }

  void _viewEmployeeDetails(Employee employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Employee Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailCard(employee),
                    SizedBox(height: 24),
                    _buildActionButtons(employee),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(Employee employee) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailSection('Personal Information', [
              _buildDetailRow('Name', employee.empName),
              _buildDetailRow('Employee No', employee.empNo),
              _buildDetailRow('Date of Birth', employee.dateOfBirth),
            ]),
            Divider(height: 32),
            _buildDetailSection('Work Information', [
              _buildDetailRow('Department', employee.departmentCode),
              _buildDetailRow('Join Date', employee.dateOfJoin),
              _buildDetailRow('Basic Salary', employee.basicSalary.toString()),
            ]),
            Divider(height: 32),
            _buildDetailSection('Contact Information', [
              _buildDetailRow(
                  'Address',
                  [
                    employee.empAddressLine1,
                    employee.empAddressLine2,
                    employee.empAddressLine3,
                  ].where((line) => line.isNotEmpty).join('\n')),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Employee employee) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.edit_outlined),
            label: Text('Edit Details'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _editEmployee(employee),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.delete_outline),
            label: Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 226, 54, 42),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _deleteEmployee(employee),
          ),
        ),
      ],
    );
  }

  Future<void> _editEmployee(Employee employee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(
          employee: employee,
          isEmpNoEditable: false,
        ),
      ),
    );

    if (result == true) {
      _refreshEmployees();
    }
  }

  Future<void> _deleteEmployee(Employee employee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.empName}?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await apiService.deleteEmployee(employee.empNo);
        _refreshEmployees();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Employee deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete employee: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text(
                'Employee Directory',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )
            : TextField(
                controller: searchController,
                style: TextStyle(color: const Color.fromARGB(255, 10, 10, 10)),
                decoration: InputDecoration(
                  hintText: 'Search employees...',
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(179, 80, 79, 79)),
                  border: InputBorder.none,
                ),
                onChanged: (value) => _filterEmployees(value),
              ),
        backgroundColor: const Color.fromARGB(141, 29, 60, 85),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  _refreshEmployees();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEmployeeScreen(
                    employee: Employee(
                      empNo: '',
                      empName: '',
                      empAddressLine1: '',
                      empAddressLine2: '',
                      empAddressLine3: '',
                      departmentCode: '',
                      dateOfJoin: '',
                      dateOfBirth: '',
                      basicSalary: 0,
                      isActive: true,
                    ),
                  ),
                ),
              );
              if (result == true) _refreshEmployees();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Employee>>(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No employees found'),
                ],
              ),
            );
          }

          final filteredList = _filteredEmployees(snapshot.data!);

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final employee = filteredList[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _viewEmployeeDetails(employee),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color.fromARGB(255, 18, 38, 73),
                          child: Text(
                            employee.empName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.empName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                employee.departmentCode,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _filterEmployees(String query) {
    setState(() {
      searchText = query;
    });
  }

  List<Employee> _filteredEmployees(List<Employee> employeeList) {
    if (searchText.isEmpty) {
      return employeeList;
    }

    return employeeList.where((employee) {
      final empNameLower = employee.empName.toLowerCase();
      final empNoLower = employee.empNo.toLowerCase();
      final searchLower = searchText.toLowerCase();
      return empNameLower.contains(searchLower) ||
          empNoLower.contains(searchLower);
    }).toList();
  }
}
