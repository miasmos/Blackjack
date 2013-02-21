package com.poole.blackjack.game {
	import flash.events.EventDispatcher;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.net.Responder;
	
	public class TouchEvents extends EventDispatcher {
		private var fingerX:int;
		private var fingerY:int;
		private var target:Object;
		
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
				dispatchEvent(new TouchEvent.TOUCH_SWIPE(TouchSwipeRight.SWIPE_RIGHT, e));
			}
			else if(e.stageX < (fingerX-150) && (e.stageY > (fingerY-100) && e.stageY < (fingerY+100))) { 	// swipe left
				dispatchEvent(new TouchSwipeLeft(TouchSwipeLeft.SWIPE_LEFT, e));
			}
		}
	
		private function onTouchEnd(e:TouchEvent) { 	// e.touchPointID;
			if(e.stageX > (fingerX-40) && e.stageX < (fingerX+40)) {
				dispatchEvent(new TouchEventTap(TouchEventTap.TAP, e));
				target.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				target.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				target.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			}

    	}
	}
}
