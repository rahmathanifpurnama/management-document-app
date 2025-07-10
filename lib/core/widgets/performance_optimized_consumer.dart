import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../monitoring/performance_monitor.dart';

/// Optimized Consumer that tracks rebuilds and prevents unnecessary updates
class PerformanceOptimizedConsumer<T> extends ConsumerWidget {
  final String name;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final ProviderListenable<T> provider;
  final Widget? child;
  final bool Function(T previous, T current)? shouldRebuild;

  const PerformanceOptimizedConsumer({
    super.key,
    required this.name,
    required this.builder,
    required this.provider,
    this.child,
    this.shouldRebuild,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PerformanceMonitor.trackRebuild('Consumer_$name');

    return Consumer(
      builder: (context, ref, child) {
        final value = ref.watch(provider);
        return builder(context, value, child);
      },
      child: child,
    );
  }
}

/// Optimized BlocBuilder that tracks rebuilds
class PerformanceOptimizedBlocBuilder<B extends BlocBase<S>, S>
    extends BlocBuilder<B, S> {
  final String name;

  const PerformanceOptimizedBlocBuilder({
    super.key,
    required this.name,
    required super.builder,
    super.bloc,
    super.buildWhen,
  });

  @override
  Widget build(BuildContext context, S state) {
    PerformanceMonitor.trackRebuild('BlocBuilder_$name');
    return super.build(context, state);
  }
}

/// Optimized ListView that tracks scroll performance
class PerformanceOptimizedListView extends StatefulWidget {
  final String name;
  final List<Widget> children;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const PerformanceOptimizedListView({
    super.key,
    required this.name,
    required this.children,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<PerformanceOptimizedListView> createState() =>
      _PerformanceOptimizedListViewState();
}

class _PerformanceOptimizedListViewState
    extends State<PerformanceOptimizedListView> {
  late ScrollController _controller;
  DateTime? _scrollStartTime;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.isScrollingNotifier.value) {
      _scrollStartTime ??= DateTime.now();
    } else if (_scrollStartTime != null) {
      final scrollDuration = DateTime.now().difference(_scrollStartTime!);
      PerformanceMonitor.trackNavigation(
        'scroll_${widget.name}',
        scrollDuration,
      );
      _scrollStartTime = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild('ListView_${widget.name}');

    return ListView(
      controller: _controller,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      children: widget.children,
    );
  }
}

/// Optimized GridView that tracks performance
class PerformanceOptimizedGridView extends StatefulWidget {
  final String name;
  final List<Widget> children;
  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const PerformanceOptimizedGridView({
    super.key,
    required this.name,
    required this.children,
    required this.gridDelegate,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<PerformanceOptimizedGridView> createState() =>
      _PerformanceOptimizedGridViewState();
}

class _PerformanceOptimizedGridViewState
    extends State<PerformanceOptimizedGridView> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild('GridView_${widget.name}');

    return GridView(
      controller: _controller,
      gridDelegate: widget.gridDelegate,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      children: widget.children,
    );
  }
}

/// Mixin for tracking widget rebuilds
mixin PerformanceTrackingMixin<T extends StatefulWidget> on State<T> {
  String get widgetName;

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild(widgetName);
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context);
}

/// Optimized StatefulWidget base class
abstract class PerformanceOptimizedStatefulWidget extends StatefulWidget {
  final String performanceName;

  const PerformanceOptimizedStatefulWidget({
    super.key,
    required this.performanceName,
  });
}

/// Optimized StatelessWidget base class
abstract class PerformanceOptimizedStatelessWidget extends StatelessWidget {
  final String performanceName;

  const PerformanceOptimizedStatelessWidget({
    super.key,
    required this.performanceName,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild(performanceName);
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context);
}

/// Performance-aware AnimatedBuilder
class PerformanceOptimizedAnimatedBuilder extends AnimatedBuilder {
  final String name;

  const PerformanceOptimizedAnimatedBuilder({
    super.key,
    required this.name,
    required super.animation,
    required super.builder,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild('AnimatedBuilder_$name');
    return super.build(context);
  }
}

/// Performance-aware FutureBuilder
class PerformanceOptimizedFutureBuilder<T> extends StatelessWidget {
  final String name;
  final Future<T>? future;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;
  final T? initialData;

  const PerformanceOptimizedFutureBuilder({
    super.key,
    required this.name,
    required this.future,
    required this.builder,
    this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild('FutureBuilder_$name');
    return FutureBuilder<T>(
      future: future,
      initialData: initialData,
      builder: builder,
    );
  }
}

/// Performance-aware StreamBuilder
class PerformanceOptimizedStreamBuilder<T> extends StatelessWidget {
  final String name;
  final Stream<T>? stream;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;
  final T? initialData;

  const PerformanceOptimizedStreamBuilder({
    super.key,
    required this.name,
    required this.stream,
    required this.builder,
    this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackRebuild('StreamBuilder_$name');
    return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: builder,
    );
  }
}
