package com.poole.blackjack.helper {
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.media.Video;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import com.poole.blackjack.helper.SourceControl;
	
	public class VideoControl extends SourceControl {
		private var nc:NetConnection;
		private var stream:NetStream;
		private var myVideo:Video;
		private var isPlay:Boolean=false;
		private var isMuted:Boolean=false;
		
		public function VideoControl(nod) {
			super(nod,null);
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE,init);
			nc = new NetConnection();
			nc.connect(null);
			stream = new NetStream(nc);
			myVideo = new Video(this.width,this.height);
			myVideo.attachNetStream(stream);
			loader=myVideo;
			stream.play(GetURL());
		}
		
		public function Play() {
			if (!isPlay) {
				isPlay=true;
				//myChannel = mySound.play(lastPos);
				if (isMuted) {myChannel.soundTransform = new SoundTransform(0);}
				trace("playing,muted:"+isMuted);
			}
		}
		
		public function Stop() {
			//myChannel.stop()
			//lastPos=0;
			isPlay=false;
			trace("stopped,muted:"+isMuted);
		}
		
		public function Pause() {
			//lastPos = myChannel.position;
			//myChannel.stop();
			isPlay=false;
			trace("paused,muted:"+isMuted);
		}
		
		public function Toggle() {
			if (isPlay) {Pause();}
			else {Play();}
		}
		
		public function Mute() {
			//if (isMuted) {myChannel.soundTransform = new SoundTransform(1);}
			//else {myChannel.soundTransform = new SoundTransform(0);}
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
	}
}
