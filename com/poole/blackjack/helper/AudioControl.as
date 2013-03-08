package com.poole.blackjack.helper {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import com.poole.blackjack.helper.SourceControl;
	
	public class AudioControl extends SourceControl {
		private var myChannel:SoundChannel = new SoundChannel();
		private var lastPos:Number=0;
		private var isPlay:Boolean=false;
		private var mySound;
		
		public function AudioControl(nod,obj) {
			super(nod,obj);
			mySound=obj;
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
		
		public function Volume() {
			
		}
		
		public function IsPlaying() {
			return isPlay;
		}
	}
}
