import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/app_colors.dart';
import 'package:todo/constants/enums.dart';
import 'package:todo/models/TaskModel.dart';
import 'package:todo/screens/add_edit_task.dart';
import 'package:todo/services/firestore_helper.dart';
import 'package:todo/state/global_state.dart';
import 'package:todo/utils/sizes_helpers.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/spacings.dart';

import '../constants/strings.dart';
import '../state/user_state.dart';
import '../widgets/background.dart';
import '../widgets/custom_expansion_tile.dart';
import '../widgets/list_animator.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = StreamController<String>.broadcast();
    return Consumer<GlobalState>(builder: (context, state, child) {
      Map<String, List<TaskModel>> tasks = {};
      var today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      for (TaskModel task in state.tasks) {
        var date = DateTime(task.date!.toDate().year, task.date!.toDate().month,
            task.date!.toDate().day);

        var title = date.isAfter(today)
            ? Strings.upcomingTasks
            : date.isBefore(today)
                ? Strings.previousTasks
                : Strings.todayTasks;
        tasks.update(title, (list) => list..add(task), ifAbsent: () => [task]);
      }
      final sortedKeys = [
        Strings.todayTasks,
        Strings.upcomingTasks,
        Strings.previousTasks,
      ].where(tasks.containsKey).toList();
      final sortedMap = {for (var k in sortedKeys) k: tasks[k]};

      void openAddEditTask({TaskModel? taskModel}) {
        Navigator.of(context)
            .push(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) {
                  return AddEditTask(
                    task: taskModel,
                  );
                },
                fullscreenDialog: true))
            .then((value) {
          if (value != null) {
            var task = value as TaskModel;
            var date = DateTime(task.date!.toDate().year,
                task.date!.toDate().month, task.date!.toDate().day);
            var title = date.isAfter(today)
                ? Strings.upcomingTasks
                : date.isBefore(today)
                    ? Strings.previousTasks
                    : Strings.todayTasks;
            controller.add(
              title,
            );
          }
        });
      }

      return Background(
        appBar: AppBar(
          title: Text(Strings.appName),
          centerTitle: true,
          leadingWidth: 50,
          leading: Container(
            margin: const EdgeInsets.only(left: 15),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Utils.showConfirmationDialog(
                    title: Strings.logout,
                    message: Strings.areYouLogout,
                    onConfirm: () async {
                      Navigator.pop(context);
                      Provider.of<UserState>(context, listen: false).signOut();
                    },
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: Text(
                  Strings.logout,
                  style: const TextStyle(color: AppColors.white),
                ))
          ],
        ),
        floatingActionButtonIcon: Icons.add,
        floatingActionButtonOnTap: () => openAddEditTask(),
        floatingActionButtonText: Strings.addTask,
        padding: EdgeInsets.zero,
        children: [
          StreamBuilder<String>(
              stream: controller.stream,
              initialData: Strings.todayTasks,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return sortedMap.isEmpty
                    ? SizedBox(
                        width: displayWidth(context),
                        height: displayHeight(context) * 0.85,
                        child: Center(
                            child: Text(
                          Strings.noTasks,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        )))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sortedMap.length,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, i) {
                          var date = sortedMap.keys.elementAt(i);
                          return WidgetAnimator(
                            CustomExpansionWidget(
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.task_alt_outlined,
                                    color: AppColors.primary,
                                  ),
                                  widthSpace(10),
                                  Text(
                                    date,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              content: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    sortedMap.values.elementAt(i)?.length ?? 0,
                                itemBuilder: (context, j) {
                                  var data = sortedMap.values.elementAt(i)![j];
                                  return GestureDetector(
                                    onTap: () =>
                                        openAddEditTask(taskModel: data),
                                    child: Card(
                                      color: Colors.grey.shade200,
                                      child: ListTile(
                                        isThreeLine: true,
                                        minLeadingWidth: 20,
                                        leading: const Icon(
                                          Icons.task,
                                          color: AppColors.accent,
                                        ),
                                        title: Text(
                                          data.name ?? "",
                                          style: const TextStyle(
                                            color: AppColors.accent,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5),
                                            Text(
                                              data.description ?? "",
                                              style: TextStyle(
                                                color: AppColors.accent
                                                    .withOpacity(0.8),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              DateFormat("dd-MMM-yyyy hh:mm a")
                                                  .format(data.date!.toDate()),
                                              style: TextStyle(
                                                color: AppColors.accent
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              child: const Icon(
                                                Icons.edit,
                                                color: AppColors.accent,
                                                size: 20,
                                              ),
                                              onTap: () => openAddEditTask(
                                                  taskModel: data),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              child: const Icon(
                                                Icons.delete,
                                                color: AppColors.accent,
                                                size: 20,
                                              ),
                                              onTap: () {
                                                Utils.showConfirmationDialog(
                                                  title: Strings.deleteTask,
                                                  message: Strings.areYouDelete,
                                                  onConfirm: () async {
                                                    Navigator.pop(context);
                                                    try {
                                                      await FirebaseHelper()
                                                          .deleteTask(data.id!);
                                                      Utils.showToast(
                                                          ToastType.SUCCESS,
                                                          Strings.taskDeleted);
                                                    } catch (e) {
                                                      Utils.showToast(
                                                          ToastType.ERROR,
                                                          Strings
                                                              .somethingWent);
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              isExpand: snapshot.data == date,
                              onExpand: (val) {
                                if (val) {
                                  controller.add(date);
                                }
                              },
                            ),
                          );
                        },
                      );
              })
        ],
      );
    });
  }
}
