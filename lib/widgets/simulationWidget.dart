import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduling_simulator/constants/constant.dart';
import 'package:scheduling_simulator/providers/constant_provider.dart';
import 'package:scheduling_simulator/widgets/simulate_data.dart';

class Simulates extends ConsumerStatefulWidget {
  const Simulates({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SimulatesState();
}

class _SimulatesState extends ConsumerState<Simulates> {
  @override
  Widget build(BuildContext context) {
    var height = ref.watch(screenHeight(context));
    var width = ref.watch(screenWidth(context));
    return Expanded(
      flex: 1,
      child: Container(
        height: height * 0.8,
        width: width * .5,
        margin: EdgeInsets.all(height * width * 0.00002),
        padding: EdgeInsets.all(height * width * 0.00002),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final algoProvider = ref.watch(selectedAlgorithm);
            final algo = algoProvider == "FCFS"
                ? fcfs
                : algoProvider == "SJF"
                ? sjf
                : algoProvider == "SRTF"
                ? srtf
                : algoProvider == "RR"
                ? rr
                : prio;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  algo,
                  style: GoogleFonts.dancingScript(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Divider(thickness: 3, radius: BorderRadius.circular(5)),
                SizedBox(height: 10),
                Expanded(flex: 4, child: SimulateData()),
                SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    final flag = ref.watch(generateFlag);
                    final listProcess = ref.watch(processLists);
                    return ElevatedButton(
                      onPressed: () {
                        if (algoProvider == "FCFS") {
                          int time = 0;
                          listProcess.sort((a, b) => a.at.compareTo(b.at));
                          for (var i = 0; i < listProcess.length; i++) {
                            if (i == 0 || time < listProcess[i].at) {
                              time += (listProcess[i].at - time);
                            }
                            listProcess[i].st = time;
                            time += listProcess[i].bt;
                            listProcess[i].ct = time;
                            listProcess[i].setOtherTimes();
                          }
                          ref.read(grantChart.notifier).state = [
                            ...listProcess,
                          ];
                          listProcess.sort((a, b) => a.id.compareTo(b.id));
                        } else if (algoProvider == "SJF") {
                          int time = 0;
                          List finished = List.filled(
                            listProcess.length,
                            false,
                          );
                          int completed = 0;
                          while (completed < listProcess.length) {
                            int idx = -1;
                            int minBt = 1 << 30;
                            for (int i = 0; i < listProcess.length; i++) {
                              if (!finished[i] &&
                                  listProcess[i].at <= time &&
                                  listProcess[i].bt < minBt) {
                                minBt = listProcess[i].bt;
                                idx = i;
                              }
                            }
                            if (idx == -1) {
                              time++;
                              continue;
                            }
                            listProcess[idx].st = time;
                            time += listProcess[idx].bt;
                            listProcess[idx].ct = time;
                            listProcess[idx].setOtherTimes();
                            finished[idx] = true;
                            completed++;
                          }
                          ref.read(grantChart.notifier).state = [
                            ...listProcess,
                          ];
                          listProcess.sort((a, b) => a.id.compareTo(b.id));
                        } else if (algoProvider == "SRTF") {
                          
                        } else if (algoProvider == "RR") {
                          
                        } else if (algoProvider == "PQ") {
                          
                        }
                        ref.read(generateFlag.notifier).state = !flag;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: borderColor.withOpacity(1),
                        elevation: 7,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Generate",
                        style: GoogleFonts.dancingScript(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
