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
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Employee Management System',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.8,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 6, 25, 41),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 6, 25, 41).withOpacity(0.1),
              Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: screenSize.height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context),
                SizedBox(height: screenSize.height * 0.05),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 6, 25, 41),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Manage your workforce efficiently',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey[800],
              letterSpacing: 0.5,
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
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return _buildMenuCard(context, options[index]);
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuOption option) {
    final Size screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 4,
      shadowColor: option.color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: screenSize.height * 0.13,
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.06,
            vertical: screenSize.height * 0.025,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                option.color.withOpacity(0.8),
                option.color,
              ],
            ),
          ),
          child: Row(
            children: [
              Icon(
                option.icon,
                size: screenSize.width * 0.09,
                color: Colors.white,
              ),
              SizedBox(width: screenSize.width * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.048,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: screenSize.width * 0.032,
                        letterSpacing: 0.4,
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
