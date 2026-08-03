import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun/core/errors/exceptions.dart';
import 'package:dun/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:dun/features/tasks/data/models/task_model.dart';

class FirestoreTaskDataSource implements TaskRemoteDataSource {
  FirestoreTaskDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('tasks');

  Query<Map<String, dynamic>> _userTasksQuery(String userId) =>
      _tasksCollection.where('userId', isEqualTo: userId);

  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    return _userTasksQuery(userId)
        .orderBy('scheduledAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromJson(doc.data()))
              .toList(),
        )
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<TaskModel?> watchTask(String taskId) {
    return _tasksCollection
        .doc(taskId)
        .snapshots()
        .map(
          (doc) => doc.exists && doc.data() != null
              ? TaskModel.fromJson(doc.data()!)
              : null,
        )
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchPendingTasks(String userId) {
    return _userTasksQuery(userId)
        .where('status', isEqualTo: 'pending')
        .where('archived', isEqualTo: false)
        .orderBy('scheduledAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromJson(doc.data()))
              .toList(),
        )
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchTasksForDay(String userId, DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    return _userTasksQuery(userId)
        .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('scheduledAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('scheduledAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromJson(doc.data()))
              .toList(),
        )
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Stream<List<TaskModel>> watchTasksByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return _userTasksQuery(userId)
        .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('scheduledAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('scheduledAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromJson(doc.data()))
              .toList(),
        )
        .handleError((Object e) => throw ServerException(e.toString()));
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists || doc.data() == null) return null;
      return TaskModel.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).set(task.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).update(task.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
