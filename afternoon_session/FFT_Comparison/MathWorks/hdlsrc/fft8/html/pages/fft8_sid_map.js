function RTW_SidParentMap() {
    this.sidParentMap = new Array();
    this.sidParentMap["fft8:2"] = "fft8:1";
    this.sidParentMap["fft8:3"] = "fft8:1";
    this.sidParentMap["fft8:4"] = "fft8:1";
    this.sidParentMap["fft8:5"] = "fft8:1";
    this.sidParentMap["fft8:6"] = "fft8:1";
    this.getParentSid = function(sid) { return this.sidParentMap[sid];}
}
    RTW_SidParentMap.instance = new RTW_SidParentMap();
