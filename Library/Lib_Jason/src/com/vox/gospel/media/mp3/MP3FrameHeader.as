package com.vox.gospel.media.mp3
{
	/**
	 * MP3数据帧帧头
	 */
	internal class MP3FrameHeader
	{
		/**
		 * 帧同步标识
		 * 11bits
		 * 全是1
		 * 用于定位帧头起始位置
		 */
		public var sync:int;
		
		/** 
		 * 版本号
		 * 2 bits 
		 * "00"  MPEG Version 2.5 (unofficial extension of MPEG 2); 
		 * "01"  reserved; 
		 * "10"  MPEG Version 2 (ISO/IEC 13818-3); 
		 * "11"  MPEG Version 1 (ISO/IEC 11172-3). 
		 */  
		public var version:int;  
		
		/** 
		 * layer
		 * 2 bits 
		 * "11"  Layer I 
		 * "10"  Layer II 
		 * "01"  Layer III 
		 * "00"  reserved 
		 * 已换算=4-layer: 1-Layer I; 2-Layer II; 3-Layer III; 4-reserved 
		 */
		public var layer:int;  
		
		/** 
		 * protection bit
		 * 1 bit 
		 * "1"  no CRC; 
		 * "0"  protected by 16 bit CRC following header. 
		 */  
		public var protection:int;  
		
		/**  
		 * 比特率索引
		 * 4 bits 
		 */  
		public var bitRateIndex:int;  
		
		/** 
		 * 采样率索引
		 * 2 bits 
		 * '00'  44.1kHz 
		 * '01'  48kHz 
		 * '10'  32kHz 
		 * '11'  reserved 
		 */  
		public var samplingFrequency:int;  
		
		/**
		 * Padding bit
		 * 1 bit
		 * If it is set, data is padded with with one slot (important for frame size calculation)
		 * Layer I的slot大小是4字节，其余情况是1字节。
		 */
		public var padding:int;  
		
		/**
		 * Private bit
		 * 1 bit
		 * (only informative)
		 */
		public var privateBit:int; 
		
		/** 
		 * Channel mode 
		 * 2 bits 
		 * '00'  Stereo; 
		 * '01'  Joint Stereo (Stereo); 
		 * '10'  Dual channel (Two mono channels); 
		 * '11'  Single channel (Mono). 
		 */  
		public var mode:int;  
		
		/**
		 * Mode extension (Only used in Joint Stereo)
		 * 2 bits 
		 *       intensity_stereo   boolMS_Stereo 
		 * '00'  off                off 
		 * '01'  on                 off 
		 * '10'  off                on 
		 * '11'  on                 on 
		 */  
		public var modeExtension:int;
		
		/**
		 * Copyright bit
		 * 1 bit
		 */
		public var copyright:int;
		
		/**
		 * Original bit
		 * 1 bit
		 */
		public var original:int;
		
		/**
		 * Emphasis
		 * 2 bits
		 * 00 - none
		 * 01 - 50/15 ms
		 * 10 - reserved
		 * 11 - CCIT J.17
		 * The emphasis indication is here to tell the decoder that the file must be de-emphasized, that means the decoder must 're-equalize' the sound after a Dolby-like noise suppression. It is rarely used.
		 */
		public var emphasis:int;
		
		
		/**
		 * 是否是低采样率(mpeg2/2.5)
		 * 0/1
		 */
		public var LSF:int;
		
		
		/**
		 * 起始位置
		 */
		public var position:uint;
		
		/**
		 * 帧头
		 */
		public var flag:uint;
		
		/**
		 * 帧总长
		 */
		public var frameSize:int;
		
		/**
		 * 帧头长
		 */
		public var headerSize:int;
		
		/**
		 * 帧主数据长
		 */
		public var mainDataSize:int;
		
		/**
		 * 帧边信息长
		 */
		public var sideInfoSize:int;  
		
		
		
		/** 是否是合法帧头 */
		public static function isValid(flag:uint):Boolean
		{
			return 	   (((flag >>> 21) & 0x7ff) == 0x7ff)
					&& (((flag >> 19) & 0x3) != 1)
					&& (((flag >> 17) & 0x3) != 0)
					&& (((flag >> 12) & 0xF) != 0)
					&& (((flag >> 12) & 0xF) != 15)
					&& (((flag >> 10) & 0x3) != 3)
					&& (((flag      ) & 0x2) != 2);
		}
		
		
		/** 解析帧头 */
		private function parse():void
		{
			sync = (flag >>> 21);
			version = (flag >> 19) & 0x3;
			layer = 4 - (flag >> 17) & 0x3;  
			protection = (flag >> 16) & 0x1;  
			bitRateIndex = (flag >> 12) & 0xF;  
			samplingFrequency = (flag >> 10) & 0x3;  
			padding = (flag >> 9) & 0x1;  
			privateBit = (flag >> 8) & 0x1;
			mode = (flag >> 7) & 0x3;  
			modeExtension = (flag >> 5) & 0x3;
			copyright = (flag >> 3) & 0x1;
			original = (flag >> 2) & 0x1;
			emphasis = (flag) & 0x2;
			
			LSF = (version == MP3Consts.MPEG1) ? 0 : 1;
			
			//计算帧长度
			//LyaerI：            (( 每帧采样数 / 8 * 比特率 ) / 采样频率 ) + 填充 * 4
			//LayerII和LyaerIII： (( 每帧采样数 / 8 * 比特率 ) / 采样频率 ) + 填充
			switch (layer)
			{
				case 1:
					frameSize  = MP3Consts.intBitrateTable[LSF][0][bitRateIndex] * 12000;
					frameSize /= MP3Consts.intSamplingRateTable[version][samplingFrequency];
					frameSize  = (frameSize + padding) << 2;
					break;
				
				case 2:
					frameSize  = MP3Consts.intBitrateTable[LSF][1][bitRateIndex] * 144000;
					frameSize /= MP3Consts.intSamplingRateTable[version][samplingFrequency];
					frameSize += padding;
					break;
				
				case 3:
					frameSize  = MP3Consts.intBitrateTable[LSF][2][bitRateIndex] * 144000;  
					frameSize /= MP3Consts.intSamplingRateTable[version][samplingFrequency] << (LSF);  
					frameSize += padding;  
					//计算帧边信息长度  
					if (version == MP3Consts.MPEG1)
						sideInfoSize = (mode == 3) ? 17 : 32;  
					else
						sideInfoSize = (mode == 3) ? 9 : 17;  
					break;
			}  
			
			//帧头长度
			headerSize = 4 + (protection ? 0 : 2);
			
			//计算主数据长度  
			mainDataSize = frameSize - headerSize - sideInfoSize;
		}
		
		
		public function MP3FrameHeader(position:uint, header:uint)
		{
			this.position = position;
			this.flag = header;
			parse();
		}
		
	}
}
