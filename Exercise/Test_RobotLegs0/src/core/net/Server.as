package core.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import event.LoginEvent;
	
	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-3上午9:24:38
	 *
	 */
	public class Server extends EventDispatcher
	{
		
		private static var _inst:Server;
		
		private var _socket:Socket;
		private var _receiveBytes:ByteArray;
		private var _sendBytes:ByteArray;
		private var _callBackDic:Dictionary;
		
		public function Server()
		{
			if(_inst)
				throw new Error("socket should be only one!");
			init();
		}
		
		public static function get dssssssssssssssss():Server
		{
			return _inst ||= new Server();
		}
		
		private function init():void
		{
			_receiveBytes = new ByteArray();
			_sendBytes = new ByteArray();
			_callBackDic = new Dictionary();
			
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT,connectHandler);
			_socket.addEventListener(Event.CLOSE,closeHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,dataHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHander);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
		}
		
		/**
		 *连接服务器 
		 * @param host
		 * @param port
		 * 
		 */		
		public function connect(host:String,port:int):void
		{
			_socket.connect(host,port);
		}
		
		/**
		 *关闭服务器连接 
		 * 
		 */		
		public function close():void
		{
			if(_socket && _socket.connected)
				_socket.close();
		}
		
		private function connectHandler(evt:Event):void
		{
			trace('socket connect success！');
			this.dispatchEvent(new LoginEvent(LoginEvent.CONNECT));
		}
		
		private function closeHandler(evt:Event):void
		{
			trace(evt);
		}
		
		private function ioErrorHander(evt:IOErrorEvent):void
		{
			trace(evt);
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace(evt);
		}
		
		public function addCallFunc(cmd:int,func:Function):void
		{
			_callBackDic[cmd] = func;
		}
		
		public function removeCallFunc(cmd:int,func:Function):void
		{
			if(_callBackDic[cmd] == func)
				delete _callBackDic[cmd];
			else
				throw new Error("cmd:"+ cmd +",callback function not be found!");
		}
		
		private function callBack(cmd:String,data:ByteArray):void
		{
			trace('收到消息：' + cmd);
			if(_callBackDic[cmd])
				_callBackDic[cmd](data);
			else
				trace('收到不存在的指令：'+cmd+"因为未进行处理！");
		}
		
		
		private var _lengthNeedReceived:int;
		private var _hasReededHead:Boolean;
		/**
		 *收到数据 
		 * @param evt
		 * 
		 */		
		private function dataHandler(evt:ProgressEvent):void
		{
			if(_socket.bytesAvailable)
			{
				if( _hasReededHead == false )
				{
					var lengthThisTimeINeeded:int = _socket.readInt();
					_hasReededHead = true;
					_receiveBytes.endian = Endian.BIG_ENDIAN;//为了纠正protobuf中littleendian的更改
				}
				else
				{
					lengthThisTimeINeeded = _lengthNeedReceived;
				}
				
				
				if( _socket.bytesAvailable < lengthThisTimeINeeded )
				{
					_lengthNeedReceived = lengthThisTimeINeeded - _socket.bytesAvailable;
					_socket.readBytes(_receiveBytes,_receiveBytes.position,0);//能读多少先读了
					_receiveBytes.position = _receiveBytes.length;
				}
				else
				{
					_socket.readBytes(_receiveBytes,_receiveBytes.position,lengthThisTimeINeeded);//这个包被彻底读完了，调用函数去吧。下面可能还有一些数据是下个包的
					_receiveBytes.position = 0;
					this.callBack( _receiveBytes.readUTF() , _receiveBytes );
					_hasReededHead = false;
					delete _callBackDic[1001];
				}
			}
		}
		
		/**
		 *向服务器发送数据
		 * @param cmd
		 * @param data 如果用proto通信 data类型为Message
		 * 
		 */		
		public function sendMsg(cmd:int,data:Object):void
		{
			if(cmd && data)
			{
				_sendBytes.length = 0;
				data.writeTo(_sendBytes);
				
				var len:int = cmd.toString().length + 2 + _sendBytes.length;//计算包长
				_socket.writeInt(len);
				_socket.writeUTF(cmd.toString());
				_sendBytes.position = 0;
				_socket.writeBytes(_sendBytes);
				_socket.flush();
				trace("发送消息>>："+cmd);
			}
		}
	}
}