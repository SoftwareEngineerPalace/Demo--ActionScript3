package MP3
{
	/**
	 * MP3相关常量
	 */
	internal class MP3Consts
	{
		// mpeg版本号
		public static const MPEG1:int = 3;  
		public static const MPEG2:int = 2;
		public static const MPEG2_5:int = 0;
		
		// 最大帧长度 //MPEG 1.0/2.0/2.5, Lay 1/2/3
		public static const MAX_FRAMESIZE:uint = 1732;
		
		/** 比特率表（基础值） */
		public static const intBitrateTable:Array = [
			//MPEG 1  
			[
				//Layer I  
				[0, 32, 64, 96,128,160,192,224,256,288,320,352,384,416,448],
				//Layer II  
				[0, 32, 48, 56, 64, 80, 96,112,128,160,192,224,256,320,384],
				//Layer III  
				[0, 32, 40, 48, 56, 64, 80, 96,112,128,160,192,224,256,320]
			],
			//MPEG 2.0/2.5  
			[  
				//Layer I  
				[0, 32, 48, 56, 64, 80, 96,112,128,144,160,176,192,224,256],
				//Layer II  
				[0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160],
				//Layer III  
				[0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160]
			]
		];
		
		/** 采样率 */
		public static const intSamplingRateTable:Array = [
			//mpeg2.5
			[11025, 12000, 8000, 0],
			//
			[0, 0, 0, 0],
			//mpeg2
			[22050, 24000, 16000, 0],
			//mpeg1
			[44100, 48000, 32000, 0]  
		];
		
	}
}