package com
{
 import com.hurlant.util.Base64;
 import com.hurlant.crypto.symmetric.PKCS5;
 import com.hurlant.crypto.symmetric.ECBMode;
 import com.hurlant.crypto.symmetric.BlowFishKey;
 import com.hurlant.crypto.symmetric.ICipher;
 import com.hurlant.crypto.symmetric.IPad;
 import flash.utils.ByteArray;
 import flash.filesystem.File;

 public class Blowfish
 {
 /**
 * Encrypts a string.
 * @param text  The text string to encrypt.
 * @param key  A cipher key to encrypt the text with.
 */
 public function encrypt($text:String,$key:String):String
 {
 try
 {
 var $output:ByteArray = new ByteArray();
 $output.writeUTF($text);
 var $pad:IPad = new PKCS5();
 var $cipher:ICipher = _getCipher( $key, $pad );
 $pad.setBlockSize( $cipher.getBlockSize() );
 $cipher.encrypt( $output );
 $cipher.dispose();
 return Base64.encodeByteArray( $output );
 }
 catch ($error:Error)
 {
 trace("An encryption error occured: "+$error);
 }
 return null;
 }

 /**
 * Decrypts an encrypted string.
 * @param text  The text string to decrypt.
 * @param key  The key used while originally encrypting the text.
 */
 public function decrypt($text:String,$key:String):String
 {
 try
 {
 var $input:ByteArray = Base64.decodeToByteArray( $text );
 var $pad:IPad = new PKCS5();
 var $cipher:ICipher = _getCipher( $key, $pad );
 $pad.setBlockSize( $cipher.getBlockSize() );
 $cipher.decrypt( $input );
 $cipher.dispose();
 $input.position = 0;
 return $input.readUTF();
 }
 catch ($error:Error)
 {
 trace("A decryption error occured.");
 }
 return null;
 }

static public function dump() {

}

 /** @private builds a Blowfish cipher algorithm. */
 private function _getCipher( $key:String, $pad:IPad ):ICipher {
 return new ECBMode( new BlowFishKey(Base64.decodeToByteArray( $key )), $pad );
 }
 }
}