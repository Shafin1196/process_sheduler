import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling_simulator/widgets/inputWidget.dart';
import 'package:scheduling_simulator/widgets/selection.dart';
import 'package:scheduling_simulator/widgets/simulationWidget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex:8,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Input(),
                    Simulates(),
                  ],
                ),
              ),
              Selection(),
            ],
          ),
      ),
     
    );
  }
}
