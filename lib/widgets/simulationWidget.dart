import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduling_simulator/constants/constant.dart';
import 'package:scheduling_simulator/models/process_data.dart';
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
                    // final grantCharts = ref.watch(grantChart);
                    final priority = ref.watch(priorityHighLow);
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
                          int time = 0;
                          int completed = 0;
                          int n = listProcess.length;
                          List<int> remBt = listProcess
                              .map((p) => p.bt)
                              .toList();
                          List<bool> started = List.filled(n, false);
                          List<ProcessData> grant = [];

                          while (completed < n) {
                            int idx = -1;
                            int minRem = 1 << 30;
                            for (int i = 0; i < n; i++) {
                              if (listProcess[i].at <= time &&
                                  remBt[i] > 0 &&
                                  remBt[i] < minRem) {
                                minRem = remBt[i];
                                idx = i;
                              }
                            }
                            if (idx == -1) {
                              time++;
                              continue;
                            }
                            if (!started[idx]) {
                              listProcess[idx].st = time;
                              started[idx] = true;
                            }
                            remBt[idx]--;
                            time++;
                            if (remBt[idx] == 0) {
                              listProcess[idx].ct = time;
                              listProcess[idx].setOtherTimes();
                              listProcess[idx].finished = true;
                              completed++;
                              grant.add(listProcess[idx]);
                            }
                          }
                          ref.read(grantChart.notifier).state = [...grant];
                        } else if (algoProvider == "RR") {
                          int time = 0;
                          int completed = 0;
                          final quantumProvider = ref.watch(
                            timeQuantumController,
                          );
                          int quantum = int.tryParse(quantumProvider.text) ?? 1;
                          List<int> remBt = listProcess
                              .map((p) => p.bt)
                              .toList();
                          List<ProcessData> grant = [];
                          List<bool> visited = List.filled(
                            listProcess.length,
                            false,
                          );
                          List<int> readyQueue = [];
                          while (completed < listProcess.length) {
                            for (int i = 0; i < listProcess.length; i++) {
                              if (listProcess[i].at <= time &&
                                  !visited[i] &&
                                  remBt[i] > 0) {
                                readyQueue.add(i);
                                visited[i] = true;
                              }
                            }
                            if (readyQueue.isEmpty) {
                              time++;
                              continue;
                            }
                            int idx = readyQueue.removeAt(0);
                            var proc = listProcess[idx];
                            if (remBt[idx] == proc.bt) {
                              proc.st = time;
                            }
                            int execTime = remBt[idx] > quantum
                                ? quantum
                                : remBt[idx];
                            time += execTime;
                            remBt[idx] -= execTime;
                            for (int i = 0; i < listProcess.length; i++) {
                              if (listProcess[i].at > proc.at &&
                                  listProcess[i].at <= time &&
                                  !visited[i] &&
                                  remBt[i] > 0) {
                                readyQueue.add(i);
                                visited[i] = true;
                              }
                            }
                            if (remBt[idx] == 0) {
                              proc.ct = time;
                              proc.setOtherTimes();
                              proc.finished = true;
                              completed++;
                              final comProc=proc.copyWith(end: time);
                              grant.add(comProc);
                            } else {
                              readyQueue.add(idx);
                            }
                          }
                          ref.read(grantChart.notifier).state = [...grant];
                        } else if (algoProvider == "PQ") {
                          int time = 0;
                          int count = 0;
                          List<ProcessData> grant = [];
                          while (count < listProcess.length) {
                            var smallest = -1;
                            for (var i = 0; i < listProcess.length; i++) {
                              var current = listProcess[i];
                              if (current.at <= time && !current.finished) {
                                bool compare = priority
                                    ? (current.pq!) > listProcess[smallest].pq!
                                    : (current.pq!) < listProcess[smallest].pq!;
                                if (smallest == -1 || compare) {
                                  smallest = i;
                                }
                              }
                            }
                            if (smallest == -1) {
                              time++;
                              continue;
                            }
                            // print(listProcess[smallest].toString());
                            time += listProcess[smallest].bt;
                            listProcess[smallest].ct = time;
                            listProcess[smallest].setOtherTimes();
                            listProcess[smallest].finished = true;
                            count++;
                            final current = listProcess[smallest];
                            grant.add(current);
                            // print(current.toString());
                          }
                          ref.read(grantChart.notifier).state = [...grant];
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
