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
    int end;
    bool finished;
    ProcessData({required this.id,required this.at,required this.bt,this.pq=0}): 
      this.ct=0,
      this.tat=0,
      this.wt=0,
      this.rt=0,
      this.st=0,
      this.end=0,
      this.finished=false;
    void setOtherTimes(){
      tat=ct-at;
      wt=tat-bt;
      rt=st-at;
    }
    @override
    String toString(){
      return "id:$id at:$at bt:$bt ct:$ct";
    }
    ProcessData copyWith({
      int? id,
      int? at,
      int? bt,
      int? ct,
      int? st,
      int? tat,
      int? wt,
      int? rt,
      int? pq,
      int? end,
      bool? finished,
    }){
      return ProcessData(id: id??this.id, at: at??this.at, bt: bt??this.bt, pq: pq??this.pq)
        ..ct = ct ?? this.ct
        ..st = st ?? this.st
        ..tat = tat ?? this.tat
        ..wt = wt ?? this.wt
        ..rt = rt ?? this.rt
        ..end = end ?? this.end
        ..finished = finished ?? this.finished;
    }
 }