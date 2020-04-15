<%@ page import="com.liferay.portal.kernel.util.Constants" %>

<%@ include file="./init.jsp" %>

<liferay-portlet:actionURL
	portletConfiguration="<%= true %>"
	var="configurationActionURL"
/>

<liferay-portlet:renderURL
	portletConfiguration="<%= true %>"
	var="configurationRenderURL"
/>

<div class="configField">
	<aui:form action="<%= configurationActionURL %>" method="post" name="fm">
		<aui:input
			name="<%= Constants.CMD %>"
			type="hidden"
			value="<%= Constants.UPDATE %>"
		/>
	
		<aui:input
			name="redirect"
			type="hidden"
			value="<%= configurationRenderURL %>"
		/>
				<aui:input id="configContentLength" label="Content Length" name="ContentLength" type="text" value="<%= ContentLength %>" />		  
	            <aui:input label="Show Profile Picture" name="showProfilePic"  type="checkbox" value="<%= showProfilePic %>" />
	            <aui:input label="Show Captcha" name="showCaptcha"  type="checkbox" value="<%= showCaptcha %>" />
				<button class="conFigSubmitButton" type="submit">Save</button>
	</aui:form>
</div>

