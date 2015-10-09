package com.vox.gospel.media.mp3
{
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	//import com.vox.locallog.logging.ILogger;
	//import com.vox.locallog.logging.Log;
	
	/**
	 * MP3解析器
	 * （当前只具备检查功能）
	 */
	public class MP3Parser
	{
		//private static var _Logger:ILogger = null;
		
		// 最大检查长度（超过此长度未发现合法数据帧则放弃）（bytes）
		public static var MaxCheckLength:int = 0xffff;
		
		/** config: 输出debug信息 */
		public static function set log(value:Boolean):void
		{
			if (value)
			{
				//if (!_Logger) _Logger = Log.getLogger(getQualifiedClassName(MP3Parser).replace("::", "."));
			}
			else
			{
				//_Logger = null;
			}
		}
		
		/** config: 是否检查id3标签 */
		public var checkID3:Boolean = true;
		
		/** config: 是否检查VBR头（暂时无用） */
		public var checkVBR:Boolean = true;
		
		
		/** 数据 */
		private var _data:ByteArray;
		
		/** 当前位置 */
		private var _curPos:int;
		
		/** 第一帧帧头 */
		private var _firstHeader:MP3FrameHeader;
		
		/** id3v2信息 */
		private var _id3:Object;
		
		
		/**
		 * @param data
		 */
		public function MP3Parser(data:ByteArray)
		{
			_data = data;
		}
		
		
		/**
		 * log
		 */
		private function log(msg:String):void
		{
			/*if (_Logger)
			{
				_Logger.debug("[MP3Parser] " + msg);
			}*/
			//trace("[MP3Parser] " + msg);
		}
		
		
		/**
		 * 检验是否是合法的mp3
		 */
		public function validate():Boolean
		{
			// 记录原值
			var oldEndian:String = _data.endian;
			_data.endian = Endian.BIG_ENDIAN;
			var oldPosition:uint = _data.position;
			
			var ret:Boolean = _validate();
			
			_data.endian = oldEndian;
			_data.position = oldPosition;
			
			return ret;
		}
		
		private function _validate():Boolean
		{
			try
			{
				// 获取第一个数据帧
				_data.position = 0;
				var flag:uint = getNextFrame();
				if (!flag) return false;
				
				_firstHeader = new MP3FrameHeader(_data.position - 4, flag);
				log("找到第一帧 position=0x" + _firstHeader.position.toString(16) + ", header=0x" + flag.toString(16) + ", length=0x" + _firstHeader.frameSize.toString(16));
				log("解析信息： " + JSON.stringify(_firstHeader));
				
				// CRC校验
				// TODO
				
				// 解析vbr
				// 暂时没用到
				parseVBR();
				
				// 检查第二帧
				_data.position = _firstHeader.position + _firstHeader.frameSize;
				var flag2:uint = getNextFrame();
				if (!flag2) return false;
				log("找到第二帧 position=0x" + (_data.position - 4).toString(16) + ", header=0x" + flag2.toString(16));
				
				//与当前记录的帧头比较
				//（同步字，版本，layer，采样率）
				var mask:uint = 0xffe00000 | 0x180000 | 0x60000 | 0x0c00;
				//是否检查比特率？ if (!isXing && !isVBRI) mask |= 0xf000;
				if ((flag2 & mask) != (flag & mask))
				{
					throw new Error("与当前记录帧信息不符");
				}
				
				// CRC校验
				// TODO
				
				// 视为通过
				return true;
			}
			catch (err:Error)
			{
				if (err is EOFError)
				{
					var msg:String = "文件已读完";
				}
				else
				{
					msg = err.message;
				}
				log("非mp3 （" + msg + "）");
			}
			
			return false;
		}
		
		
		/**
		 * 查找下一帧
		 * @return 帧头(4bits)
		 */
		private function getNextFrame():uint
		{
			while (_data.bytesAvailable > 4)
			{
				if (!_firstHeader)
				{
					var maxLength:int = MaxCheckLength;
					if (_id3 && _id3.endPos) maxLength += int(_id3.endPos);
					if (_data.position > maxLength)
					{
						throw new Error("超过最大检查长度，未发现mp3数据帧");
					}
				}
				
				var flag:uint = _data.readUnsignedInt();
				
				if (checkID3)
				{
					// id3v2
					if (!_id3)
					{
						// "ID3"
						if ((flag & 0xffffff00) == 0x49443300)
						{
							// 计算长度并跳过
							var id3Version:int = flag & 0xff;
							var id3Reversion:int = _data.readByte();
							var id3Flag:int = _data.readByte();
							var id3Len:int =  (_data.readByte() & 0x7F) << 21
								| (_data.readByte() & 0x7F) << 14
								| (_data.readByte() & 0x7F) << 7
								| (_data.readByte() & 0x7F);
							id3Len += 10;
							
							var endPos:int = _data.position + id3Len - 10;
							log("找到id3v2信息 position=0x" + (_data.position - 10).toString(16) + ", length=0x" + id3Len.toString(16) + "(" + id3Len + "), goto=0x" + endPos.toString(16));
							_data.position = endPos;
							_id3 = {
								endPos: endPos
							};
							continue;
						}
					}
					
					// id3v1
					// "TAG"
					if ((flag & 0xffffff00) == 0x54414700)
					{
						log("找到id3v1信息 position=0x" + (_data.position - 4).toString(16));
						_data.position = _data.length - 1;
						return 0;
					}
				}
				
				// 帧头
				if (MP3FrameHeader.isValid(flag))
				{
					return flag;
				}
				
				// 下一个位置
				_data.position = _data.position - 3;
			}
			
			return null;
		}
		
		
		/** VBR类型 (CBR|Xing|VBRI) */
		private var _VBRType:String = null;
		/** VBR类型 (CBR|Xing|VBRI) */
		public function get VBRType():String { return _VBRType; }
		
		/**
		 * 解析VBR/VBRI信息
		 */
		private function parseVBR():void
		{
			//是否需要检查VBR信息？
			
			// Xing
			// 在Layer III文件中，XING头紧接着边信息之后。
			// 因此，你可以通过使第一帧帧头起始地址加上帧头大小(4个字节)，
			// 然后再加上边信息大小(参考表2.2.1)，就可以得到XING头的位置。
			// 虽然Layer III有边信息，
			// 但是Layer I、II、III都不用考虑16比特位的CRC(如果有的话)。
			_data.position = _firstHeader.position + 4 + _firstHeader.sideInfoSize;
			var flag:uint = _data.readUnsignedInt();
			
			// "Info"
			// CBR不一定有此信息
			// 另外，据说"Info"也可能会出现在VBR中，但是暂时不管，当做CBR处理
			if (flag == 0x496E666F)
			{
				_VBRType = "CBR";
				return;
			}
			
			// "Xing"
			if (flag == 0x58696E67)
			{
				// Flags which indicate what fields are present, flags are combined with a logical OR. Field is mandatory.
				// 0x00000001 - Frames field is present
				// 0x00000002 - Bytes field is present
				// 0x00000004 - TOC field is present 
				// 0x00000008 - Quality indicator field is present
				var xingFlag:uint = _data.readUnsignedInt();
				// 是否需要检查下？
				_VBRType = "Xing";
				return;
			}
			
			// VBRI头起始位置 = MPEG第一帧帧头起始位置 +  帧头大小 + 32。
			// 帧头大小 = 4（或6,当Protection bit==0时，帧头后会有16bits的CRC）。
			_data.position = _firstHeader.position + _firstHeader.headerSize + 32;
			flag = _data.readUnsignedInt();
			// "VBRI"
			if (flag == 0x56425249)
			{
				_VBRType = "VBRI";
				return;
			}	
		}
		
		
	}
}
