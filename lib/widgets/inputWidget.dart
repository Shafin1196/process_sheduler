import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduling_simulator/constants/constant.dart';
import 'package:scheduling_simulator/models/process_data.dart';
import 'package:scheduling_simulator/providers/constant_provider.dart';
import 'package:scheduling_simulator/widgets/process_item.dart';

class Input extends ConsumerStatefulWidget {
  const Input({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputState();
}

class _InputState extends ConsumerState<Input> {
  final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            return Column(
              children: [
                algoProvider == "RR"
                    ? Consumer(
                        builder: (context, ref, child) {
                          final tqc = ref.watch(timeQuantumController);
                          return SizedBox(
                            width: 160,
                            child: TextField(
                              controller: tqc,
                              keyboardType: TextInputType.number,
                              decoration: inputDecoration("Time Quantum"),
                            ),
                          );
                        },
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 10),
                algoProvider == "PQ"
                    ? Consumer(
                        builder: (context, ref, child) {
                          final isHigh = ref.watch(priorityHighLow);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isHigh,
                                activeColor: selectedColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
                                onChanged: (val) {
                                  ref.read(priorityHighLow.notifier).state =
                                      val ?? true;
                                },
                              ),
                              Text(
                                "Higher Value",
                                style: GoogleFonts.dancingScript(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 1, child: Icon(Icons.settings_applications)),
                    Consumer(
                      builder: (context, ref, child) {
                        final at = ref.watch(arivalTimeController);
                        return Expanded(
                          flex: 4,
                          child: TextField(
                            controller: at,
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration("Arival Time"),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    Consumer(
                      builder: (context, ref, child) {
                        final bt = ref.watch(burstTimeController);
                        return Expanded(
                          flex: 4,
                          child: TextField(
                            controller: bt,
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration("Burst Time"),
                          ),
                        );
                      },
                    ),
                    algoProvider == "PQ"
                        ? SizedBox(width: 20)
                        : SizedBox.shrink(),
                    algoProvider == "PQ"
                        ? Consumer(
                            builder: (context, ref, child) {
                              final pc = ref.watch(priorityController);
                              return Expanded(
                                flex: 4,
                                child: TextField(
                                  controller: pc,
                                  keyboardType: TextInputType.number,
                                  decoration: inputDecoration("Priority"),
                                ),
                              );
                            },
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 5),
                Consumer(
                  builder: (context, ref, child) {
                    final listProcess = ref.watch(processLists);
                    return Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: listProcess.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "No process added yet!",
                                    style: GoogleFonts.dancingScript(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),

                                  Image.asset(
                                    "assets/history2.gif",
                                    height: 230,
                                  ),
                                ],
                              )
                            : ListView.builder(
                                controller: _controller,
                                itemCount: listProcess.length,
                                itemBuilder: (context, index) {
                                  final current = listProcess[index];
                                  return ProcessItem(currentItem: current);
                                },
                              ).animate().fadeIn(
                                duration: 5.seconds,
                                curve: Curves.easeIn,
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final listProvider = ref.watch(processLists);
                          final nextId = listProvider.length + 1;
                          return ElevatedButton.icon(
                            onPressed: () {
                              ref.read(generateFlag.notifier).state = false;
                              final at =
                                  int.tryParse(
                                    ref.watch(arivalTimeController).text,
                                  ) ??
                                  0;
                              final bt =
                                  int.tryParse(
                                    ref.watch(burstTimeController).text,
                                  ) ??
                                  0;
                              final pc = int.tryParse(
                                ref.watch(priorityController).text,
                              );
                              ref.read(processLists.notifier).state = [
                                ...listProvider,
                                ProcessData(
                                  id: nextId,
                                  at: at,
                                  bt: bt,
                                  pq: algoProvider == "PQ" ? pc : 0,
                                ),
                              ];
                              Future.delayed(Duration(milliseconds: 100), () {
                                _controller.jumpTo(
                                  _controller.position.maxScrollExtent,
                                );
                              });
                            },
                            label: Text(
                              "Add Process",
                              style: GoogleFonts.dancingScript(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: borderColor.withOpacity(1),
                              elevation: 7,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: Icon(Icons.add, size: 25, color: textColor),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton.icon(
                            onPressed: () {
                              ref.read(processLists.notifier).state = [];
                              ref.read(arivalTimeController.notifier).state =
                                  TextEditingController();
                              ref.read(burstTimeController.notifier).state =
                                  TextEditingController();
                              ref.read(priorityController.notifier).state =
                                  TextEditingController();
                              ref.read(timeQuantumController.notifier).state =
                                  TextEditingController();
                              ref.read(generateFlag.notifier).state = false;
                            },
                            label: Text(
                              "Clear",
                              style: GoogleFonts.dancingScript(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: borderColor.withOpacity(1),
                              elevation: 7,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: Icon(
                              Icons.refresh,
                              size: 25,
                              color: textColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      label: Text(
        hint,
        style: GoogleFonts.dancingScript(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      hintText: hint,
      hintStyle: GoogleFonts.dancingScript(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: textColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
