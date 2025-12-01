class ProcessData{
    final int id;
    final int at;
    final int bt;
    int ct;
    int st;
    int tat;
    int wt;
    int rt;
    int? pq;
    bool finished;
    ProcessData({required this.id,required this.at,required this.bt,this.pq=0}): 
      this.ct=0,
      this.tat=0,
      this.wt=0,
      this.rt=0,
      this.st=0,
      this.finished=false;
    void setOtherTimes(){
      tat=ct-at;
      wt=tat-bt;
      rt=st-at;
    }
   
 }