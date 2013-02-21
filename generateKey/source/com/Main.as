package com {
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.crypto.generateRandomBytes;
	import flash.filesystem.*;
	import flash.desktop.NativeApplication;
	import flash.events.*;
	import com.Blowfish;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.getQualifiedClassName;
	
	public class Main extends MovieClip {
		var useGeneratedKey:Boolean = false;
		var fileToOpen:File = File.documentsDirectory;
		var $key:ByteArray = new ByteArray();
		var files:Array = new Array();
		var crypto:Blowfish = new Blowfish();
		
		var keyFileExt:String = "key";
		var encFileExt:String = "enc";
		
		public function Main() {
			num.restrict="0-9";
			num.maxChars=4;
			encrypt.visible = false;
			decrypt.visible = false;
			reencode.visible = false;
			generate.addEventListener(MouseEvent.MOUSE_DOWN,newKey);
			num.addEventListener(KeyboardEvent.KEY_UP,checkInput);
			Ekey.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){openFile(e,keyFileExt)});
			Efile.addEventListener(MouseEvent.MOUSE_DOWN,openFile);
			Dkey.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){openFile(e,keyFileExt)});
			Dfile.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){openFile(e,encFileExt)});
			RSkey.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){openFile(e,keyFileExt)});
			RDkey.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){openFile(e,keyFileExt)});
			Rfile.addEventListener(MouseEvent.MOUSE_DOWN,openFile);
			
			encrypt.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){cryptFile(e,1)});
			decrypt.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent){cryptFile(e,0)});
			reencode.addEventListener(MouseEvent.MOUSE_DOWN,reencodeFile);
		}
		
		function cryptFile(e:MouseEvent,f:uint) {
			var action:String;
			if (f==1) {action="E"} else {action="D"}	//set action based on f, 1 = encrypt, 0 = decrypt
			var file:String = files[action+"file"][1]["data"].toString();
			var ret:String;
			trace(file);
			
			if (useGeneratedKey) {
				ret = crypto.encrypt(file,$key.toString());
			}
			else {
				var lkey:String = files[action+"key"][1]["data"].toString();
				ret = crypto.encrypt(file,lkey);
			}
			
			var temp:ByteArray = new ByteArray();
			temp.writeUTFBytes(ret);
			trace("data: "+ret);
			trace("destination: "+subFromLastIndex(files[action+"file"][1].nativePath,"\\"));
			trace("filename: "+files[action+"file"][1].name);
			
			if (f==1) {
				writeFile(temp,subFromLastIndex(files[action+"file"][1].nativePath,"\\"), files[action+"file"][1].name+"."+encFileExt);
			}
			else {
				writeFile(temp,subFromLastIndex(files[action+"file"][1].nativePath,"\\"), subFromLastIndex(files[action+"file"][1].name,"."));
			}
		}
		
		function reencodeFile(e:MouseEvent) {
			
		}
		
		function subFromLastIndex(path:String,char:String) {
			return path.substring(0,path.lastIndexOf(char));
		}
		
		function newKey(e:MouseEvent) {
			if (int(num.text)>1024) {return 0;}
			$key = generateRandomBytes(int(num.text));
			writeFile($key, "", "_.key", true);
			result.text = $key.toString();
			trace("Generated: "+$key);
			Ekey.text = "Using Generated Key";
			Dkey.text = "Using Generated Key";
			RDkey.text = "Using Generated Key";
			useGeneratedKey = true;
		}
		
		function writeFile(dat:ByteArray, dest:String, filename:String, rootDir:Boolean=false) {
			var stream:FileStream = new FileStream();
			var file:File;
			if (rootDir) {
				file = new File(File.applicationDirectory.nativePath+"\\"+dest+"\\"+filename);
			}
			else {
				file = new File(dest+"\\"+filename);
			}
		
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(dat);
			stream.close();
		}
		
		function openFile(e:MouseEvent,filter:String="") {
			files[e.target.name] = new Array();
			files[e.target.name][0] = new File;
			if (filter != "") {
				files[e.target.name][0].browseForOpen("Open", [new FileFilter(filter, "*."+filter)]);
			}
			else {
				files[e.target.name][0].browseForOpen("Open");
			} 
			files[e.target.name][0].addEventListener(Event.SELECT, function(evt:Event) {fileSelected(evt,e.target)}); 
		}
		
		function fileSelected(e:Event, tar:Object) { 
			if (tar.name.charAt(0) == "E") {encrypt.visible = false;}
			if (tar.name.charAt(0) == "D") {decrypt.visible = false;}
			if (tar.name.charAt(0) == "R") {reencode.visible = false;}
			
			files[tar.name][0].removeEventListener(Event.SELECT, function(evt:Event) {fileSelected(evt,e.target)});
			tar.text = files[tar.name][0].nativePath;
			files[tar.name][0].addEventListener(Event.COMPLETE, function(evt:Event){fileLoaded(evt,tar)});
			files[tar.name][0].load();
		}
		
		function fileLoaded(e:Event, tar:Object) {
			files[tar.name][0].removeEventListener(Event.COMPLETE, function(evt:Event){fileLoaded(evt,tar)})
			files[tar.name][1]=e.target as FileReference;
			if (tar.name == "Ekey" || tar.name == "Dkey" || tar.name == "RDkey") {useGeneratedKey = false;}
			enableButton();
		}
		
		function enableButton() {
			if (useGeneratedKey) {
				if (files["Efile"]) {
					if (files["Efile"][1]) {
						if (files["Efile"][1]["data"]) {
							encrypt.visible = true;
						}
					}
				}
				if (files["Dfile"]) {
					if (files["Dfile"][1]) {
						if (files["Dfile"][1]["data"]) {
							decrypt.visible = true;
						}
					}
				}
				if (files["RSkey"] && files["Rfile"]) {
					if (files["Rfile"][1] && files["RSkey"][1]) {
						if (files["Efile"][1]["data"] && files["RSkey"][1]["data"]) {
							reencode.visible = true;
						}
					}
				}
			}
			else {
				if (files["Ekey"] && files["Efile"]) {
					if (files["Ekey"][1] && files["Efile"][1]) {
						if (files["Ekey"][1]["data"] && files["Efile"][1]["data"]) {
							encrypt.visible = true;
						}
					}
				}
				if (files["Dkey"] && files["Dfile"]) {
					if (files["Dkey"][1] && files["Dfile"][1]) {
						if (files["Dkey"][1]["data"] && files["Dfile"][1]["data"]) {
							decrypt.visible = true;
						}
					}
				}
				if (files["RSkey"] && files["Rfile"] && files["RDkey"]) {
					if (files["RSkey"][1] && files["Rfile"][1] && files["RDkey"][1]) {
						if (files["RSkey"][1]["data"] && files["Rfile"][1]["data"] && files["RDkey"][1]["data"]) {
							reencode.visible = true;
						}
					}
				}
			}
		}
		
		function checkInput(e:KeyboardEvent) {
			if (int(e.target.text) > 1024) {e.target.text = 1024;}
		}

	}
}
