import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:staff_management/const_value/controller.dart';
import 'package:staff_management/models/additionHistory.dart';
import 'package:staff_management/models/employee.dart';
import 'package:staff_management/models/quotaHistories.dart';
import 'package:staff_management/models/relative.dart';
import 'package:staff_management/models/workHistory.dart';
import 'package:staff_management/screens/employee/detailScreen/employeeSalary.dart';
import 'package:staff_management/services/employeeRepo.dart';
import 'package:staff_management/services/workHistoryRepo.dart';
import 'package:staff_management/utils/dropdown/dropdownButton.dart';
import 'package:staff_management/utils/expansionTitle/additions/additionExpansionTitle.dart';
import 'package:staff_management/utils/expansionTitle/quotaHistories/quotaHisExpansionTitle.dart';
import 'package:staff_management/utils/expansionTitle/relatives/relativesExpansionTitle.dart';
import 'package:staff_management/utils/expansionTitle/workHistories/workHisExpansionTitle.dart';
import 'package:staff_management/utils/textField/textField.dart';
import 'package:staff_management/utils/textField/datePickerTextField.dart';
import 'package:intl/intl.dart';

class EmployeeDetail extends StatefulWidget {
  Employee employee;

  EmployeeDetail({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _identityCardController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _folkController = TextEditingController();
  final _quotaController = TextEditingController();
  final _positionController = TextEditingController();
  final _unitController = TextEditingController();
  final _sexController = TextEditingController();
  final _salaryController = TextEditingController();
  late RxList<WorkHistory> _workHistory = <WorkHistory>[].obs;
  late RxList<Relative> _relative = <Relative>[].obs;
  late RxList<QuotaHistory> _quotaHistory = <QuotaHistory>[].obs;
  late RxList<AdditionHistory> _additionHistory = <AdditionHistory>[].obs;
  late Employee employeeCopy;
  final WorkHistoryRepo workHistoryRepo = WorkHistoryRepo();
  bool onEdit = false;
  bool ignore = true;

  @override
  void initState() {
    super.initState();
    employeeCopy = Employee.clone(widget.employee);
    _identityCardController.text = "${widget.employee.identityCard}";
    _nameController.text = "${widget.employee.name}";
    _addressController.text = "${widget.employee.address}";
    _birthdateController.text =
        '${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.employee.birthdate.seconds * 1000))}';
    _folkController.text = "${widget.employee.folk}";
    _quotaController.text =
        "${widget.employee.quotaHistory.first.quota.value.name}";
    _positionController.text =
        "${widget.employee.workHistory.first.position.value.name}";
    _unitController.text =
        "${widget.employee.workHistory.first.unit.value.name}";
    _sexController.text = "${widget.employee.sex}";
    _salaryController.text =
        "${widget.employee.getSalaryWithAdditionsToCurrency()}";
    _workHistory = employeeCopy.workHistory;
    _relative = employeeCopy.relative;
    _quotaHistory = employeeCopy.quotaHistory;
    _additionHistory = employeeCopy.additionHistory;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _birthdateController.dispose();
    _identityCardController.dispose();
    _nameController.dispose();
    _folkController.dispose();
    _quotaController.dispose();
    _positionController.dispose();
    _unitController.dispose();
    _sexController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeDevice = MediaQuery.of(context).size;
    final sizeWidth = sizeDevice.width;
    final sizeHeight = sizeDevice.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Employee Detail"),
        actions: [
          IconButton(
              onPressed: () =>
                  Get.to(() => EmployeeSalary(employee: widget.employee)),
              icon: Icon(Icons.bar_chart_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.blue.shade800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: sizeHeight * 0.15,
                      child: ClipOval(
                        child: Container(
                          width: sizeWidth * 0.3,
                          color: Colors.grey.shade400,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: onEdit
                    ? Form(
                        key: _formKey2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 77,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue.shade800),
                                controller: _identityCardController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                keyboardType: TextInputType.phone,
                                validator: (input) {
                                  if (input == null || input.isEmpty)
                                    return "Can't be null";
                                },
                              ),
                            ),
                            Text(" | ", style: TextStyle(fontSize: 15)),
                            Container(
                              width: 90,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue.shade800),
                                controller: _nameController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                keyboardType: TextInputType.name,
                                validator: (input) {
                                  if (input == null || input.isEmpty)
                                    return "Can't be null";
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.employee.identityCard} | ${widget.employee.name}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      controller: _quotaController,
                      icon: Icons.work,
                      hintText: "Quota",
                      onEdit: false,
                      textInputFormatter:
                          FilteringTextInputFormatter.singleLineFormatter,
                      callback: (String _submittedValue) {},
                    ),
                    TextFieldWidget(
                      controller: _positionController,
                      icon: Icons.work_outline_outlined,
                      hintText: "Position",
                      onEdit: false,
                      textInputFormatter:
                          FilteringTextInputFormatter.singleLineFormatter,
                      callback: (String _submittedValue) {},
                    ),
                    TextFieldWidget(
                      controller: _unitController,
                      icon: Icons.home_work,
                      hintText: "Unit",
                      onEdit: false,
                      textInputFormatter:
                          FilteringTextInputFormatter.singleLineFormatter,
                      callback: (String _submittedValue) {},
                    ),
                    TextFieldWidget(
                      controller: _addressController,
                      icon: Icons.place,
                      hintText: "Address",
                      onEdit: onEdit,
                      textInputFormatter:
                          FilteringTextInputFormatter.singleLineFormatter,
                      callback: (String _submittedValue) {},
                    ),
                    DatePickerTextField(
                      labelText: "Birthday",
                      placeholder: "Sep 12, 1998",
                      textEditingController: _birthdateController,
                      editable: onEdit,
                      icon: Icons.cake,
                      callback: (String _newDateString) {},
                    ),
                    TextFieldWidget(
                      controller: _folkController,
                      icon: Icons.short_text,
                      hintText: "Folk",
                      onEdit: onEdit,
                      textInputFormatter:
                          FilteringTextInputFormatter.singleLineFormatter,
                      callback: (String _submittedValue) {},
                    ),
                    !onEdit
                        ? TextFieldWidget(
                            controller: _sexController,
                            icon: Icons.male,
                            hintText: "Gender",
                            onEdit: false,
                            textInputFormatter:
                                FilteringTextInputFormatter.singleLineFormatter,
                            callback: (String _submittedValue) {},
                          )
                        : MyDropdownButton(
                            selectedValue: _sexController.text,
                            values: <String>["Nam", "Nữ"],
                            icon: Icons.male,
                            lable: "Gender",
                            callback: (String _newValue) {
                              _sexController.text = _newValue;
                            },
                            size: Size(sizeWidth, 70),
                          ),
                    TextFieldWidget(
                      controller: _salaryController,
                      icon: Icons.attach_money,
                      hintText: "Current Total Salary",
                      onEdit: false,
                      textInputFormatter:
                          FilteringTextInputFormatter.singleLineFormatter,
                      callback: (String _submittedValue) {},
                    ),
                    RelativesExpansionTitle(
                        relatives: _relative, onAdd: onEdit, onEdit: onEdit),
                    WorkHistoriesExpansionTitle(
                      workHistories: _workHistory,
                      onEdit: onEdit,
                      onAdd: onEdit,
                    ),
                    QuotaHistoriesExpansionTitle(
                      quotaHistories: _quotaHistory,
                      onEdit: onEdit,
                      onAdd: onEdit,
                    ),
                    AdditionsExpansionTitle(
                      additionHistories: _additionHistory,
                      onEdit: onEdit,
                      onAdd: onEdit,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (onEdit == !ignore && onEdit == false) {
                          setState(() {
                            onEdit = !onEdit;
                            ignore = !ignore;
                          });
                        } else {
                          updateEmployee().then((value) {
                            Get.back();
                            final snackBar = SnackBar(
                              duration: Duration(milliseconds: 600),
                              content: Text(
                                "Update employee successful",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      child: Text(onEdit ? "Save changes" : "Edit Employee"),
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

  void updateVariables() {
    employeeCopy.identityCard = _identityCardController.text;
    employeeCopy.name = _nameController.text;
    employeeCopy.address = _addressController.text;
    employeeCopy.birthdate = Timestamp.fromDate(
        DateFormat("dd/MM/yyyy").parse(_birthdateController.text));
    employeeCopy.folk = _folkController.text;
    employeeCopy.sex = _sexController.text;
    employeeCopy.workHistory = _workHistory;
    employeeCopy.relative = _relative;
    employeeCopy.quotaHistory = _quotaHistory;
    employeeCopy.additionHistory = _additionHistory;
  }

  Future<void> updateEmployee() async {
    if (_formKey.currentState!.validate() &&
        _formKey2.currentState!.validate()) {
      updateVariables();
      employeeCopy.calculateSalary();
      await EmployeeRepo()
          .updateEmployee(employeeCopy)
          .then((value) => widget.employee = Employee.clone(employeeCopy));
      await notificationController
          .addUpdateEmployeeNotification(employeeCopy)
          .then((value) => employeeController.retreiveDetailData());
    }
  }
}
