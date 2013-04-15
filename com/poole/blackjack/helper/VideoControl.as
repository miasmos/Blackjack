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
	import flashx.textLayout.formats.Float;
	import flash.events.MouseEvent;
	
	public class VideoControl extends SourceControl {
		private var nc:NetConnection;
		private var stream:NetStream;
		private var snd:SoundTransform;
		private var myVideo:Video;
		private var isPlay:Boolean=true;
		private var isMuted:Boolean=false;
		private var isDone:Boolean=false;
		
		public function VideoControl(nod) {
			super(nod,null);
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE,init);
			nc = new NetConnection();
			nc.connect(null);
			stream = new NetStream(nc);
			stream.client = {onMetaData:function(){}, onCuePoint:function(){}};
			playPause.gotoAndStop("Play");
			mute.gotoAndStop("On");
			mute.addEventListener(MouseEvent.CLICK, Mute);
			playPause.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {controls(e,true);});
		}
		
		public function Start(w:Number,asp=null) {	//0 = 16:9, 1 = 4:3
			var h:Number; var bHeight = playPause.height;
			if (asp == 0 || asp == null) {h = w/(16/9);}
			else {h = w/(4/3);};
			myVideo = new Video(w,h);
			addChild(myVideo);
			this.width = w; this.height = h+bHeight;;
			this.x = (stage.stageWidth-this.width)/2; this.y = (stage.stageHeight-this.height)/2;
			myVideo.attachNetStream(stream);
			stream.play(GetURL());
			snd = new SoundTransform();
			snd.volume=1;
			stream.soundTransform=snd;
			stream.addEventListener(NetStatusEvent.NET_STATUS, donePlaying);
			var totalWidth = playPause.width+mute.width+5;
			playPause.y=h; mute.y=h;
			playPause.x = (stage.stageWidth-totalWidth)/2; mute.x = (stage.stageWidth-totalWidth)/2+mute.width+5;
		}
		
		public function Play() {
			if (!isPlay) {
				isPlay=true;
				stream.resume();
			}
		}
		
		public function Stop() {
			//lastPos=0;
			isPlay=false;
			stream.pause();
			//playPause.gotoAndPlay("Pause");
		}
		
		public function Pause() {
			//lastPos = myChannel.position;
			//myChannel.stop();
			if (isPlay) {
				isPlay=false;
				stream.pause();
			}
		}
		
		public function Toggle() {
			if (isPlay) {Pause();}
			else {Play();}
		}
		
		public function Volume(vol:Number) {
			snd.volume = vol;
			stream.soundTransform = snd;
			if (vol == 0) {mute.gotoAndStop("Off");}
			else {mute.gotoAndStop("On");}
		}
		
		public function Mute(e:MouseEvent) {
			if (isMuted) {Volume(1);}
			else {Volume(0);}
			isMuted = !isMuted;
			//if (IsPlaying()) {Play();}
			//else {Pause();}
		}
		
		private function donePlaying(stats:NetStatusEvent) {
			if (stats.info.code == 'NetStream.Play.Stop') {		//video is at the end
				stream.removeEventListener(NetStatusEvent.NET_STATUS, donePlaying);
				isDone=true;
			}
		}
		
		private function controls(e:MouseEvent,func:Boolean) {
			if (func) {	//play/pause
				if (IsPlaying()) {playPause.gotoAndStop("Pause");}
				else {playPause.gotoAndStop("Play");}
				Toggle();
			}
			else {	//stop
				Stop();
				playPause.gotoAndStop("Play");
			}
		}
		
		public function IsPlaying() {
			return isPlay;
		}
		
		public function IsMuted() {
			return isMuted;
		}
		
		public function IsDone() {
			return isDone;
		}
		
		public function GetThis() {
			return this;
		}
		
		public function GetStream() {
			return stream;
		}
		public function GetVideo() {
			return myVideo;
		}
	}
}
