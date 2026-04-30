import 'package:flutter/material.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แบบฟอร์มลงทะเบียน',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      home: const RegistrationFormScreen(),
    );
  }
}

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDepartment;
  final TextEditingController _otherDepartmentController = TextEditingController();

  // Mock data
  final List<String> _mockNames = [
    'นาย สมชาย ใจดี',
    'นางสาว สมหญิง ยิ่งใหญ่',
    'นาย มานะ อดทน',
    'นาง สมบูรณ์ พูนสุข',
  ];

  final List<String> _departments = [
    'ฝ่ายบุคคล (HR)',
    'ฝ่ายการเงิน (Finance)',
    'ฝ่ายบริหาร (Admin)',
    'ฝ่ายเทคโนโลยีสารสนเทศ (IT)',
    'ฝ่ายการตลาด (Marketing)',
    'อื่นๆ',
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final empId = _employeeIdController.text;
      final name = _nameController.text;
      final department = _selectedDepartment == 'อื่นๆ'
          ? _otherDepartmentController.text
          : _selectedDepartment;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ลงทะเบียนสำเร็จ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('รหัสบุคลากร: $empId'),
              Text('ชื่อ-สกุล: $name'),
              Text('หน่วยงานที่สังกัด: $department'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _employeeIdController.clear();
    _nameController.clear();
    _otherDepartmentController.clear();
    setState(() {
      _selectedDepartment = null;
    });
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _otherDepartmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แบบฟอร์มลงทะเบียนบุคลากร'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'กรุณากรอกข้อมูลเพื่อลงทะเบียน',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      
                      // Employee ID
                      TextFormField(
                        controller: _employeeIdController,
                        decoration: const InputDecoration(
                          labelText: 'รหัสบุคลากร',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสบุคลากร';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Name (Autocomplete)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return _mockNames.where((String option) {
                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              _nameController.text = selection;
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted) {
                              
                              // sync internal controller with our _nameController
                              fieldTextEditingController.addListener(() {
                                if (_nameController.text != fieldTextEditingController.text) {
                                  _nameController.text = fieldTextEditingController.text;
                                }
                              });

                              return TextFormField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                decoration: const InputDecoration(
                                  labelText: 'ชื่อ-สกุล (เลือกหรือพิมพ์ใหม่ได้)',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณาระบุชื่อ-สกุล';
                                  }
                                  return null;
                                },
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: constraints.maxWidth,
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        final option = options.elementAt(index);
                                        return ListTile(
                                          title: Text(option),
                                          onTap: () => onSelected(option),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      ),
                      const SizedBox(height: 16),
                      
                      // Department Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: const InputDecoration(
                          labelText: 'หน่วยงานที่สังกัด',
                          prefixIcon: Icon(Icons.work),
                        ),
                        items: _departments.map((String dept) {
                          return DropdownMenuItem<String>(
                            value: dept,
                            child: Text(dept),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDepartment = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาเลือกหน่วยงานที่สังกัด';
                          }
                          return null;
                        },
                      ),
                      
                      // Other Department Input
                      if (_selectedDepartment == 'อื่นๆ') ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _otherDepartmentController,
                          decoration: const InputDecoration(
                            labelText: 'โปรดระบุหน่วยงาน',
                            prefixIcon: Icon(Icons.edit),
                          ),
                          validator: (value) {
                            if (_selectedDepartment == 'อื่นๆ' && (value == null || value.isEmpty)) {
                              return 'กรุณาระบุหน่วยงานของคุณ';
                            }
                            return null;
                          },
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'ลงทะเบียน',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
