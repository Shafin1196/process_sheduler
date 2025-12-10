import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling_simulator/constants/constant.dart';
import 'package:scheduling_simulator/constants/methods.dart';
import 'package:scheduling_simulator/models/process_data.dart';
import 'package:scheduling_simulator/providers/constant_provider.dart';

class ProcessItem extends ConsumerWidget {
  const ProcessItem({super.key, required this.currentItem});
  final ProcessData currentItem;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.only(bottom: 7, left: 10, right: 10, top: 5),
      elevation: 5,
      shadowColor: textColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      child: SizedBox(
        height: 70,
        width: 200,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text("Process ID:  P${currentItem.id}", white, 15,fontWeight: FontWeight.bold),
                ],
              ),
              Spacer(),
              Consumer(
                builder: (context, ref, child) {
                  final algoProvider = ref.watch(selectedAlgorithm);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       text("Arival Time:  ${currentItem.at} sec", white, 12,fontWeight: FontWeight.bold),
                      Spacer(),
                      text("Burst Time:  ${currentItem.bt} sec", white, 12,fontWeight: FontWeight.bold),
                      
                     
                      algoProvider == "PQ"
                          ? Spacer():SizedBox.shrink(),
                      algoProvider == "PQ"
                          ? text("Priority:  ${currentItem.pq} ", white, 12,fontWeight: FontWeight.bold)
                          : SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
