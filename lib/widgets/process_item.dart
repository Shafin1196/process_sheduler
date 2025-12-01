import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduling_simulator/constants/constant.dart';
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
                  Text(
                    "Process ID:  P (${currentItem.id})",
                    style: GoogleFonts.dancingScript(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final algoProvider = ref.watch(selectedAlgorithm);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Burst Time:  ${currentItem.bt} sec",
                        style: GoogleFonts.dancingScript(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Arival Time:  ${currentItem.at} sec",
                        style: GoogleFonts.dancingScript(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      algoProvider == "PQ"
                          ? Spacer():SizedBox.shrink(),
                      algoProvider == "PQ"
                          ? Text(
                              "Priority:  ${currentItem.pq} sec",
                              style: GoogleFonts.dancingScript(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
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
