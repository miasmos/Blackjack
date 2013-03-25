package com.poole.blackjack.ui {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class CircleTimer extends Sprite {
		/** Current angle on the circle we're drawing from */
		private var __angle:Number;
		
		/** Center of the circle in the X */
		private var __centerX:Number;
		
		/** Center of the circle in the Y */
		private var __centerY:Number;
		
		/** Radius of the circle */
		private var __radius:Number;
		
		/** Number of radians of the circle to draw per second */
		private var __radiansPerSecond:Number;
		
		/** Time circle drawing will finish */
		private var __endTime:int;
		
		/** Last time we entered a frame */
		private var __lastFrameTime:uint;
		
		/** Our circle*/
		private var __circle:Shape = new Shape();
		
		/** Parameter used in stageClick to know if we are paused or not */
		private var __paused:Boolean = false;
		
		/** Double this time is how long it will take for the circle to be drawn */
		private var __rotationTime:int = 2.5;
		
		/** Parameter that is used to know when to reset the __timeSpentPaused variable after a pause */
		private var __iWasPaused:Boolean = false;
		
		/** Variable that is used to add onto __endTime when you pause the animation */
		private var __timeSpentPaused:int;
		
		/** */
		private var __beforeTime = int;
		
		/**
		*   Application entry point
		*/
		public function CircleTimer() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//stage.addEventListener(MouseEvent.CLICK, stageClick);
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.quality = StageQuality.BEST;
			addChild(__circle);
			
			var mask_sh:Shape = new Shape();
			mask_sh.graphics.beginFill(0xCCCCCC);
			mask_sh.graphics.drawCircle(0, 0, 31);  //make the mask just a bit larger than the circle
			mask_sh.graphics.endFill();
			mask_sh.x = stage.stageWidth/2;
			mask_sh.y = stage.stageHeight/2;
			addChild(mask_sh);
			
			__circle.mask = mask_sh;
			
			__angle = 270*(Math.PI/180);
			__centerX = stage.stageWidth/2;
			__centerY = stage.stageHeight/2;
			__radius = 19;
			__radiansPerSecond = Math.PI / __rotationTime;
			
			initCircle();
		}
		
		public function Pause(e:Event)
		{
			if (__paused == true) {
				__timeSpentPaused = getTimer() - __timeSpentPaused;
				__endTime = __endTime + __timeSpentPaused;
				__lastFrameTime = getTimer();
				__iWasPaused = false;
				__paused = false;
				addEventListener(Event.ENTER_FRAME, onEnterFrameDraw);
				
			} else {
				removeEventListener(Event.ENTER_FRAME, onEnterFrameDraw);
				__timeSpentPaused = getTimer();
				__iWasPaused = true;
				__paused = true;
			};
		}
		
		private function initCircle():void 
		{
			__beforeTime = getTimer();
			__angle = 270*(Math.PI/180);
			__endTime = getTimer() + (2000*Math.PI) / __radiansPerSecond;
			
			__circle.graphics.clear();
			__circle.graphics.lineStyle(6, 0xEEEEEE,1,false,LineScaleMode.NORMAL,CapsStyle.NONE);
			__circle.graphics.moveTo(
				__centerX + Math.cos(__angle)*__radius,
				__centerY + Math.sin(__angle)*__radius
			);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameDraw);
			__lastFrameTime = getTimer();
		}
		
		/**
		*   Callback for when a frame is entered
		*   @param ev ENTER_FRAME event
		*/
		private function onEnterFrameDraw(ev:Event): void
		{
			var now:int = getTimer();
			var dTime:int = now - __lastFrameTime;

			if (!__iWasPaused) {
				__lastFrameTime = now;
			}
			
			var radiansMoved:Number = dTime * 0.001 * __radiansPerSecond;
			var endAngle:Number = __angle + radiansMoved;
			var halfAngle:Number = __angle + radiansMoved*0.5;
			__angle = endAngle;
			
			__circle.graphics.curveTo(
				__centerX + Math.cos(endAngle)*__radius,
				__centerY + Math.sin(endAngle)*__radius,
				__centerX + Math.cos(halfAngle)*__radius,
				__centerY + Math.sin(halfAngle)*__radius
			);
			
			if (now > __endTime)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrameDraw);
				//trace('Total time elapsed : ' + (getTimer() - (__beforeTime + __timeSpentPaused))); //Not accurate if paused
				//initCircle();
			}
		}
		
		public function IsDone() {
			return !this.hasEventListener(Event.ENTER_FRAME);
		}
		
		public function Reset() {
			initCircle();
		}
		
		public function HardReset() {
			removeChild(__circle);
		}
	}
}