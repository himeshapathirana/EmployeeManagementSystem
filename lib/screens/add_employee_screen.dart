import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:empsystem/models/employee.dart';
import 'package:empsystem/services/api_service.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee employee;
  final bool isEmpNoEditable;
  final VoidCallback onEmployeeAdded;
  const AddEmployeeScreen({
    super.key,
    required this.employee,
    this.isEmpNoEditable = true,
    required this.onEmployeeAdded,
  });

  @override
  AddEmployeeScreenState createState() => AddEmployeeScreenState();
}

class AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController empNameController;
  late TextEditingController empNoController;
  late TextEditingController empAddressController;
  late TextEditingController dateOfJoinController;
  late TextEditingController dateOfBirthController;
  late TextEditingController basicSalaryController;
  late TextEditingController departmentController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    empNameController = TextEditingController(text: widget.employee.empName);
    empNoController = TextEditingController(text: widget.employee.empNo);
    empAddressController =
        TextEditingController(text: widget.employee.empAddressLine1);
    dateOfJoinController =
        TextEditingController(text: widget.employee.dateOfJoin);
    dateOfBirthController =
        TextEditingController(text: widget.employee.dateOfBirth);
    basicSalaryController =
        TextEditingController(text: widget.employee.basicSalary.toString());
    departmentController =
        TextEditingController(text: widget.employee.departmentCode);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 6, 25, 41),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color.fromARGB(255, 6, 25, 41)),
      prefixIcon: Icon(icon, color: Color.fromARGB(255, 6, 25, 41)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color.fromARGB(255, 6, 25, 41), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        backgroundColor: Color.fromARGB(255, 6, 25, 41),
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Employee Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 6, 25, 41),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: empNameController,
                    decoration:
                        _buildInputDecoration('Employee Name', Icons.person),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required field' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: empNoController,
                    decoration:
                        _buildInputDecoration('Employee ID', Icons.badge),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required field' : null,
                    enabled: widget.isEmpNoEditable,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: empAddressController,
                    decoration:
                        _buildInputDecoration('Address', Icons.location_on),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context, dateOfJoinController),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateOfJoinController,
                        decoration: _buildInputDecoration(
                            'Date of Joining', Icons.calendar_today),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context, dateOfBirthController),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateOfBirthController,
                        decoration:
                            _buildInputDecoration('Date of Birth', Icons.cake),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: basicSalaryController,
                    decoration: _buildInputDecoration(
                        'Basic Salary', Icons.attach_money),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required field';
                      if (double.tryParse(value!) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: departmentController,
                    decoration: _buildInputDecoration(
                      'Department',
                      Icons.business,
                    ).copyWith(
                      hintText: 'IT, HR, or FIN',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() => _isLoading = true);
                              try {
                                final employee = Employee(
                                  empNo: empNoController.text,
                                  empName: empNameController.text,
                                  empAddressLine1: empAddressController.text,
                                  empAddressLine2: '',
                                  empAddressLine3: '',
                                  departmentCode: departmentController.text,
                                  dateOfJoin: dateOfJoinController.text,
                                  dateOfBirth: dateOfBirthController.text,
                                  basicSalary:
                                      double.parse(basicSalaryController.text),
                                  isActive: true,
                                );
                                await apiService.addEmployee(employee);

                                widget.onEmployeeAdded();

                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 6, 25, 41),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Save Employee',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    empNameController.dispose();
    empNoController.dispose();
    empAddressController.dispose();
    dateOfJoinController.dispose();
    dateOfBirthController.dispose();
    basicSalaryController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}
