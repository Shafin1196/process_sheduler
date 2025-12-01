import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduling_simulator/constants/constant.dart';
import 'package:scheduling_simulator/providers/constant_provider.dart';

class Selection extends ConsumerStatefulWidget {
  const Selection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectionState();
}

class _SelectionState extends ConsumerState<Selection> {
  @override
  Widget build(BuildContext context) {
    var height = ref.watch(screenHeight(context));
    var width = ref.watch(screenWidth(context));
    return Expanded(
      flex: 3, 
      child: Container(
        height: height ,
        width: double.infinity ,
        margin: EdgeInsets.all(height * width * 0.00002),
        padding: EdgeInsets.all(height * width * 0.00002),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 4),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) ),
        ),
        child: Column(
          
          children: [
            
            Row(children: [
              button(title: fcfs,key: "FCFS"),
              SizedBox(width: 30,),
              button(title: sjf, key: "SJF")

            ],),
            SizedBox(height: 10,),
            Row(children: [
              button(title: rr, key: 'RR'),
              SizedBox(width: 30,),
              button(title: srtf, key: "SRTF")

            ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               buttonWithoutEx(title: prio,key: "PQ"),
            ],),
          ],
        ),
      ),
      );
  }

  Consumer buttonWithoutEx({required String title,required String key}) {
    return Consumer(builder: (context,ref,child){
                final algorithmProvider=ref.watch(selectedAlgorithm);
                // final listProcess=ref.watch(processLists);
                return ElevatedButton(
                  onPressed: (){
                    ref.read(selectedAlgorithm.notifier).state=key;
                    ref.read(processLists.notifier).state=[];
                    ref.read(arivalTimeController.notifier).state=TextEditingController();
                    ref.read(burstTimeController.notifier).state=TextEditingController();
                    ref.read(priorityController.notifier).state=TextEditingController();
                    ref.read(timeQuantumController.notifier).state=TextEditingController();
                    ref.read(generateFlag.notifier).state=false;
                  }, 
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shadowColor: textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    backgroundColor: algorithmProvider==key?selectedColor:borderColor
                  ),
                  child: Text(title,
                  style: GoogleFonts.dancingScript(
                    color: algorithmProvider==key?white:textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                    ),
                  ),
                  );
              });
  }

  Expanded button({required String title,required String key}) {
    return Expanded(
              child: Consumer(builder: (context,ref,child){
                final algorithmProvider=ref.watch(selectedAlgorithm);
                return ElevatedButton(
                  onPressed: (){
                    ref.read(generateFlag.notifier).state=false;
                    ref.read(selectedAlgorithm.notifier).state=key;
                    ref.read(processLists.notifier).state=[];
                    ref.read(arivalTimeController.notifier).state=TextEditingController();
                    ref.read(burstTimeController.notifier).state=TextEditingController();
                    ref.read(priorityController.notifier).state=TextEditingController();
                    ref.read(timeQuantumController.notifier).state=TextEditingController();
                  }, 
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shadowColor: textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    backgroundColor: algorithmProvider==key?selectedColor:borderColor
                  ),
                  child: Text(title,
                  style: GoogleFonts.dancingScript(
                    color: algorithmProvider==key?white:textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                    ),
                  ),
                  );
              }),
            );
  }
}
