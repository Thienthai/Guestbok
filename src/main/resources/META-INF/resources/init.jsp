<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="java.util.List" %>
<%@ page import="com.services.model.Guestbook" %>
<%@ page import="com.omb.guestbook.portlet.SetupDisplayConfiguration" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="com.liferay.portal.kernel.servlet.PortalSessionThreadLocal" %>
<%@ page import="com.liferay.portal.kernel.model.User" %>
<%@ page import="com.liferay.portal.kernel.model.Role" %>
<%@ page import="java.util.ArrayList" %>

<liferay-theme:defineObjects />

<portlet:defineObjects />


<% 

	SetupDisplayConfiguration setupDisplayConfiguration =
	(SetupDisplayConfiguration)
	renderRequest.getAttribute(SetupDisplayConfiguration.class.getName());
	
	String ContentLength = StringPool.BLANK;
	String showProfilePic = StringPool.BLANK;
	String showCaptcha = StringPool.BLANK;
	HttpServletRequest httpreq = PortalUtil.getHttpServletRequest(renderRequest);
	
	if (Validator.isNotNull(setupDisplayConfiguration)) {
		System.out.println("running");
		ContentLength = portletPreferences.getValue("ContentLength", setupDisplayConfiguration.ContentLength());
		showProfilePic = portletPreferences.getValue("showProfilePic", setupDisplayConfiguration.showProfilePic());
		showCaptcha = portletPreferences.getValue("showCaptcha", setupDisplayConfiguration.showCaptcha());
		session.setAttribute("_ContentLength",ContentLength);
		session.setAttribute("_showProfilePic",showProfilePic);
		session.setAttribute("_showCaptcha",showCaptcha);
	}


%>



