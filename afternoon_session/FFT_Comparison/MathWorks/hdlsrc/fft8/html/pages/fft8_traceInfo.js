function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S2>/FFT */
	this.urlHashMap["fft8:4"] = "fft8_dut.v:71,72,73,74,75,76,77,78,79";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "fft8"};
	this.sidHashMap["fft8"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S2>/dataIn"] = {sid: "fft8:2"};
	this.sidHashMap["fft8:2"] = {rtwname: "<S2>/dataIn"};
	this.rtwnameHashMap["<S2>/validIn"] = {sid: "fft8:3"};
	this.sidHashMap["fft8:3"] = {rtwname: "<S2>/validIn"};
	this.rtwnameHashMap["<S2>/FFT"] = {sid: "fft8:4"};
	this.sidHashMap["fft8:4"] = {rtwname: "<S2>/FFT"};
	this.rtwnameHashMap["<S2>/dataOut"] = {sid: "fft8:5"};
	this.sidHashMap["fft8:5"] = {rtwname: "<S2>/dataOut"};
	this.rtwnameHashMap["<S2>/validOut"] = {sid: "fft8:6"};
	this.sidHashMap["fft8:6"] = {rtwname: "<S2>/validOut"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
