import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiListViewRefreshable<T> extends StatefulWidget {
  const ApiListViewRefreshable({
    required this.url,
    this.apiCaller,
    required this.convertor,
    required this.itemBuilder,
    this.responseConvertor,
    this.seperatorBuilder,
    Key? key,
  }) : super(key: key);

  final String url;
  final Dio? apiCaller;
  final T Function(Map<String, dynamic> json) convertor;

  /// Use this if you want to modify the Response data before it gets passed to the convertor function
  final List<dynamic> Function(Map<String, dynamic> json)? responseConvertor;
  final Widget Function(BuildContext context, T apiItem) itemBuilder;
  final Widget Function(BuildContext, int)? seperatorBuilder;

  @override
  State<ApiListViewRefreshable<T>> createState() => _ApiListViewRefreshableState<T>();
}

class _ApiListViewRefreshableState<T> extends State<ApiListViewRefreshable<T>> {
  final GlobalKey<ApiListViewState<T>> apiKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await apiKey.currentState!.getApiData(),
      child: ApiListView(
        key: apiKey,
        url: widget.url,
        convertor: widget.convertor,
        itemBuilder: widget.itemBuilder,
        apiCaller: widget.apiCaller,
        responseConvertor: widget.responseConvertor,
        seperatorBuilder: widget.seperatorBuilder,
      ),
    );
  }
}

class ApiListView<T> extends StatefulWidget {
  const ApiListView({
    required this.url,
    this.apiCaller,
    required this.convertor,
    required this.itemBuilder,
    this.responseConvertor,
    this.seperatorBuilder,
    Key? key,
  }) : super(key: key);

  final String url;
  final Dio? apiCaller;
  final T Function(Map<String, dynamic> json) convertor;

  /// Use this if you want to modify the Response data before it gets passed to the convertor function
  final List<dynamic> Function(Map<String, dynamic> json)? responseConvertor;
  final Widget Function(BuildContext context, T apiItem) itemBuilder;
  final Widget Function(BuildContext, int)? seperatorBuilder;

  @override
  State<ApiListView<T>> createState() => ApiListViewState<T>();
}

class ApiListViewState<E> extends State<ApiListView<E>> {
  List<E>? apiData;
  String? error;

  @override
  void initState() {
    getApiData();
    super.initState();
  }

  Future getApiData() async {
    Dio dio = widget.apiCaller ?? Dio();
    try {
      error = null;
      apiData = null;
      if (mounted) {
        setState(() {});
      }
      Response response = await dio.get(widget.url);
      if (widget.responseConvertor != null) {
        apiData = List.from(widget.responseConvertor!(response.data))
            .map((e) => widget.convertor(e))
            .toList();
      } else {
        apiData = List.from(response.data).map((e) => widget.convertor(e)).toList();
      }
    } on DioError catch (e) {
      error = e.message;
    } catch (e) {
      error = e.toString();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Builder(
        builder: (context) {
          if (error != null) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(error!),
              ),
            );
          } else if (apiData == null) {
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          } else if (apiData!.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(100.0),
                child: Text(
                  "No data available",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, i) {
                return widget.itemBuilder.call(context, apiData![i]);
              },
              separatorBuilder:
                  widget.seperatorBuilder ?? ((context, _) => const SizedBox(height: 0)),
              itemCount: apiData!.length,
            );
          }
        },
      ),
    );
  }
}

class ApiScrollView<T> extends StatefulWidget {
  const ApiScrollView({
    required this.url,
    this.apiCaller,
    required this.convertor,
    required this.itemBuilder,
    this.seperatorBuilder,
    Key? key,
  }) : super(key: key);

  final String url;
  final Dio? apiCaller;
  final T Function(Map<String, dynamic> json) convertor;
  final Widget Function(BuildContext context, T apiItem) itemBuilder;
  final Widget Function(BuildContext, int)? seperatorBuilder;

  @override
  State<ApiScrollView<T>> createState() => ApiScrollViewState<T>();
}

class ApiScrollViewState<E> extends State<ApiScrollView<E>> {
  List<E>? apiData;
  String? error;

  @override
  void initState() {
    getApiData();
    super.initState();
  }

  Future getApiData() async {
    Dio dio = widget.apiCaller ?? Dio();
    try {
      error = null;
      apiData = null;
      Response response = await dio.get(widget.url);
      // apiData = List.from(response.data);
      apiData = List.from(response.data).map((e) => widget.convertor(e)).toList();
    } on DioError catch (e) {
      error = e.message;
    } catch (e) {
      error = e.toString();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Builder(
        builder: (context) {
          if (error != null) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(error!),
              ),
            );
          } else if (apiData == null) {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            );
          } else if (apiData!.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(100.0),
                child: Text(
                  "No data available",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children:
                    apiData!.map((apiItem) => widget.itemBuilder.call(context, apiItem)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
