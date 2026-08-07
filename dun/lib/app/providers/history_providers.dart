import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/features/history/domain/usecases/watch_cancelled_tasks.dart';
import 'package:dun/features/history/domain/usecases/watch_completed_tasks.dart';
import 'package:dun/features/history/domain/usecases/watch_history.dart';
import 'package:dun/features/history/domain/usecases/watch_history_by_day.dart';
import 'package:dun/features/history/domain/usecases/watch_history_by_period.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _watchHistoryUseCaseProvider = Provider<WatchHistory>(
  (ref) => WatchHistory(ref.read(historyRepositoryProvider)),
);

final _watchCompletedTasksUseCaseProvider = Provider<WatchCompletedTasks>(
  (ref) => WatchCompletedTasks(ref.read(historyRepositoryProvider)),
);

final _watchCancelledTasksUseCaseProvider = Provider<WatchCancelledTasks>(
  (ref) => WatchCancelledTasks(ref.read(historyRepositoryProvider)),
);

final _watchHistoryByDayUseCaseProvider = Provider<WatchHistoryByDay>(
  (ref) => WatchHistoryByDay(ref.read(historyRepositoryProvider)),
);

final _watchHistoryByPeriodUseCaseProvider = Provider<WatchHistoryByPeriod>(
  (ref) => WatchHistoryByPeriod(ref.read(historyRepositoryProvider)),
);

final watchHistoryProvider = StreamProvider.autoDispose
    .family<List<Task>, String>((ref, userId) {
      return ref
          .read(_watchHistoryUseCaseProvider)
          .call(WatchHistoryParams(userId: userId));
    });

final watchCompletedTasksProvider = StreamProvider.autoDispose
    .family<List<Task>, String>((ref, userId) {
      return ref
          .read(_watchCompletedTasksUseCaseProvider)
          .call(WatchCompletedTasksParams(userId: userId));
    });

final watchCancelledTasksProvider = StreamProvider.autoDispose
    .family<List<Task>, String>((ref, userId) {
      return ref
          .read(_watchCancelledTasksUseCaseProvider)
          .call(WatchCancelledTasksParams(userId: userId));
    });

final watchHistoryByDayProvider = StreamProvider.autoDispose
    .family<List<Task>, ({String userId, DateTime day})>((ref, params) {
      return ref
          .read(_watchHistoryByDayUseCaseProvider)
          .call(
            WatchHistoryByDayParams(userId: params.userId, day: params.day),
          );
    });

final watchHistoryByPeriodProvider = StreamProvider.autoDispose
    .family<List<Task>, ({String userId, DateTime start, DateTime end})>(
      (ref, params) => ref
          .read(_watchHistoryByPeriodUseCaseProvider)
          .call(
            WatchHistoryByPeriodParams(
              userId: params.userId,
              start: params.start,
              end: params.end,
            ),
          ),
    );
