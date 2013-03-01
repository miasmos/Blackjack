package  {
	import flash.media.Sound
	import flash.media.SoundChannel
	import flash.display.Loader
	import flash.net.URLRequest
	import flash.net.URLLoader
	
	public class Audio {
		private var music:Sound = new Music();
		private var shuffle:Sound = new Shuffle();
		
		public function Audio() {
			
		}

		public function Play(sound:String) {
			private var myChannel:SoundChannel = new SoundChannel();
			
			if (this[sound]) {
				private var mySound:Sound = new Sound(this[sound]);
				this[sound]
				this[sound].Play();
			}
		}
		
		public function Play(sound:String) {
			if (this[sound]) {
				this[sound].Play();
			}
		}
	}
	
}
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

class AudioControl {
	private var mySound:Sound = new Sound();
	private var myChannel:SoundChannel = new SoundChannel();
	private var lastPos:Number=0;
	private var isPlay:Boolean=false;
	
	public function AudioControl(path) {
		mySound.load(new URLRequest(path));
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
