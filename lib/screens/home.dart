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

import '../constants/assets.dart';
import '../constants/strings.dart';
import '../state/user_state.dart';
import '../widgets/flex_app_bar_title.dart';
import '../widgets/background.dart';
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
        backgroundColor: Colors.white,
        floatingActionButtonIcon: Icons.add,
        floatingActionButtonOnTap: () => openAddEditTask(),
        floatingActionButtonText: Strings.addTask,
        padding: EdgeInsets.zero,
        body: StreamBuilder<String>(
            stream: controller.stream,
            initialData: Strings.todayTasks,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    primary: true,
                    pinned: true,
                    title: FlexAppBarTitle(child: Text(Strings.appName)),
                    centerTitle: true,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Utils.showConfirmationDialog(
                            title: Strings.logout,
                            message: Strings.areYouLogout,
                            onConfirm: () async {
                              Navigator.pop(context);
                              Provider.of<UserState>(context, listen: false)
                                  .signOut();
                            },
                          );
                        },
                        child: const Icon(Icons.logout_outlined),
                      )
                    ],
                    expandedHeight: 250,
                    leadingWidth: 50,
                    backgroundColor: AppColors.background,
                    leading: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 25,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      title: FlexAppBarTitle(
                          isTitle: false,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 169,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 3.0,
                                          color: Colors.lightBlue.shade900),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  // width: displayWidth(context) * 0.36,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("${Strings.appName}\nApp",
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: AppColors.white)),
                                      heightSpace(30),
                                      Text(
                                        DateFormat("MMM, dd yyyy")
                                            .format(DateTime.now()),
                                        style: const TextStyle(fontSize: 8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(15),
                                color: const Color(0x33000000),
                                width: displayWidth(context) * 0.3,
                                height: 170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Total Tasks",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      state.tasks.length.toString(),
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      // centerTitle: true,
                      background: Image.asset(
                        Assets.background,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
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
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    color: Colors.grey,
                                    thickness: 0.5,
                                    height: 0.5, // C
                                  );
                                },
                                itemCount: sortedMap.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                itemBuilder: (context, i) {
                                  var date = sortedMap.keys.elementAt(i);
                                  return WidgetAnimator(Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      heightSpace(10),
                                      Text(
                                        date,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                      heightSpace(5),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: sortedMap.values
                                                .elementAt(i)
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, j) {
                                          var data =
                                              sortedMap.values.elementAt(i)![j];
                                          return GestureDetector(
                                            onTap: () => openAddEditTask(
                                                taskModel: data),
                                            child: ListTile(
                                              isThreeLine: true,
                                              minLeadingWidth: 20,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              leading: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .greyLight)),
                                                child: const Icon(
                                                  Icons.task,
                                                  color: AppColors.buttonBlue,
                                                ),
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
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    DateFormat(
                                                            "dd-MMM-yyyy hh:mm a")
                                                        .format(data.date!
                                                            .toDate()),
                                                    style: TextStyle(
                                                      color: AppColors.accent
                                                          .withOpacity(0.6),
                                                      fontSize: 11,
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
                                                      color:
                                                          AppColors.buttonBlue,
                                                      size: 18,
                                                    ),
                                                    onTap: () =>
                                                        openAddEditTask(
                                                            taskModel: data),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color:
                                                          AppColors.buttonBlue,
                                                      size: 18,
                                                    ),
                                                    onTap: () {
                                                      Utils
                                                          .showConfirmationDialog(
                                                        title:
                                                            Strings.deleteTask,
                                                        message: Strings
                                                            .areYouDelete,
                                                        onConfirm: () async {
                                                          Navigator.pop(
                                                              context);
                                                          try {
                                                            await FirebaseHelper()
                                                                .deleteTask(
                                                                    data.id!);
                                                            Utils.showToast(
                                                                ToastType
                                                                    .SUCCESS,
                                                                Strings
                                                                    .taskDeleted);
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
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const Divider(
                                            color: Colors.grey,
                                            thickness: 0.5,
                                            height:
                                                0.5, // Customize the height of the divider here
                                          );
                                        },
                                      )
                                    ],
                                  ));
                                },
                              );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              );
            }),
      );
    });
  }
}
