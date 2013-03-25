package com.poole.blackjack.game {
	import flash.events.*;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.net.Responder;
	
	public class TouchEvents extends EventDispatcher {
		private var fingerX:int;
		private var fingerY:int;
		private var target:Object;
		private var action:String;
		
		public function TouchEvents(tar) {
			target=tar;
			target.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
			target.addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			target.addEventListener(TouchEvent.TOUCH_END,onTouchEnd);
		}
		
		private function onTouchBegin(e:TouchEvent) {
			fingerX = e.stageX;
			fingerY = e.stageY;
		}
		
		private function onTouchMove(e:TouchEvent) {
			if (e.stageX > (fingerX+150) && (e.stageY > (fingerY-100) && e.stageY < (fingerY+100))) {	// swipe right
				action = "sr";
			}
			else if(e.stageX < (fingerX-150) && (e.stageY > (fingerY-100) && e.stageY < (fingerY+100))) { 	// swipe left
				action = "sl";
			}
			else if(e.stageY < (fingerY-150) && (e.stageX > (fingerX-100) && e.stageX < (fingerX+100))) { 	// swipe up
				action = "su";
			}
			else if(e.stageY > (fingerY+150) && (e.stageX > (fingerX-100) && e.stageX < (fingerX+100))) { 	// swipe down
				action = "sd";
			}
		}
	
		private function onTouchEnd(e:TouchEvent) { 	// e.touchPointID;
			if (e.stageX > (fingerX-40) && e.stageX < (fingerX+40) && e.stageY < (fingerY+40) && e.stageY > (fingerY-40)) {
				trace("clicked");
				dispatchEvent(new MouseEvent(MouseEvent.CLICK,true,false,e.stageX,e.stageY));
			}
			else {
				switch (action) {
					case "sr":
						dispatchEvent(new Event("SwipeRight"));
						trace("swiped right");
						break;
					case "sl":
						dispatchEvent(new Event("SwipeLeft"));
						trace("swiped left");
						break;
					case "su":
						dispatchEvent(new Event("SwipeUp"));
						trace("swiped up");
						break;
					case "sd":
						dispatchEvent(new Event("SwipeDown"));
						trace("swiped down");
						break;
				}
			}
    	}
	}
}
