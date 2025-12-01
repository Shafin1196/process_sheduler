
import 'package:flutter/material.dart';
import 'package:riverpod/legacy.dart';
import 'package:scheduling_simulator/models/process_data.dart';

final screenHeight=StateProvider.family<double,BuildContext>(
  (ref,context)=>MediaQuery.of(context).size.height
);
final screenWidth=StateProvider.family<double,BuildContext>(
  (ref,context)=>MediaQuery.of(context).size.width
);
final selectedAlgorithm=StateProvider<String>((ref)=>"FCFS");
final arivalTimeController=StateProvider<TextEditingController>((ref)=>TextEditingController());
final burstTimeController=StateProvider<TextEditingController>((ref)=>TextEditingController());
final timeQuantumController=StateProvider<TextEditingController>((ref)=>TextEditingController());
final priorityController=StateProvider<TextEditingController>((ref)=>TextEditingController());
final priorityHighLow=StateProvider<bool>((ref)=>false);
final processLists=StateProvider<List<ProcessData>>((ref)=>[]);
final generateFlag=StateProvider<bool>((ref)=>false);
final grantChart=StateProvider<List<ProcessData>>((ref)=>[]);
