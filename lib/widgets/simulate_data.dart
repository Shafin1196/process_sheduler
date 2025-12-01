import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduling_simulator/constants/constant.dart';
import 'package:scheduling_simulator/providers/constant_provider.dart';

class SimulateData extends ConsumerStatefulWidget {
  const SimulateData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SimulateDataState();
}

class _SimulateDataState extends ConsumerState<SimulateData> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, chidl) {
        final falg = ref.watch(generateFlag);
        final listProcess = ref.watch(processLists);
        final algoSelected = ref.watch(selectedAlgorithm);
        return Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: !falg || listProcess.isEmpty
              ? Center(
                  child: Text(
                    "Click on generate or add process!",
                    style: GoogleFonts.dancingScript(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Text(
                        "Process Table",
                        style: GoogleFonts.dancingScript(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Card(
                        color: cardColor,
                        child: DataTable(
                          columnSpacing: 20,
                          border: TableBorder(),
                          headingTextStyle: GoogleFonts.dancingScript(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          dataTextStyle: GoogleFonts.dancingScript(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          columns: [
                            col("PID"),
                            col("AT"),
                            col("BT"),
                            if (algoSelected == "PQ") col('PQ'),
                            col("CT"),
                            col("TAT"),
                            col("WT"),
                            col("RT"),
                          ],
                          rows: listProcess
                              .map(
                                (p) => DataRow(
                                  cells: [
                                    DataCell(Text("P(${p.id})")),
                                    DataCell(Text(p.at.toString())),
                                    DataCell(Text(p.bt.toString())),
                                    if (algoSelected == "PQ")
                                      DataCell(Text(p.pq.toString())),
                                    DataCell(Text(p.ct.toString())),
                                    DataCell(Text(p.tat.toString())),
                                    DataCell(Text(p.wt.toString())),
                                    DataCell(Text(p.rt.toString())),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Grant Chart",
                        style: GoogleFonts.dancingScript(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 5),
                      Consumer(
                        builder: (context, ref, child) {
                          final grantList = ref.watch(grantChart);
                          return Container(
                            height: 70,
                            
                            child: SizedBox(
                              width: 380,
                              child: Listener(
                                onPointerSignal: (ps) {
                                  if (ps is PointerScrollEvent) {
                                    _scrollController.jumpTo(
                                      _scrollController.offset +
                                          ps.scrollDelta.dy,
                                    );
                                  }
                                },
                                child: ScrollbarTheme(
                                  data: ScrollbarThemeData(
                                    thumbColor: MaterialStateProperty.all(borderColor),
                                    
                                  ),
                                  child: Scrollbar(
                                    controller: _scrollController,
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: grantList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final current = grantList[index];
                                        return Container(
                                          width: 100,
                                          margin: EdgeInsets.only(right: 5,bottom: 12),
                                          
                                          decoration: BoxDecoration(
                                            color: selectedColor.withOpacity(1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "P(${current.id})\n${current.st}-${current.ct}",
                                              style: GoogleFonts.dancingScript(
                                                color: white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      Consumer(
                        builder: (context, ref, child) {
                          final listProcess = ref.watch(processLists);
                          var tatSum = 0, wtSum = 0;
                          for (var process in listProcess) {
                            tatSum += process.tat;
                            wtSum += process.wt;
                          }
                          var tatAvg = tatSum / listProcess.length;
                          var wtAvg = wtSum / listProcess.length;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Avg. Trun Around Time: ${tatAvg.toStringAsFixed(2)}",
                                style: GoogleFonts.dancingScript(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                "Avg. Wating Time: ${wtAvg.toStringAsFixed(2)}",
                                style: GoogleFonts.dancingScript(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      //end here
                    ],
                  ),
                ),
        );
      },
    );
  }

  DataColumn col(String title) => DataColumn(label: Text(title));
}
