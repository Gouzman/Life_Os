import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/auth_state_provider.dart';
import '../../../../app/providers/history_providers.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../features/tasks/domain/entities/task.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/loaders/app_loader.dart';
import '../providers/history_filter_provider.dart';
import '../widgets/empty_history.dart';
import '../widgets/history_filter_bar.dart';
import '../widgets/history_header.dart';
import '../widgets/history_search_bar.dart';
import '../widgets/history_summary.dart';
import '../widgets/history_timeline.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      loading: () => const AppScaffold(body: AppLoader()),
      error: (e, _) => AppScaffold(body: _ErrorState(message: e.toString())),
      data: (user) {
        if (user == null) return const AppScaffold(body: AppLoader());
        return _HistoryBody(userId: user.id);
      },
    );
  }
}

class _HistoryBody extends ConsumerWidget {
  const _HistoryBody({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(historyFilterProvider);
    final historyAsync = switch (filter) {
      HistoryFilter.today => ref.watch(
        watchHistoryByDayProvider((userId: userId, day: DateTime.now())),
      ),
      HistoryFilter.week => ref.watch(
        watchHistoryByPeriodProvider((
          userId: userId,
          start: _weekStart(),
          end: _weekEnd(),
        )),
      ),
      HistoryFilter.month => ref.watch(
        watchHistoryByPeriodProvider((
          userId: userId,
          start: _monthStart(),
          end: _monthEnd(),
        )),
      ),
      HistoryFilter.custom => ref.watch(watchHistoryProvider(userId)),
    };

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: historyAsync.when(
        loading: () => const AppLoader(),
        error: (e, _) => _ErrorState(message: e.toString()),
        data: (tasks) => tasks.isEmpty
            ? _EmptyLayout(tasks: tasks)
            : _HistoryContent(tasks: tasks),
      ),
    );
  }

  DateTime _weekStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }

  DateTime _weekEnd() => _weekStart().add(const Duration(days: 7));

  DateTime _monthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  DateTime _monthEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1);
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return _TwoColumnLayout(tasks: tasks);
        }
        return _SingleColumnLayout(tasks: tasks);
      },
    );
  }
}

class _SingleColumnLayout extends StatelessWidget {
  const _SingleColumnLayout({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: SingleChildScrollView(
        padding: context.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryHeader(taskCount: tasks.length),
            const SizedBox(height: 20),
            const HistoryFilterBar(),
            const SizedBox(height: 20),
            HistorySummary(tasks: tasks),
            const SizedBox(height: 16),
            const HistorySearchBar(),
            const SizedBox(height: 24),
            HistoryTimeline(tasks: tasks),
          ],
        ),
      ),
    );
  }
}

class _TwoColumnLayout extends StatelessWidget {
  const _TwoColumnLayout({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: SingleChildScrollView(
        padding: context.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryHeader(taskCount: tasks.length),
            const SizedBox(height: 20),
            const HistoryFilterBar(),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      HistorySummary(tasks: tasks),
                      const SizedBox(height: 16),
                      const HistorySearchBar(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: HistoryTimeline(tasks: tasks)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLayout extends StatelessWidget {
  const _EmptyLayout({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: SingleChildScrollView(
        padding: context.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryHeader(taskCount: tasks.length),
            const SizedBox(height: 20),
            const HistoryFilterBar(),
            const SizedBox(height: 16),
            const EmptyHistory(),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
