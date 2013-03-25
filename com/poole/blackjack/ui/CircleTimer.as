package com.poole.blackjack.ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	public class CircleTimer {
			/*
			Steve Ottenad - Nov 20, 2009 - AS3 Circle Drawing/ Clock Wipe Snippet
			 
			This Snippet works by drawing and then fading a succession of small triangles to make a circle/polygon.
			It relies on TweenMax, a free tweening engine found at http://blog.greensock.com/tweenmax/.
			 
			Parameters:
			centerX        (Number) - The X coordinate of the center of the circle to be drawn.
			centerY        (Number) - The Y coordinate of the center of the circle to be drawn.
			radius         (Number) - The desired radius of the circle.
			increment      (Number) - The amount of degrees you want to add each time a wedge is drawn. If increment = 2, then 180 wedges will be drawn (360/2). If increment = 36, then 10 wedges will be drawn (360/10).
			timeIncrement  (Number) - The amount of milliseconds between each wedge being drawn.
			Container   (MovieClip) - The containing element.
			 
			Sample Usage: drawCircle(centerX, centerY , radius, increment , timeIncrement, container);
			*/
 			var radius:Number = radius;
			var iniX:Number = centerX;
			var iniY:Number = centerY;
			var increment:Number = increment;
			var totalDegrees:Number = 0;
			var degInRad:Number;
			var degInRad1:Number;
			var maskTimer:Timer = new Timer(timeIncrement);
				
			function CircleTimer(centerX:Number, centerY:Number, radius:Number, increment:Number, timeIncrement:Number, container:MovieClip){
				outline.visible = true;
				maskTimer.addEventListener(TimerEvent.TIMER, drawSegment);
				maskTimer.start();
				 
				//Start Drawing
				container.graphics.moveTo(iniX, iniY);
			}
			
			function drawSegment(e:TimerEvent){
				if(totalDegrees < 362 && keepLoading){
					//Convert to Radians
					degInRad = totalDegrees * (Math.PI / 180);
					degInRad1 = Number(totalDegrees+increment) * (Math.PI / 180);
					//Find X,Y
					var x1:Number = radius * Math.cos( degInRad ) + iniX;
					var y1:Number = radius * Math.sin( degInRad ) + iniY;
					var x2:Number = radius * Math.cos( degInRad1 ) + iniX;
					var y2:Number = radius * Math.sin( degInRad1 ) + iniY;
		 
					var wedge:Sprite = new Sprite();
					wedge.alpha = 0;
		 
					//Define Color
					wedge.graphics.beginFill(0x000000);
					wedge.graphics.moveTo(iniX, iniY);
					wedge.graphics.lineTo(x1, y1);
					wedge.graphics.lineTo(x2, y2);
					wedge.graphics.lineTo(iniX, iniY);
		 
					//Fade In (Time == 1 in this example
					TweenMax.to (wedge, 1, {alpha:1});
					container.addChild(wedge);
		 
					totalDegrees+= increment
					;
				}
				else{
					maskTimer.stop();
				}
			}
		}
	}
}