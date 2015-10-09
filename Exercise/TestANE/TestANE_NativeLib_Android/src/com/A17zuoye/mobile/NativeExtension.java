package com.A17zuoye.mobile;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class NativeExtension implements FREExtension {

	public NativeExtension() {
		Log.d("JPush", "new native extension");
	}
	
	@Override
	public FREContext createContext(String arg0) {
		Log.d("JPush", "create context");
		return new MyContext();
	}

	@Override
	public void dispose() {
		Log.d("JPush", "dispose");
	}

	@Override
	public void initialize() {
		Log.d("JPush", "initialize");
	}

}
