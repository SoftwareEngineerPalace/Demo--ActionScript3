package com.A17zuoye.mobile;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class MyContext extends FREContext {

	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> dict = new HashMap<String, FREFunction>();
		dict.put("init", new InitFunction());
		dict.put("setVolume", new SetVolumeFunction());
		return dict;
	}

}
