package module.login.model
{
	import proto.login.UserInfoResponse;

	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午5:55:00
	 *
	 */
	public class LoginModel
	{
		public var roleName:String;
		public var roleID:String;
		public function LoginModel()
		{
		}
		
		public function init(data:UserInfoResponse):void
		{
			roleName = data.roleName;
			roleID = data.roleID;
		}
	}
}