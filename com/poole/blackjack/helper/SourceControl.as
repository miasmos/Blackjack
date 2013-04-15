package com.poole.blackjack.helper {
	import flash.display.MovieClip;
	
	public class SourceControl extends MovieClip {
		private var doneLoading:Boolean = false;
		private var firstCall:Boolean = false;
		private var node:XML;
		private var loader;
		
		public function SourceControl(nod,obj) {
			node = nod;
			loader = obj;
		}
		
		public function SetLoaded(inp:Boolean) {
			doneLoading=inp;
		}
		
		public function SetFirstCall(inp:Boolean) {
			firstCall=inp;
		}
		
		public function Loaded() {
			return doneLoading;
		}
		
		public function FirstCall() {
			return firstCall;
		}
		
		public function GetName() {
			return node.@name;
		}
		
		public function GetType() {
			return node.name();
		}
		
		public function GetURL() {
			return String(node.@url);
		}
		
		public function GetObject() {
			return loader;
		}
		
		public function SetObject(obj) {
			loader = obj;
		}
	}
	
}
