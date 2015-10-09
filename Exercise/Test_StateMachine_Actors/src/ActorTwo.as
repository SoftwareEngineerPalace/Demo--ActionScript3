using UnityEngine;
using System.Collections;
public class ActorTwo  : BaseGameEntity {
	
	StateMachine<ActorTwo> m_pStateMachine;
	
	public Transform TwoTransform;
	
	// Use this for initialization
	void Start () {
		
		
		// set id 
		SetID((int)EntityID.m_ActorTwo);
		
		m_pStateMachine = new StateMachine<ActorTwo>(this);
		
		m_pStateMachine.SetCurrentState(ActorTwo_StateOne.Instance());    
		
		
		m_pStateMachine.SetGlobalStateState(ActorTwo_GloballState.Instance());
		EntityManager.Instance().RegisterEntity(this);
	}
	
	void Update ()
	{    
		
		m_pStateMachine.SMUpdate();
	}
	
	
	public StateMachine<ActorTwo> GetFSM ()
	{
		return m_pStateMachine;
	}
	
	public override bool HandleMessage (Telegram telegram)
	{
		return     m_pStateMachine.HandleMessage(telegram);
		
		
	}
}