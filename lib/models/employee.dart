class Employee {
  final String empNo;
  final String empName;
  final String empAddressLine1;
  final String empAddressLine2;
  final String empAddressLine3;
  final String departmentCode;
  final String dateOfJoin;
  final String dateOfBirth;
  final num basicSalary;
  final bool isActive;

  Employee({
    required this.empNo,
    required this.empName,
    required this.empAddressLine1,
    required this.empAddressLine2,
    required this.empAddressLine3,
    required this.departmentCode,
    required this.dateOfJoin,
    required this.dateOfBirth,
    required this.basicSalary,
    required this.isActive,
  });

  // Method to convert data from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empNo: json['empNo'],
      empName: json['empName'],
      empAddressLine1: json['empAddressLine1'],
      empAddressLine2: json['empAddressLine2'],
      empAddressLine3: json['empAddressLine3'],
      departmentCode: json['departmentCode'],
      dateOfJoin: json['dateOfJoin'],
      dateOfBirth: json['dateOfBirth'],
      basicSalary: json['basicSalary'],
      isActive: json['isActive'],
    );
  }

  // Method to convert data to JSON
  Map<String, dynamic> toJson() {
    return {
      'empNo': empNo,
      'empName': empName,
      'empAddressLine1': empAddressLine1,
      'empAddressLine2': empAddressLine2,
      'empAddressLine3': empAddressLine3,
      'departmentCode': departmentCode,
      'dateOfJoin': dateOfJoin,
      'dateOfBirth': dateOfBirth,
      'basicSalary': basicSalary,
      'isActive': isActive,
    };
  }

  static empty() {}
}
