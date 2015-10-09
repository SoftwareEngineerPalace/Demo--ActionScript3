package proto.login {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class UserInfoRequest extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const APPID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoRequest.appID", "appID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var appID:int;

		/**
		 *  @private
		 */
		public static const HASH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("proto.login.UserInfoRequest.hash", "hash", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var hash:String;

		/**
		 *  @private
		 */
		public static const SP:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("proto.login.UserInfoRequest.sp", "sp", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var sp:String;

		/**
		 *  @private
		 */
		public static const ROLENAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("proto.login.UserInfoRequest.roleName", "roleName", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var roleName$field:String;

		public function clearRoleName():void {
			roleName$field = null;
		}

		public function get hasRoleName():Boolean {
			return roleName$field != null;
		}

		public function set roleName(value:String):void {
			roleName$field = value;
		}

		public function get roleName():String {
			return roleName$field;
		}

		/**
		 *  @private
		 */
		public static const ROLETYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoRequest.roleType", "roleType", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var roleType$field:int;

		private var hasField$0:uint = 0;

		public function clearRoleType():void {
			hasField$0 &= 0xfffffffe;
			roleType$field = new int();
		}

		public function get hasRoleType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set roleType(value:int):void {
			hasField$0 |= 0x1;
			roleType$field = value;
		}

		public function get roleType():int {
			return roleType$field;
		}

		/**
		 *  @private
		 */
		public static const SEX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoRequest.sex", "sex", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sex$field:int;

		public function clearSex():void {
			hasField$0 &= 0xfffffffd;
			sex$field = new int();
		}

		public function get hasSex():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set sex(value:int):void {
			hasField$0 |= 0x2;
			sex$field = value;
		}

		public function get sex():int {
			return sex$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.appID);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.hash);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.sp);
			if (hasRoleName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, roleName$field);
			}
			if (hasRoleType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, roleType$field);
			}
			if (hasSex) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sex$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var appID$count:uint = 0;
			var hash$count:uint = 0;
			var sp$count:uint = 0;
			var roleName$count:uint = 0;
			var roleType$count:uint = 0;
			var sex$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (appID$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoRequest.appID cannot be set twice.');
					}
					++appID$count;
					this.appID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (hash$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoRequest.hash cannot be set twice.');
					}
					++hash$count;
					this.hash = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (sp$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoRequest.sp cannot be set twice.');
					}
					++sp$count;
					this.sp = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (roleName$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoRequest.roleName cannot be set twice.');
					}
					++roleName$count;
					this.roleName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (roleType$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoRequest.roleType cannot be set twice.');
					}
					++roleType$count;
					this.roleType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (sex$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoRequest.sex cannot be set twice.');
					}
					++sex$count;
					this.sex = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
