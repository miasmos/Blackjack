package com.poole.blackjack {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.filesystem.*;
	
	public class ImageControl {
		private var mySound:Sound = new Sound();
		private var myChannel:SoundChannel = new SoundChannel();
		private var lastPos:Number=0;
		private var isPlay:Boolean=false;
		
		public function ImageControl(obj) {
			mySound = obj;
		}
		
		public function Play() {
			if (!isPlay) {
				isPlay=true;
				myChannel = mySound.play(lastPos);
			}
		}
		
		public function Stop() {
			myChannel = mySound.stop();
			lastPos=0;
			isPlay=false;
		}
		
		public function Pause() {
			lastPos = myChannel.position;
			myChannel.stop();
			isPlay=false;
		}
		
		public function isPlaying() {
			return isPlay;
		}
	}
}