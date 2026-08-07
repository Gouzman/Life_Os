import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun/core/errors/exceptions.dart';
import 'package:dun/features/history/data/datasources/history_remote_datasource.dart';
import 'package:dun/features/tasks/data/models/task_model.dart';

class FirestoreHistoryDatasource implements HistoryRemoteDatasource {
  FirestoreHistoryDatasource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('tasks');

  Query<Map<String, dynamic>> _userTasksQuery(String userId) =>
      _tasksCollection.where('userId', isEqualTo: userId);

  List<TaskModel> _mapSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) =>
      snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();

  @override
  Stream<List<TaskModel>> watchHistory(String userId) {
    return _userTasksQuery(userId)
        .where('status', whereIn: const ['completed', 'cancelled'])
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map(_mapSnapshot)
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchCompletedTasks(String userId) {
    return _userTasksQuery(userId)
        .where('status', isEqualTo: 'completed')
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(_mapSnapshot)
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchCancelledTasks(String userId) {
    return _userTasksQuery(userId)
        .where('status', isEqualTo: 'cancelled')
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map(_mapSnapshot)
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchHistoryByDay(String userId, DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return _userTasksQuery(userId)
        .where('status', whereIn: const ['completed', 'cancelled'])
        .where(
          'scheduledAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
        )
        .where('scheduledAt', isLessThan: Timestamp.fromDate(dayEnd))
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map(_mapSnapshot)
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchHistoryByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return _userTasksQuery(userId)
        .where('status', whereIn: const ['completed', 'cancelled'])
        .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('scheduledAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map(_mapSnapshot)
        .handleError((Object e) => throw ServerException(e.toString()));
  }
}
