import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestState();
}

class _TestState extends ConsumerState<Test> {
   final ScrollController _scrollController = ScrollController();
  List<String> list = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '7',
    '8',
    '9',
    '9',
    '10',
    '11',
    '12',
    'a',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.amber,
        child: SizedBox(
          height: 80,
          child: Listener(
            onPointerSignal: (ps) {
              if (ps is PointerScrollEvent) {
                _scrollController.jumpTo(
                  _scrollController.offset + ps.scrollDelta.dy,
                );
              }
            },
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final cu = list[index];
                  return Container(width: 100, child: ListTile(title: Text(cu)));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
