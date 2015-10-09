package 
{
	import com.vox.CurStateEvent;
	import com.vox.LoadMC;
	import com.vox.LoadXML;
	import com.vox.StaticVars;
	import com.vox.loadErrorUI;
	import com.vox.toolbarUI;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Timer;
	
	
	public class StateMachineMagazine extends Sprite 
	{
		///////////////////////////////////类体变量定义////////////////////////////
		private var screenWidth:int;
		private var screenHeight:int;
		private var _current_number:int;
		private var _CS:CurStateEvent ;
		private var _messArray:Array = [] ;
		private var tarMC:MovieClip;
		private var tarXML:LoadXML;
		private var targetImg:int=0;
		private var totalImg:int;
		private var setWH:Number;
		private var _tool:toolbarUI;
		//遮罩列数
		private var _rowsNumber:uint=10;
		//遮罩行数
		private var _colsNumber:uint=8;
		//增加步长数
		private var _addStep:uint=20;
		private var _changeRows:uint=0;
		private var maskTimer:Timer;
		private var maskMotion:int=0;
		
		///////////////////////////////////构造函数////////////////////////////
		public function StateMachineMagazine() 
		{
			initialize();
		}
		
		///////////////////////////////////初始化函数////////////////////////////
		private function initialize() :void
		{
			System.useCodePage = false ;
			stage.align = StageAlign.TOP_LEFT ;
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			stage.frameRate = StaticVars.SYSTEM_FRAME_RATE ;
			screenWidth = stage.stageWidth;
			screenHeight = stage.stageHeight;
			_messArray[0]='assets/p1.jpg';
			_messArray[1]='assets/p2.jpg';
			_messArray[2]='assets/p3.jpg';
			_messArray[3]='assets/p4.jpg';
			_messArray[4]='assets/p5.jpg';
			_messArray[5]='assets/p6.jpg';
			totalImg = _messArray.length ;
			//initImgArray();
			stage.addEventListener( CurStateEvent.Current_Id, currentStateEventInit);
			stage.addEventListener(Event.RESIZE,resizeStage);
			_current_number = 0 ;
			dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_current_number));
		}
		
		///////////////////////////////////主流程函数///////////////////////////////////////////////////////////////////////////////////////////////
		private function currentStateEventInit( $evt:CurStateEvent ):void
		{
			var loadTempMC:MovieClip = new MovieClip;
			var addTempMC:MovieClip = new MovieClip;
			var id:int = $evt.id ;
			switch (id) {
				case 0 :
					if (_messArray.length > 0) {
						_current_number=1;
						dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_current_number));
					} else {
						initImgArray();
					}
					break;
				case 1 :
					_current_number=2;
					removeObj("tarImgs");
					tarMC=new LoadMC(_messArray[targetImg],_current_number);
					//navigateToURL(new URLRequest(_messArray[targetImg]+"?"+_messArray[targetImg]),"_blank");
					tarMC.x=screenWidth / 2;
					tarMC.y=screenHeight / 2;
					tarMC.name="tarImgs";
					addChild(tarMC);
					break;
				case 2 :
					trace(targetImg);
					removeObj("tool");
					//CURRENT_NUMBER=2;
					loadTempMC=tarMC.targetMC;
					if (loadTempMC.width / loadTempMC.height >= screenWidth / screenHeight) {
						setWH=loadTempMC.height / screenHeight;
						loadTempMC.height=screenHeight;
						loadTempMC.width=loadTempMC.width / setWH;
					} else {
						setWH=loadTempMC.width / screenWidth;
						loadTempMC.width=screenWidth;
						loadTempMC.height=loadTempMC.height / setWH;
					}
					loadTempMC.x=- loadTempMC.width / 2;
					loadTempMC.y=- loadTempMC.height / 2;
					if (getChildByName("PIC_BOOT")) {
						addTempMC.name="PIC_TOP";
					} else {
						addTempMC.name="PIC_BOOT";
					}
					trace(addTempMC.name);
					addTempMC.alpha=1;
					addTempMC.x=screenWidth / 2;
					addTempMC.y=screenHeight / 2;
					addTempMC.addChild(loadTempMC);
					
					var maskObj:Sprite=new Sprite();
					//maskObj.width=screenWidth;
					//maskObj.height=screenHeight;
					maskObj.name="PIC_MASK";
					maskObj.x=0;
					maskObj.y=0;
					setMaskMotion();
					addTempMC.mask=maskObj;
					removeObj("tarImgs");
					_tool=new toolbarUI();
					_tool.alpha=0;
					_tool.name="tool";
					_tool.x=(screenWidth-_tool.width)/2;
					_tool.y=screenHeight-_tool.height-1;
					_tool.mouseChildren=false;
					_tool.addEventListener(Event.ENTER_FRAME,showAlphaInAndsetAtt);
					addChild(addTempMC);
					addChild(maskObj);
					addChild(_tool);
					break;
				case 3 :
					break;
				case StaticVars.SYSTEM_LOAD_ERROR :
					removeObj("tarImgs");
					var loadErr:loadErrorUI=new loadErrorUI();
					loadErr.name="loadErrView";
					loadErr.x=screenWidth / 2;
					loadErr.y=screenHeight / 2;
					addChild(loadErr);
					var Time:Timer=new Timer(3000,1);
					Time.addEventListener(TimerEvent.TIMER,removeLoadErr);
					Time.start();
					break;
			}
		}
		
		///////////////////////////////////////////////////开始预载下一张图片//////////////////////////////////////////////////////////////////////////////////////////
		private function setMaskMotion():void {
			maskMotion=int(Math.random()*4);
			//maskMotion=2;
			//trace(maskMotion);
			maskTimer=new Timer(30,_rowsNumber*_colsNumber);
			maskTimer.addEventListener(TimerEvent.TIMER,addTempMask);
			maskTimer.start();
		}
		
		private function addTempMask(e:TimerEvent):void
		{
			//trace(maskMotion);
			var n:uint=e.target.currentCount%3;
			var tempMask:MovieClip=new MovieClip();
			tempMask.graphics.beginFill(0xE60000,1);
			if (maskMotion==0) {
				tempMask.graphics.drawRect(-1,0,1,1);
			} else if (maskMotion==1) {
				tempMask.graphics.drawCircle(-.6,.1,1);
			} else if (maskMotion==2) {
				tempMask.graphics.drawRect(-1,-1,1,screenHeight);
			} else {
				tempMask.graphics.drawRect(-screenWidth/2,0,screenWidth,1);
			}
			tempMask.graphics.endFill();
			tempMask.id=e.target.currentCount;
			tempMask.name="m"+e.target.currentCount;
			if (e.target.currentCount%_rowsNumber!=0) {
				tempMask.x=(screenWidth/_rowsNumber)*(e.target.currentCount%_rowsNumber)-(_changeRows-screenHeight/_colsNumber);
			} else {
				tempMask.x=(screenWidth/_rowsNumber)*_rowsNumber-(_changeRows-screenHeight/_colsNumber);
			}
			if (e.target.currentCount%_rowsNumber==1) {
				_changeRows++;
			}
			tempMask.y=(screenHeight/_colsNumber)*_changeRows-screenHeight/_colsNumber;
			Sprite(getChildByName("PIC_MASK")).addChild(tempMask);
			tempMask.addEventListener(Event.ENTER_FRAME,setMaskWidthAndHeight);
		}
		
		private function setMaskWidthAndHeight(e:Event):void {
			switch (maskMotion) {
				case 0 :
					if (e.target.width<=screenWidth/_rowsNumber*2) {
						e.target.width+=screenWidth/(_rowsNumber*_addStep);
						e.target.height+=screenHeight/(_colsNumber*_addStep);
					} else {
						e.target.removeEventListener(Event.ENTER_FRAME,setMaskWidthAndHeight);
						if (e.target.id>=_rowsNumber*_colsNumber) {
							//trace("最后一个遮罩完成!");
							_changeRows=0;
							if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
								if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
									getChildByName("PIC_TOP").mask=null;
									removeObj("PIC_BOOT");
								} else {
									getChildByName("PIC_BOOT").mask=null;
									removeObj("PIC_TOP");
								}
							} else if (getChildByName("PIC_TOP")) {
								getChildByName("PIC_TOP").mask=null;
							} else {
								getChildByName("PIC_BOOT").mask=null;
							}
							removeObj("PIC_MASK");
							_tool.mouseChildren=true;
						}
					}
					break;
				case 1 :
					if (e.target.width<=screenWidth/_rowsNumber*2) {
						e.target.width+=screenWidth/(_rowsNumber*_addStep);
						e.target.height+=screenHeight/(_colsNumber*_addStep);
					} else {
						e.target.removeEventListener(Event.ENTER_FRAME,setMaskWidthAndHeight);
						if (e.target.id>=_rowsNumber*_colsNumber) {
							//trace("最后一个遮罩完成!");
							_changeRows=0;
							if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
								if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
									getChildByName("PIC_TOP").mask=null;
									removeObj("PIC_BOOT");
								} else {
									getChildByName("PIC_BOOT").mask=null;
									removeObj("PIC_TOP");
								}
							} else if (getChildByName("PIC_TOP")) {
								getChildByName("PIC_TOP").mask=null;
							} else {
								getChildByName("PIC_BOOT").mask=null;
							}
							removeObj("PIC_MASK");
							_tool.mouseChildren=true;
						}
					}
					break;
				case 2 :
					if (e.target.width<=screenWidth/_rowsNumber*2) {
						e.target.width+=screenWidth/(_rowsNumber*_addStep);
						e.target.height+=screenHeight/(_colsNumber*_addStep);
					} else {
						e.target.removeEventListener(Event.ENTER_FRAME,setMaskWidthAndHeight);
						if (e.target.id>=_rowsNumber*_colsNumber) {
							//trace("最后一个遮罩完成!");
							_changeRows=0;
							if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
								if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
									getChildByName("PIC_TOP").mask=null;
									removeObj("PIC_BOOT");
								} else {
									getChildByName("PIC_BOOT").mask=null;
									removeObj("PIC_TOP");
								}
							} else if (getChildByName("PIC_TOP")) {
								getChildByName("PIC_TOP").mask=null;
							} else {
								getChildByName("PIC_BOOT").mask=null;
							}
							removeObj("PIC_MASK");
							_tool.mouseChildren=true;
						}
					}
					break;
				case 3 :
					if (e.target.height<=screenHeight/_colsNumber*2) {
						//e.target.width+=screenWidth/(_rowsNumber*_addStep);
						e.target.height+=screenHeight/(_colsNumber*_addStep);
					} else {
						e.target.removeEventListener(Event.ENTER_FRAME,setMaskWidthAndHeight);
						if (e.target.id>=_rowsNumber*_colsNumber) {
							//trace("最后一个遮罩完成!");
							_changeRows=0;
							if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
								if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
									getChildByName("PIC_TOP").mask=null;
									removeObj("PIC_BOOT");
								} else {
									getChildByName("PIC_BOOT").mask=null;
									removeObj("PIC_TOP");
								}
							} else if (getChildByName("PIC_TOP")) {
								getChildByName("PIC_TOP").mask=null;
							} else {
								getChildByName("PIC_BOOT").mask=null;
							}
							removeObj("PIC_MASK");
							_tool.mouseChildren=true;
						}
					}
					break;
			}
		}
		
		///////////////////////////////////////////////////开始预载下一张图片/////////////////////////////////////////////////////////////////////////////////////////////////
		private function setTool(Obj:MovieClip):void {
			for (var j:int=0; j<Obj.numChildren; j++) {
				var tempObj:Object=Obj.getChildAt(j);
				if (tempObj is MovieClip) {
					tempObj.buttonMode=true;
					tempObj.mouseChildren=false;
					tempObj.addEventListener(MouseEvent.CLICK,getTargetEvent);
					tempObj.addEventListener(MouseEvent.MOUSE_OVER,setFilters);
					tempObj.addEventListener(MouseEvent.MOUSE_OUT,clearFilters);
				}
			}
		}
		
		private function setFilters(e:MouseEvent):void {
			//trace(e.currentTarget.name);
			
			var colorI:ColorTransform=new ColorTransform();
			colorI.color =0xE60000;
			var _bl:BlurFilter=new BlurFilter(3,3,3);
			e.currentTarget.bg.filters = [_bl];
			//e.currentTarget.bg.scaleX=1.5;
			e.currentTarget.bg.transform.colorTransform=colorI;
		}
		
		private function clearFilters(e:MouseEvent):void {
			trace(e.currentTarget.name);
			var colorI:ColorTransform=new ColorTransform();
			colorI.color =0x000000;
			var _bl:BlurFilter=new BlurFilter(0,0,1);
			e.currentTarget.bg.filters = [_bl];
			//e.currentTarget.bg.scaleX=1;
			e.currentTarget.bg.transform.colorTransform=colorI;
		}
		
		private function getTargetEvent(e:MouseEvent):void
		{
			var str:String=e.target.name;
			//trace(str,targetImg,CURRENT_NUMBER,"选择开始");
			_current_number=1;
			switch (str) {
				case "f1" :
					if (targetImg!=0) {
						targetImg=0;
						maskTimer.reset();
						maskTimer.stop();
						if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
							if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
								getChildByName("PIC_TOP").mask=null;
								removeObj("PIC_BOOT");
							} else {
								getChildByName("PIC_BOOT").mask=null;
								removeObj("PIC_TOP");
							}
						} else if (getChildByName("PIC_TOP")) {
							getChildByName("PIC_TOP").mask=null;
						} else {
							getChildByName("PIC_BOOT").mask=null;
						}
						removeObj("PIC_MASK");
						dispatchEvent(new CurStateEvent( CurStateEvent.Current_Id,_current_number));
					}
					break;
				case "f2" :
					if (targetImg>=1) {
						targetImg--;
						maskTimer.reset();
						maskTimer.stop();
						if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
							if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
								getChildByName("PIC_TOP").mask=null;
								removeObj("PIC_BOOT");
							} else {
								getChildByName("PIC_BOOT").mask=null;
								removeObj("PIC_TOP");
							}
						} else if (getChildByName("PIC_TOP")) {
							getChildByName("PIC_TOP").mask=null;
						} else {
							getChildByName("PIC_BOOT").mask=null;
						}
						removeObj("PIC_MASK");
						dispatchEvent(new CurStateEvent( CurStateEvent.Current_Id, _current_number));
					}
					break;
				case "f3" :
					if (targetImg<totalImg-1) {
						//trace(targetImg);
						targetImg++;
						maskTimer.reset();
						maskTimer.stop();
						if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
							if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
								getChildByName("PIC_TOP").mask=null;
								removeObj("PIC_BOOT");
							} else {
								getChildByName("PIC_BOOT").mask=null;
								removeObj("PIC_TOP");
							}
						} else if (getChildByName("PIC_TOP")) {
							getChildByName("PIC_TOP").mask=null;
						} else {
							getChildByName("PIC_BOOT").mask=null;
						}
						removeObj("PIC_MASK");
						dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_current_number));
						//trace(targetImg);
					}
					break;
				case "f4" :
					if (targetImg<totalImg-1) {
						targetImg=totalImg-1;
						maskTimer.reset();
						maskTimer.stop();
						if (getChildByName("PIC_TOP")&&getChildByName("PIC_BOOT")) {
							if (getChildIndex(getChildByName("PIC_TOP"))>getChildIndex(getChildByName("PIC_BOOT"))) {
								getChildByName("PIC_TOP").mask=null;
								removeObj("PIC_BOOT");
							} else {
								getChildByName("PIC_BOOT").mask=null;
								removeObj("PIC_TOP");
							}
						} else if (getChildByName("PIC_TOP")) {
							getChildByName("PIC_TOP").mask=null;
						} else {
							getChildByName("PIC_BOOT").mask=null;
						}
						removeObj("PIC_MASK");
						dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_current_number));
					}
					break;
				case "f5" :
					if (getChildByName("PIC_TOP")) {
						if (getChildByName("PIC_TOP")) {
							if (getChildByName("PIC_TOP").scaleX<=2.9) {
								getChildByName("PIC_TOP").scaleX+=.1;
								getChildByName("PIC_TOP").scaleY=getChildByName("PIC_TOP").scaleX;
							}
						}
					}
					if (getChildByName("PIC_BOOT")) {
						if (getChildByName("PIC_BOOT")) {
							if (getChildByName("PIC_BOOT").scaleX<=2.9) {
								getChildByName("PIC_BOOT").scaleX+=.1;
								getChildByName("PIC_BOOT").scaleY=getChildByName("PIC_BOOT").scaleX;
							}
						}
					}
					break;
				case "f6" :
					if (getChildByName("PIC_TOP")) {
						if (getChildByName("PIC_TOP").scaleX>.4) {
							getChildByName("PIC_TOP").scaleX-=.1;
							getChildByName("PIC_TOP").scaleY=getChildByName("PIC_TOP").scaleX;
						}
					}
					if (getChildByName("PIC_BOOT")) {
						if (getChildByName("PIC_BOOT").scaleX>.4) {
							getChildByName("PIC_BOOT").scaleX-=.1;
							getChildByName("PIC_BOOT").scaleY=getChildByName("PIC_BOOT").scaleX;
						}
					}
					break;
				case "f7" :
					setFull(str);
					break;
				case "f8" :
					if (getChildByName("PIC_BOOT")) {
						MovieClip(getChildByName("PIC_BOOT")).buttonMode=true;
						MovieClip(getChildByName("PIC_BOOT")).addEventListener(MouseEvent.MOUSE_DOWN,startD);
						MovieClip(getChildByName("PIC_BOOT")).addEventListener(MouseEvent.MOUSE_UP,stopD);
					} else {
						MovieClip(getChildByName("PIC_TOP")).buttonMode=true;
						MovieClip(getChildByName("PIC_TOP")).addEventListener(MouseEvent.MOUSE_DOWN,startD);
						MovieClip(getChildByName("PIC_TOP")).addEventListener(MouseEvent.MOUSE_UP,stopD);
					}
					break;
			}
		}
		
		///////////////////////////////////////////////////释放拖动////////////////////////////////////////////////////////////////////////////////////////////////
		private function stopD(e:MouseEvent) :void
		{
			e.target.stopDrag();
		}
		
		private function startD(e:MouseEvent):void
		{
			e.target.startDrag(false,new Rectangle(-screenWidth,-screenHeight,screenWidth*2,screenHeight*2));
		}
		
		///////////////////////////////////////////////////开始预载下一张图片///////////////////////////////////////////////////////////////////////////////////////////////
		private function getNextImg(e:MouseEvent):void
		{
			if (targetImg < totalImg - 1) {
				targetImg++;
			} else {
				targetImg=0;
			}
			_current_number=1;
			dispatchEvent(new CurStateEvent( CurStateEvent.Current_Id,_current_number));
		}
		///////////////////////////////////////////////////初始化图片路径数组/////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function initImgArray():void
		{
			if (ExternalInterface.available) {
				_messArray=ExternalInterface.call("photoPath");
				totalImg=_messArray.length;
				targetImg=0;
				_current_number=0;
				//navigateToURL(new URLRequest(_messArray[0]+"?"+_messArray[0]),"_blank");
				dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_current_number));
			} else {
				_current_number=100;
				dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_current_number));
			}
		}
		///////////////////////////////////进入全屏，退出全屏////////////////////////////
		
		private function setFull(s:String):void
		{
			if (MovieClip(getChildByName("tool")).getChildByName(s).stage.displayState == StageDisplayState.NORMAL) {
				MovieClip(getChildByName("tool")).getChildByName(s).stage.displayState=StageDisplayState.FULL_SCREEN;
				//MovieClip(getChildByName("tool")).f7.gotoAndStop(2);
			} else {
				MovieClip(getChildByName("tool")).getChildByName(s).stage.displayState=StageDisplayState.NORMAL;
				//MovieClip(getChildByName("tool")).f7.gotoAndStop(1);
			}
		}
		///////////////////////////////////重置对象的舞台位置///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function resizeStage(e:Event):void
		{
			screenWidth=stage.stageWidth;
			screenHeight=stage.stageHeight;
			//重新绘制头部背景////
			if (getChildByName("tarImgs")) {
				getChildByName("tarImgs").x=screenWidth / 2;
				getChildByName("tarImgs").y=screenHeight / 2;
			}
			if (getChildByName("loadErrView")) {
				getChildByName("loadErrView").x=screenWidth / 2;
				getChildByName("loadErrView").y=screenHeight / 2;
			}
			if (getChildByName("tool")) {
				getChildByName("tool").x=(screenWidth-getChildByName("tool").width)/2;
				getChildByName("tool").y=screenHeight-getChildByName("tool").height-1;
			}
			if (getChildByName("PIC_BOOT")) {
				if (getChildByName("PIC_BOOT").width/getChildByName("PIC_BOOT").height>=screenWidth/screenHeight) {
					//addTempMC.width=screenWidth;
					setWH=getChildByName("PIC_BOOT").height/screenHeight;
					getChildByName("PIC_BOOT").height=screenHeight;
					getChildByName("PIC_BOOT").width=getChildByName("PIC_BOOT").width/setWH;
				} else {
					setWH=getChildByName("PIC_BOOT").width/screenWidth;
					getChildByName("PIC_BOOT").width=screenWidth;
					getChildByName("PIC_BOOT").height=getChildByName("PIC_BOOT").height/setWH;
				}
				getChildByName("PIC_BOOT").x=screenWidth/2;
				getChildByName("PIC_BOOT").y=screenHeight/2;
				
			}
			if (getChildByName("PIC_TOP")) {
				if (getChildByName("PIC_TOP").width/getChildByName("PIC_TOP").height>=screenWidth/screenHeight) {
					//addTempMC.width=screenWidth;
					setWH=getChildByName("PIC_TOP").height/screenHeight;
					getChildByName("PIC_TOP").height=screenHeight;
					getChildByName("PIC_TOP").width=getChildByName("PIC_TOP").width/setWH;
				} else {
					setWH=getChildByName("PIC_TOP").width/screenWidth;
					getChildByName("PIC_TOP").width=screenWidth;
					getChildByName("PIC_TOP").height=getChildByName("PIC_TOP").height/setWH;
				}
				getChildByName("PIC_TOP").x=screenWidth/2;
				getChildByName("PIC_TOP").y=screenHeight/2;
				
			}
			if (getChildByName("PIC_MASK")) {
				getChildByName("PIC_MASK").height=screenHeight;
				getChildByName("PIC_MASK").width=screenWidth;
				for (var i:int=1; i<=_rowsNumber*_colsNumber; i++) {
					var nn:uint=0;
					if (Sprite(getChildByName("PIC_MASK")).getChildByName("m"+i)) {
						var obj:Object=Sprite(getChildByName("PIC_MASK")).getChildByName("m"+i);
						if (obj.width>=screenWidth/_rowsNumber) {
							if (i%_rowsNumber!=0) {
								obj.x=(screenWidth/_rowsNumber)*(i%_rowsNumber)-(screenWidth/_rowsNumber)/2;
							} else {
								obj.x=(screenWidth/_rowsNumber)*_rowsNumber-(screenWidth/_rowsNumber)/2;
							}
							if (i%_rowsNumber==1) {
								nn++;
								//trace(_changeRows);
							}
							obj.y=(screenHeight/_colsNumber)*nn-(screenHeight/_colsNumber)/2;
						}
					}
				}
				//nn=0;
				//getChildByName("PIC_MASK").x=0;
				//getChildByName("PIC_MASK").y=0;
			}
		}
		
		///////////////////////////////////删除舞台中的对象//////////////////////////////////////////////////////////////////////////////////////////////////////
		private function removeObj(s:String):void {
			if (getChildByName(s)) {
				removeChild(getChildByName(s));
			}
		}
		
		//////////////////////////////////////////////////////////////////////全局透明函数增加函数。//////////////////////////////////////////////////////////////////////
		private function showAlphaIn(e:Event):void {
			if (e.target.alpha < 1) {
				e.target.alpha+= StaticVars.SYSTEM_ALPHA_IN;
			} else {
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,showAlphaIn);
			}
		}
		
		//////////////////////////////////////////////////////////////////////全局透明函数减少并删除显示对象本身函数。//////////////////////////////////////////////////////////////////////
		private function showAlphaInAndsetAtt(e:Event):void {
			if (e.target.alpha < 1) {
				e.target.alpha+= StaticVars.SYSTEM_ALPHA_IN;
			} else {
				e.target.alpha=1;
				setTool(MovieClip(e.target));
				e.target.removeEventListener(Event.ENTER_FRAME,showAlphaInAndsetAtt);
			}
		}
		
		//////////////////////////////////////////////////////////////////////移除加载错误显示//////////////////////////////////////////////////////////////////////
		private function removeLoadErr(e:TimerEvent):void
		{
			removeObj("loadErrView");
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}