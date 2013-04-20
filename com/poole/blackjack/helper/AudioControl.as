package com.poole.blackjack.helper {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import com.poole.blackjack.helper.SourceControl;
	import flash.events.Event;
	
	public class AudioControl extends SourceControl {
		private var myChannel:SoundChannel = new SoundChannel();
		private var lastPos:Number=0;
		private var isPlay:Boolean=false;
		private var isMuted:Boolean=false;
		private var mySound:Sound;
		private var loop:Boolean=false;
		
		public function AudioControl(nod,obj,lop=false) {
			super(nod,obj);
			mySound=obj;
			loop=lop;
		}
		
		public function Play() {
			if (!isPlay) {
				isPlay=true;
				if (loop) {myChannel = mySound.play(lastPos,9999);}
				else {myChannel = mySound.play(lastPos);}
				myChannel.soundTransform = new SoundTransform(1);
				if (isMuted) {myChannel.soundTransform = new SoundTransform(0);}
				trace("playing,muted:"+isMuted);
			}
		}
		
		public function Stop() {
			myChannel.stop();
			lastPos=0;
			isPlay=false;
			trace("stopped,muted:"+isMuted);
		}
		
		public function Pause() {
			lastPos = myChannel.position;
			myChannel.stop();
			isPlay=false;
			trace("paused,muted:"+isMuted);
		}
		
		public function Toggle() {
			if (isPlay) {Pause();}
			else {Play();}
		}
		
		public function SetLoop() {
			addEventListener(Event.SOUND_COMPLETE,soundDone);
		}
		
		public function Mute() {
			if (isMuted) {myChannel.soundTransform = new SoundTransform(1);}
			else {myChannel.soundTransform = new SoundTransform(0);}
			isMuted = !isMuted;
			if (IsPlaying()) {Play();}
			else {Pause();}
		}
		
		public function IsPlaying() {
			return isPlay;
		}
		
		public function IsMuted() {
			return isMuted;
		}
		
		private function soundDone(e:Event) {removeEventListener(Event.SOUND_COMPLETE,soundDone);Play();addEventListener(Event.SOUND_COMPLETE,soundDone);}
	}
}
