import 'package:flutter/material.dart';
import 'package:empsystem/screens/add_employee_screen.dart';
import 'package:empsystem/screens/employee_list_screen.dart';
import 'package:empsystem/models/employee.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8),
            const Text(
              'Employee Management System',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 70, 104, 121),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
              Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: screenSize.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context),
                SizedBox(height: screenSize.height * 0.04),
                _buildGridSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 6, 25, 41),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your workforce efficiently',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              color: Colors.grey[700],
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSection(BuildContext context) {
    final List<MenuOption> options = [
      MenuOption(
        title: 'Employee List',
        subtitle: 'View and manage employees',
        icon: Icons.people,
        color: const Color.fromARGB(255, 6, 25, 41),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeListScreen()),
        ),
      ),
      MenuOption(
        title: 'Add Employee',
        subtitle: 'Create new employee record',
        icon: Icons.person_add,
        color: const Color.fromARGB(255, 6, 25, 41),
        onTap: () => _navigateToAddEmployee(context),
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildMenuCard(context, options[index]);
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuOption option) {
    final Size screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 3,
      shadowColor: option.color.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: screenSize.height * 0.12,
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                option.color.withValues(alpha: 0.05),
                option.color,
              ],
            ),
          ),
          child: Row(
            children: [
              Icon(
                option.icon,
                size: screenSize.width * 0.08,
                color: Colors.white,
              ),
              SizedBox(width: screenSize.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.045,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.008),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.05),
                        fontSize: screenSize.width * 0.03,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _navigateToAddEmployee(BuildContext context) {
  Navigator.push(
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
        onEmployeeAdded: () {},
      ),
    ),
  );
}

class MenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  MenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
