import 'package:fitness_tracker_app/providers/quote/quote_provider.dart';
import 'package:fitness_tracker_app/providers/workout/workout_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/workout_type.dart';
import '../widgets/workout_calendar_graph.dart';
import '../widgets/workout_form_dialog.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final loader = CupertinoActivityIndicator(radius: 20,);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const SizedBox.shrink(),
          toolbarHeight: 200,
          flexibleSpace: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 56.0, left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final quote = ref.watch(getQuotesProvider);
                        return quote.map(
                          data: (data) {
                            return Column(
                              children: [
                                Center(
                                    child: Text(
                                  '" ${data.value.quote} "',
                                  // maxLines: 2,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15),
                                )),
                                Center(
                                    child: Text(
                                  '- ${data.value.author}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13),
                                ))
                              ],
                            );
                          },
                          error: (error) {
                            return Text("Failed to load quote");
                          },
                          loading: (_) {
                            return loader;
                          },
                        );
                      },
                    ),
                    Spacer(),
                    WorkoutCalendarGraph(),
                  ],
                ),
              ),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: TabBar(
              tabs: [
                Tab(text: 'Upper Body'),
                Tab(text: 'Lower Body'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _WorkoutList(type: WorkoutType.upperBody),
            _WorkoutList(type: WorkoutType.lowerBody),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () => _refreshWorkouts(ref, context),
              child: const Icon(Icons.refresh),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () => _fetchQuote(ref, context),
              child: const Icon(Icons.format_quote),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () => _showAddWorkoutDialog(context),
              child: const Icon(Icons.add),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  void _showAddWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const WorkoutFormDialog(),
    );
  }

  void _refreshWorkouts(WidgetRef ref, context) {
    ref.read(workoutProvider.notifier).clearCompletedWorkouts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Center(
            child: Text(
          "Refreshed workouts",
          style: TextStyle(color: Colors.white),
        )),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.3),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _fetchQuote(WidgetRef ref, context) async{
    final _ = ref.refresh(getQuotesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Center(
            child: Text(
          "Fetching new quote...",
          style: TextStyle(color: Colors.white),
        )),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.3),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _WorkoutList extends ConsumerWidget {
  final WorkoutType type;

  const _WorkoutList({required this.type});

  @override
  Widget build(BuildContext context, ref) {
    final rawWorkouts = ref.watch(workoutProvider);
    final workouts = rawWorkouts.where((w) => w.type == type).toList();
    if (workouts.isEmpty) {
      return Center(
        child: Text("No workouts yet."),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Card(
          child: ListTile(
            enabled: false,
            title: Text(
              workout.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: workout.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: workout.isCompleted ? Colors.grey : Colors.white,
              ),
            ),
            subtitle: Text(
              workout.sets > 0
                  ? "${workout.sets} sets x ${workout.reps} reps @ ${workout.weight} kg"
                  : "No sets added",
              style: TextStyle(
                decoration: workout.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontWeight: FontWeight.w500,
                color: workout.isCompleted ? Colors.grey : Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: workout.isCompleted,
                    onChanged: (_) {
                      ref
                          .read(workoutProvider.notifier)
                          .toggleWorkoutStatus(workout.id);
                    }),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(workoutProvider.notifier)
                          .removeWorkout(workout.id);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
