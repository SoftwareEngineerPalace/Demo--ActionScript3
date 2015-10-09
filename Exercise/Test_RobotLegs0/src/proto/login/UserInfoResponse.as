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
	public dynamic final class UserInfoResponse extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROLEID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("proto.login.UserInfoResponse.roleID", "roleID", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var roleID:String;

		/**
		 *  @private
		 */
		public static const ROLENAME:FieldDescriptor$TYPE_STRIN = new FieldDescriptor$TYPE_STRING("proto.login.UserInfoResponse.roleName", "roleName", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

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
		public static const PTID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("proto.login.UserInfoResponse.ptID", "ptID", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var ptID$field:String;

		public function clearPtID():void {
			ptID$field = null;
		}

		public function get hasPtID():Boolean {
			return ptID$field != null;
		}

		public function set ptID(value:String):void {
			ptID$field = value;
		}

		public function get ptID():String {
			return ptID$field;
		}

		/**
		 *  @private
		 */
		public static const SEX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.sex", "sex", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sex$field:int;

		private var hasField$0:uint = 0;

		public function clearSex():void {
			hasField$0 &= 0xfffffffe;
			sex$field = new int();
		}

		public function get hasSex():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set sex(value:int):void {
			hasField$0 |= 0x1;
			sex$field = value;
		}

		public function get sex():int {
			return sex$field;
		}

		/**
		 *  @private
		 */
		public static const ROLETYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.roleType", "roleType", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var roleType$field:int;

		public function clearRoleType():void {
			hasField$0 &= 0xfffffffd;
			roleType$field = new int();
		}

		public function get hasRoleType():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set roleType(value:int):void {
			hasField$0 |= 0x2;
			roleType$field = value;
		}

		public function get roleType():int {
			return roleType$field;
		}

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.level", "level", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:int;

		public function clearLevel():void {
			hasField$0 &= 0xfffffffb;
			level$field = new int();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set level(value:int):void {
			hasField$0 |= 0x4;
			level$field = value;
		}

		public function get level():int {
			return level$field;
		}

		/**
		 *  @private
		 */
		public static const EXPERIENCE:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("proto.login.UserInfoResponse.experience", "experience", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var experience$field:Int64;

		public function clearExperience():void {
			experience$field = null;
		}

		public function get hasExperience():Boolean {
			return experience$field != null;
		}

		public function set experience(value:Int64):void {
			experience$field = value;
		}

		public function get experience():Int64 {
			return experience$field;
		}

		/**
		 *  @private
		 */
		public static const GOLD:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("proto.login.UserInfoResponse.gold", "gold", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gold$field:uint;

		public function clearGold():void {
			hasField$0 &= 0xfffffff7;
			gold$field = new uint();
		}

		public function get hasGold():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set gold(value:uint):void {
			hasField$0 |= 0x8;
			gold$field = value;
		}

		public function get gold():uint {
			return gold$field;
		}

		/**
		 *  @private
		 */
		public static const COPPER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("proto.login.UserInfoResponse.copper", "copper", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var copper$field:uint;

		public function clearCopper():void {
			hasField$0 &= 0xffffffef;
			copper$field = new uint();
		}

		public function get hasCopper():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set copper(value:uint):void {
			hasField$0 |= 0x10;
			copper$field = value;
		}

		public function get copper():uint {
			return copper$field;
		}

		/**
		 *  @private
		 */
		public static const FORMATIONID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("proto.login.UserInfoResponse.formationId", "formationId", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var formationId$field:uint;

		public function clearFormationId():void {
			hasField$0 &= 0xffffffdf;
			formationId$field = new uint();
		}

		public function get hasFormationId():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set formationId(value:uint):void {
			hasField$0 |= 0x20;
			formationId$field = value;
		}

		public function get formationId():uint {
			return formationId$field;
		}

		/**
		 *  @private
		 */
		public static const VIPLEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.vipLevel", "vipLevel", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vipLevel$field:int;

		public function clearVipLevel():void {
			hasField$0 &= 0xffffffbf;
			vipLevel$field = new int();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set vipLevel(value:int):void {
			hasField$0 |= 0x40;
			vipLevel$field = value;
		}

		public function get vipLevel():int {
			return vipLevel$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYERCOMMANDERID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.playerCommanderId", "playerCommanderId", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var playerCommanderId$field:int;

		public function clearPlayerCommanderId():void {
			hasField$0 &= 0xffffff7f;
			playerCommanderId$field = new int();
		}

		public function get hasPlayerCommanderId():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set playerCommanderId(value:int):void {
			hasField$0 |= 0x80;
			playerCommanderId$field = value;
		}

		public function get playerCommanderId():int {
			return playerCommanderId$field;
		}

		/**
		 *  @private
		 */
		public static const ENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.energy", "energy", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var energy$field:int;

		public function clearEnergy():void {
			hasField$0 &= 0xfffffeff;
			energy$field = new int();
		}

		public function get hasEnergy():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set energy(value:int):void {
			hasField$0 |= 0x100;
			energy$field = value;
		}

		public function get energy():int {
			return energy$field;
		}

		/**
		 *  @private
		 */
		public static const TROOPSFIGHTVALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("proto.login.UserInfoResponse.troopsFightValue", "troopsFightValue", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var troopsFightValue$field:int;

		public function clearTroopsFightValue():void {
			hasField$0 &= 0xfffffdff;
			troopsFightValue$field = new int();
		}

		public function get hasTroopsFightValue():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set troopsFightValue(value:int):void {
			hasField$0 |= 0x200;
			troopsFightValue$field = value;
		}

		public function get troopsFightValue():int {
			return troopsFightValue$field;
		}

		/**
		 *  @private
		 */
		public static const ISFIRSTLOGIN:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("proto.login.UserInfoResponse.isFirstLogin", "isFirstLogin", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var isFirstLogin$field:Boolean;

		public function clearIsFirstLogin():void {
			hasField$0 &= 0xfffffbff;
			isFirstLogin$field = new Boolean();
		}

		public function get hasIsFirstLogin():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set isFirstLogin(value:Boolean):void {
			hasField$0 |= 0x400;
			isFirstLogin$field = value;
		}

		public function get isFirstLogin():Boolean {
			return isFirstLogin$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.roleID);
			if (hasRoleName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, roleName$field);
			}
			if (hasPtID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, ptID$field);
			}
			if (hasSex) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sex$field);
			}
			if (hasRoleType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, roleType$field);
			}
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, level$field);
			}
			if (hasExperience) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, experience$field);
			}
			if (hasGold) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, gold$field);
			}
			if (hasCopper) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, copper$field);
			}
			if (hasFormationId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, formationId$field);
			}
			if (hasVipLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vipLevel$field);
			}
			if (hasPlayerCommanderId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, playerCommanderId$field);
			}
			if (hasEnergy) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, energy$field);
			}
			if (hasTroopsFightValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, troopsFightValue$field);
			}
			if (hasIsFirstLogin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, isFirstLogin$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var roleID$count:uint = 0;
			var roleName$count:uint = 0;
			var ptID$count:uint = 0;
			var sex$count:uint = 0;
			var roleType$count:uint = 0;
			var level$count:uint = 0;
			var experience$count:uint = 0;
			var gold$count:uint = 0;
			var copper$count:uint = 0;
			var formationId$count:uint = 0;
			var vipLevel$count:uint = 0;
			var playerCommanderId$count:uint = 0;
			var energy$count:uint = 0;
			var troopsFightValue$count:uint = 0;
			var isFirstLogin$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (roleID$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.roleID cannot be set twice.');
					}
					++roleID$count;
					this.roleID = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (roleName$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.roleName cannot be set twice.');
					}
					++roleName$count;
					this.roleName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (ptID$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.ptID cannot be set twice.');
					}
					++ptID$count;
					this.ptID = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (sex$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.sex cannot be set twice.');
					}
					++sex$count;
					this.sex = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (roleType$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.roleType cannot be set twice.');
					}
					++roleType$count;
					this.roleType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (experience$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.experience cannot be set twice.');
					}
					++experience$count;
					this.experience = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 8:
					if (gold$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.gold cannot be set twice.');
					}
					++gold$count;
					this.gold = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (copper$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.copper cannot be set twice.');
					}
					++copper$count;
					this.copper = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (formationId$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.formationId cannot be set twice.');
					}
					++formationId$count;
					this.formationId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (vipLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.vipLevel cannot be set twice.');
					}
					++vipLevel$count;
					this.vipLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (playerCommanderId$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.playerCommanderId cannot be set twice.');
					}
					++playerCommanderId$count;
					this.playerCommanderId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (energy$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.energy cannot be set twice.');
					}
					++energy$count;
					this.energy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 14:
					if (troopsFightValue$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.troopsFightValue cannot be set twice.');
					}
					++troopsFightValue$count;
					this.troopsFightValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 15:
					if (isFirstLogin$count != 0) {
						throw new flash.errors.IOError('Bad data format: UserInfoResponse.isFirstLogin cannot be set twice.');
					}
					++isFirstLogin$count;
					this.isFirstLogin = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
