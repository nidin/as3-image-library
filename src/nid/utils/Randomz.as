package nid.utils 
{
	/**
	 * ...
	 * @author Nidin P Vinayak
	 */
	public final class Randomz
	{
		
		public function Randomz() 
		{
			
		}		
		public static function randomString(length:uint = 1, userAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String{
			var alphabet:Array = userAlphabet.split("");
			var alphabetLength:int = alphabet.length;
			var randomLetters:String = "";
			for (var i:uint = 0; i < length; i++){
				randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
			}
			return randomLetters;
		}
		public static function randomLetters(length:uint = 1, userAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",Case:String="both"):String{
			if (Case == "upper") {
				userAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			}else if (Case == "lower") {
				userAlphabet = "abcdefghijklmnopqrstuvwxyz"
			}
			var alphabet:Array = userAlphabet.split("");
			var alphabetLength:int = alphabet.length;
			var randomLetters:String = "";
			for (var i:uint = 0; i < length; i++){
				randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
			}
			return randomLetters;
		}
		public static function randomNumber(length:uint = 1, userNumberString:String = "0123456789"):String{
			var numbers:Array = userNumberString.split("");
			var numbersLength:int = numbers.length;
			var randomNumbers:String = "";
			for (var i:uint = 0; i < length; i++){
				randomNumbers += numbers[int(Math.floor(Math.random() * numbersLength))];
			}
			return randomNumbers;
		}		
	}

}