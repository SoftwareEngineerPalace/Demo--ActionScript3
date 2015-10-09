using UnityEngine;
using System.Collections;
public class ActorOne  : BaseGameEntity {
	//有限状态机
	StateMachine<ActorOne> m_pStateMachine;
	void Start () {
		//设置实体的id必须唯一
		SetID((int)EntityID.m_ActorOne);
		
		//注册
		m_pStateMachine = new StateMachine<ActorOne>(this);
		/* 
		一个状态分为三个阶段
		Enter()       //进入
		Execute() //执行
		Exit()           //离开
		
		当m_pStateMachine.SetCurrentState(ActorOne_StateOne .Instance());
		
		会先执行ActorOne_StateOne 的Enter()方法,
		然后执行ActorOne_StateOne 的Execute()方法, Execute方法会一直执行直到切换状态
		
		当在ActorOne_StateOne(Enter(), Execute())中调用Entity.GetFSM().ChangeState(ActorOne_StateTwo.Instance());
		
		会先执行ActorOne_StateOne 的Exit();
		然后执行ActorOne_StateTwo的Enter()方法，
		然后执行ActorOne_StateTwo的Execute()方法，
		
		
		*/
		
		
		//设置当前的状态为ActorOne_StateOne
		m_pStateMachine.SetCurrentState(ActorOne_StateOne .Instance());    
		//设置全局的状态
		m_pStateMachine.SetGlobalStateState(ActorOne_GloballState .Instance());
		
		
		//实体注册到实体管理器中
		EntityManager.Instance().RegisterEntity(this);
	}
	
	void Update ()
	{    
		//状态机update
		m_pStateMachine.SMUpdate();
	}
	
	
	public StateMachine<ActorOne> GetFSM ()
	{
		//获得状态机
		return m_pStateMachine;
	}
	
	public override bool HandleMessage (Telegram telegram)
	{
		//解析消息
		return     m_pStateMachine.HandleMessage(telegram);
	}
}