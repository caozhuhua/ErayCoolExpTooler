package com.coolexp.manager
{
	import com.coolexp.vo.BaseFileVO;
	import com.coolexp.vo.FileTypeVO;
	import com.coolexp.vo.GroupFileVO;
	import com.coolexp.vo.SimpleFileVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	
	public class AnimationPackager extends EventDispatcher
	{
		private static var _instance:AnimationPackager;
		private var pckType:int;
		private var isDel:Boolean;
		public var fileId:int = 10001;
		public function AnimationPackager(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():AnimationPackager{
			if(!_instance){
				_instance = new AnimationPackager();
			}
			return _instance;
		}
		private var _file:File;
		/**
		 * 
		 * @param file
		 * @param type 1，打包单个，2，打包多个
		 * @param isDeleteOriginal
		 * 
		 */		
		public function packAnimationFile(file:File,type:int,isDeleteOriginal:Boolean):void{
			pckType = type;
			isDel = isDeleteOriginal;
			var isPack:Boolean = false;
			if(pckType==1){
				var prefixPath:String = file.nativePath.replace(file.name, "");
				var prefixName:String = file.name.replace(file.type, "");
				var ff:File = new File(prefixPath+prefixName+ERAYSWF_DAT);
				if(ff.exists){
					_file = file;
					Alert.show("是否要替换已经存在的文件"+prefixName,"提示",Alert.YES|Alert.NO,null,confirmOvertHandler);
				}else{
					packOneFile(file);
				}
//				isPack = analyseFile(file);
//				if(isPack){
//					Alert.show("打包成功");
//				}
			}else{
				var b:Array = [];
				analyseDic(file,b);
				var f:File;
				for(var i:int = 0,l:int = b.length;i<l;++i){
					f = b[i];
					isPack = analyseFile(f);
					if(!isPack){
						return;
					}
				}
				Alert.show("打包成功");
			}
//			Alert.show("打包成功");
		}
		private function confirmOvertHandler(e:CloseEvent):void{
			if(e.detail==Alert.YES){
				packOneFile(_file);
			}
		}
		private function packOneFile(file:File):void{
			var isPack:Boolean = false;
			isPack = analyseFile(file);
			_file = null;
			if(isPack){
				Alert.show("打包成功");
			}
		}
		private function analyseFile(file:File):Boolean{
			var prefixPath:String = file.nativePath.replace(file.name, "");
			var prefixName:String = file.name.replace(file.type, "");
			var xmlFile:File = new File(((prefixPath + prefixName) + ".xml"));
			if(xmlFile.exists){
				var swfBa:ByteArray = FilePackManager.getInstance().getFileData(file);
				var xmlBa:ByteArray = FilePackManager.getInstance().getFileData(xmlFile);
				if(isDel){
					file.deleteFile();
					xmlFile.deleteFile();
				}
				saveAnimationFile(prefixPath,prefixName,swfBa,xmlBa);
			}else{
				Alert.show(prefixName+".xml文件不存在");
				return false;
			}
			return true;
		}
		private function saveAnimationFile(prefixPath:String,fileName:String,swfData:ByteArray,xmlData:ByteArray):void{
//			var fileType:int = ba.readUnsignedInt();
//			var fileId:int = ba.readUnsignedInt();
//			var fileName:String = ba.readUTF();
//			var isGroup:int = ba.readUnsignedInt();
			
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(FileTypeVO.ANI_2_TYPE);
			ba.writeUnsignedInt(this.fileId++);
			ba.writeUTF(fileName+".erayswf");
			ba.writeUnsignedInt(2);
			ba.writeUnsignedInt(2);
			
			var xmlFileBa:ByteArray = encodeFile(xmlData,5,this.fileId++,fileName+".xml",1);
			var swfFileBa:ByteArray = encodeFile(swfData,1,this.fileId++,fileName+".swf",1);
			ba.writeUnsignedInt(xmlFileBa.length);
			ba.writeBytes(xmlFileBa);
			ba.writeUnsignedInt(swfFileBa.length);
			ba.writeBytes(swfFileBa);
			
			var fileBa:ByteArray = new ByteArray();
			fileBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			fileBa.writeUnsignedInt(ba.length);
			fileBa.writeBytes(ba);
			
			var file:File = new File(prefixPath+fileName+ERAYSWF_DAT);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(fileBa);
			fs.close();
		}
		private static const ERAYSWF_DAT:String = ".erayswf.dat";
		private static const ERAY_BITMAP_SWF_DAT:String = ".eraybitmapswf.dat";
		private function encodeFile(byteArray:ByteArray,fileType:int,fileId:int,fileName:String,isGroup:int,compress:int = 2,compressType:int=0,groupType:int = 1):ByteArray{
			byteArray.position = 0;
			if(byteArray.position>BaseFileVO.fileHeadStrLength){
				var fileHeadString:String = ba.readUTFBytes(BaseFileVO.fileHeadStrLength);
				if(fileHeadString==BaseFileVO.FILE_HEAD_STR){
					return byteArray;
				}
			}
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(fileType);
			ba.writeUnsignedInt(fileId);
			ba.writeUTF(fileName);
			ba.writeUnsignedInt(isGroup);
			ba.writeUnsignedInt(compress);
			ba.writeUnsignedInt(compressType);
			ba.writeUnsignedInt(groupType);
			ba.writeBytes(byteArray);
			
			var fileBa:ByteArray = new ByteArray();
			fileBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			fileBa.writeUnsignedInt(ba.length);
			fileBa.writeBytes(ba);
			return fileBa;
		}
									
	
		private function analyseDic(file:File,a:Array):void{
			var b:Array = file.getDirectoryListing();
			var f:File;
			for(var i:int = 0,l:int = b.length;i<l;++i){
				f = b[i];
				if(f.isDirectory){
					analyseDic(f,a);
				}else{
					if(f.extension.indexOf("swf")>=0){
						a.push(f);
					}
				}
				
			}
		}
		private var isHerit:Boolean;
		public function packNewAnimation(file:File,type:int,_isHerit:Boolean = true):void{
			if(type==1){
				isHerit = _isHerit;
				readXMLFile(file);
			}
		}
		private function getOldAnimationFileXML(basePath:String,prefix:String):Object{
			var file:File = new File(basePath+prefix+ERAYSWF_DAT);
			if(file.exists){
				var ba:ByteArray = FilePackManager.getInstance().getFileData(file);
				var fileVO:BaseFileVO = BaseFileVO.parse(ba);
				if(fileVO.isGroup==2){
					var g:GroupFileVO = GroupFileVO(fileVO);
					var a:Array = g.fileList;
					for(var i:int = 0,l:int = a.length;i<l;++i){
						var simpleFileVO:SimpleFileVO = a[i];
						if(simpleFileVO.fileType==5){
							var xml:XML = new XML(simpleFileVO.fileBa.toString());
							return xml;
						}
					}
					LogManager.getInstance().log(basePath+prefix+"旧的动画文件没有XML文件");
					return null;
				}else{
					LogManager.getInstance().log(basePath+prefix+"旧的动画文件是错误的格式");
					return null;
				}
			}else{
				LogManager.getInstance().log(basePath+prefix+"旧的动画文件不存在");
			}
			return null;
		}
		public static const NODE_XML_EXT:String = ".xml.dat";
		private function readXMLFile(file:File):void{
			var ba:ByteArray = FilePackManager.getInstance().getFileData(file);
			var xml:XML = new XML(ba.toString());
			var prefix:String = file.name.replace(NODE_XML_EXT,"").replace("_node","");
			var basePath:String = file.nativePath.replace(file.name,"");
			var xmlFileList:Array = getXMLFileList(xml);
			var rootXML:XML = new XML("<textures></textures>");
			var nodes:XML = new XML("<nodes></nodes>");
			var isError:Boolean = false;
			for(var i:int = 0,l:int = xmlFileList.length;i<l;i++){
				var val:String = basePath+prefix+"_"+xmlFileList[i]
				var f:File = new File(val+".xml");
				if(f.exists){
					var x:XML = new XML(FilePackManager.getInstance().getFileData(f).toString());
					rootXML.appendChild(x);
				}else{
					isError = true;
					LogManager.getInstance().log(val+"没有打包");
					break;
				}
			}
			if(!isError){
				var root:XML = new XML('<root type="10" name="'+prefix+'"></root>');
				root.appendChild(rootXML);
				var offsetX:Number = 0,offsetY:Number = 0,offsetNAX:Number = 0,offsetNAY:Number =0 ;
				if(isHerit){
					var oldXML:XML = getOldAnimationFileXML(basePath,prefix) as XML;
					if(oldXML){
						var rootName:String = oldXML.name();
						//1,effect 0,人物动画
						var isEffect:int = 0;
						if(rootName=="TextureAtlas"){
							isEffect = 1;
						}else{
							isEffect = 0;
						}
						if(isEffect==1){
							offsetX = oldXML.@offsetX;
							offsetY = oldXML.@offsetY;
							offsetNAX = oldXML.@offsetNaX;
							offsetNAY = oldXML.@offsetNaY;
						}else{
							offsetX = oldXML.TextureAtlas.@offsetX;
							offsetY = oldXML.TextureAtlas.@offsetY;
							if(oldXML.nodes){
								root.appendChild(oldXML.nodes);
								offsetNAX = oldXML.TextureAtlas.@offsetNaX;
								offsetNAY = oldXML.TextureAtlas.@offsetNaY;
							}
						}
						
					}else{
						LogManager.getInstance().log(basePath+prefix+".eraybitmapswf.dat没有生成");
						return;
					}
				}else{
					nodes = createNewNodesXML(xml,nodes);
					root.appendChild(nodes);
				}
				var pairXML:XML = new XML("<pair></pair>");
				pairXML = createPairXML(xml,pairXML);
				root.appendChild(pairXML);
				var info:XML = new XML('<animation isEffect="'+isEffect+'" offsetX="'+offsetX+'" offsetY="'+offsetY+'" offsetNaX="'+offsetNAX+'" offsetNaY="'+offsetNAY+'"></animation>');
				root.appendChild(info);
				var totalXMLBa:ByteArray = new ByteArray();
				totalXMLBa.writeMultiByte(root.toString(),"utf-8");
				FilePackManager.getInstance().saveFile(basePath+prefix+"_pngs.xml",totalXMLBa);
				var swfFile:File = new File(basePath+prefix+"_pngs.swf");
				if(swfFile.exists){
					var swfByte:ByteArray = FilePackManager.getInstance().getFileData(swfFile);
					saveBitmapSWFFile(basePath,prefix,totalXMLBa,swfByte);
				}else{
					LogManager.getInstance().log(basePath+prefix+"_pngs"+".swf没有生成");
				}
			}else{
				LogManager.getInstance().log(basePath+prefix+".eraybitmapswf.dat没有生成");
			}
		}
		private function createPairXML(xml:XML,node:XML):XML{
			for each(var n:XML in xml.children()){
				var na:String = n.@name;
				node.appendChild(n);
			}
			return node;
		}
		private function createNewNodesXML(xml:XML,node:XML):XML{
			for each(var n:XML in xml.children()){
				var na:String = n.@name;
				var x:XML = new XML('<node blood="" key="'+na+'"/>');
				node.appendChild(x);
			}
			return node;
		}
		private function saveBitmapSWFFile(basePath:String,prefix:String,xmlData:ByteArray,swfData:ByteArray):void{
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(FileTypeVO.ANI_3_TYPE);
			ba.writeUnsignedInt(this.fileId++);
			ba.writeUTF(prefix+".eraybitmapswf");
			ba.writeUnsignedInt(2);
			ba.writeUnsignedInt(2);
			
			var xmlFileBa:ByteArray = encodeFile(xmlData,5,this.fileId++,prefix+"_pngs.xml",1);
			var swfFileBa:ByteArray = encodeFile(swfData,1,this.fileId++,prefix+"_pngs.swf",1);
			ba.writeUnsignedInt(xmlFileBa.length);
			ba.writeBytes(xmlFileBa);
			ba.writeUnsignedInt(swfFileBa.length);
			ba.writeBytes(swfFileBa);
			
			var fileBa:ByteArray = new ByteArray();
			fileBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			fileBa.writeUnsignedInt(ba.length);
			fileBa.writeBytes(ba);
			
			var file:File = new File(basePath+prefix+ERAY_BITMAP_SWF_DAT);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(fileBa);
			fs.close();
		}
		
		private function getXMLFileList(xml:XML):Array{
			var a:Array = [];
			for each(var node:XML in xml.children()){
				var cls:String = node.@cls;
				if(a.indexOf(cls)<0){
					a.push(cls);
				}
			}
			return a;
		}
		
	}
}