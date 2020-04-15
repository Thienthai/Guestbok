package com.omb.guestbook.portlet;

import aQute.bnd.annotation.metatype.Meta;

@Meta.OCD(
		id = "com.omb.guestbook.configuration.setUpDisplayConfiguration"
		)

public interface SetupDisplayConfiguration {
	
    @Meta.AD(deflt = "100", required = false)	
	public String ContentLength();
    
    @Meta.AD(deflt = "true", required = false)	
	public String showProfilePic();
    
    @Meta.AD(deflt = "true", required = false)	
	public String showCaptcha();
    
}
