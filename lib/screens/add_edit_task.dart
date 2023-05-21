import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/enums.dart';
import 'package:todo/models/TaskModel.dart';
import 'package:todo/services/firestore_helper.dart';
import 'package:todo/utils/sizes_helpers.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/spacings.dart';

import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../state/user_state.dart';
import '../widgets/background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddEditTask extends StatefulWidget {
  const AddEditTask({Key? key, this.task}) : super(key: key);
  final TaskModel? task;

  @override
  AddTaskState createState() {
    return AddTaskState();
  }
}

class AddTaskState extends State<AddEditTask> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _date = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  final _db = FirebaseHelper();

  TaskModel? _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _name.text = _task?.name ?? "";
    _desc.text = _task?.description ?? "";
    if (_task != null && _task!.date != null) {
      _selectedDate = _task!.date!.toDate();
      _date.text = DateFormat("dd-MMM-yyyy hh:mm a").format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var me = Provider.of<UserState>(context, listen: false).appUser!;
    return Background(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
            "${_task != null ? Strings.edit : Strings.add} ${Strings.task.toLowerCase()}"),
        centerTitle: true,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        heightSpace(displayHeight(context) *0.1),
        CustomTextFiled(
          textColor: Colors.white,
          controller: _name,
          labelText: Strings.name,
          keyboardType: TextInputType.name,
        ),
        heightSpace(15),
        CustomTextFiled(
          textColor: Colors.white,
          controller: _desc,
          labelText: Strings.desc,
          keyboardType: TextInputType.text,
          maxLines: 5,
        ),
        heightSpace(15),
        CustomTextFiled(
          textColor: Colors.white,
          onTap: () async {
            _selectedDate = await Utils.showDateTimePicker(context,
                initialDate: _selectedDate);
            if (_selectedDate != null) {
              _date.text =
                  DateFormat("dd-MMM-yyyy hh:mm a").format(_selectedDate!);
              setState(() {});
            }
          },
          controller: _date,
          labelText: Strings.date,
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
          suffixIcon: const Icon(Icons.date_range_rounded),
        ),
        heightSpace(25),
        CustomButton(
          buttonText: Strings.save,
          onTap: () async {
            if (_name.text.isEmpty) {
              Utils.showToast(ToastType.ERROR, Strings.enterName);
              return;
            }

            if (_desc.text.isEmpty) {
              Utils.showToast(ToastType.ERROR, Strings.enterDesc);
              return;
            }

            if (_date.text.isEmpty) {
              Utils.showToast(ToastType.ERROR, Strings.selectDate);
              return;
            }

            var task = _task ?? TaskModel();
            task.name = _name.text;
            task.description = _desc.text;
            task.date = Timestamp.fromDate(_selectedDate!);
            task.createdBy = me.id;
            try {
              if (_task == null) {
                task.createdAt = Timestamp.now();
                await _db.addTask(task);
                Utils.showToast(ToastType.SUCCESS, Strings.taskAdded);
              } else {
                task.updatedAt = Timestamp.now();
                await _db.updateTask(task);
                Utils.showToast(ToastType.SUCCESS, Strings.taskUpdated);
              }

              Navigator.of(context).pop(task);
            } catch (e) {
              Utils.showToast(ToastType.ERROR, Strings.somethingWent);
            }
          },
        ),
      ],
    );
  }
}
