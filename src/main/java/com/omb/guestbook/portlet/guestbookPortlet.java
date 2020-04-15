package com.omb.guestbook.portlet;

//import org.osgi.service.component.annotations.Component;

import com.liferay.counter.kernel.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.Role;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.model.UserGroupRole;
import com.liferay.portal.kernel.model.role.RoleConstants;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.service.RoleLocalServiceUtil;
import com.liferay.portal.kernel.service.UserGroupRoleLocalServiceUtil;
import com.liferay.portal.kernel.servlet.PortalSessionThreadLocal;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.omb.guestbook.constants.guestbookPortletKeys;
import com.services.model.Guestbook;
import com.services.service.GuestbookLocalService;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

//import org.osgi.service.component.annotations.Modified;

/**
 * @author Ice
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=Personal",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=guestbook",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/html/view.jsp",
		"javax.portlet.name=" + guestbookPortletKeys.GUESTBOOK,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class guestbookPortlet extends MVCPortlet {
	
	private int page = 1;
	private int pageTotal = 3;
	
	@Reference
	private GuestbookLocalService _guestbooklocalservice;
	

	
	@Override
	public void render(RenderRequest renderRequest,RenderResponse renderResponse) 
	throws PortletException, IOException{
		// Check if the button that press on pagination is arrow or not
	
		ThemeDisplay themeDisplay= (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String portraitURL = null;
		try {
		portraitURL = themeDisplay.getUser().getPortraitURL(themeDisplay);
		} catch (PortalException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
		} catch (SystemException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
		}
		renderRequest.setAttribute("profilePic", portraitURL);
		
		PortalUtil pt = new PortalUtil();
		HttpServletRequest httpreq = PortalUtil.getHttpServletRequest(renderRequest);

		List<Role> user = RoleLocalServiceUtil.getUserRoles(pt.getUserId(httpreq));
		
		renderRequest.setAttribute("userTypeId", user);
		renderRequest.setAttribute("userId", pt.getUserId(httpreq));
		
		
		if(
			renderRequest.getParameter("button") != null && 
			renderRequest.getParameter("button").equals("rightArrow")
		  ) {
			
			System.out.println("left arrow press");
			if(page != _guestbooklocalservice.getGuestbooksCount()/pageTotal) {
					page += 1;
					
			}
		}else if(renderRequest.getParameter("button") != null && renderRequest.getParameter("button").equals("leftArrow")) {
			System.out.println("right arrow press");
			if(page != 1) {
					page -= 1;
			}
		}
		
		if(renderRequest.getParameter("page") != null) {
			page = Integer.parseInt(renderRequest.getParameter("page"));
			renderRequest.setAttribute("currentPage", page);
		}
		
		List<Guestbook> guestbooks = null;
		
		if(_guestbooklocalservice.getGuestbooksCount() >= pageTotal * page) {
			//System.out.println("start page " + ((pageTotal*(page-1))) + " end page" + pageTotal * page);
			guestbooks = _guestbooklocalservice.getGuestbooks(
					(pageTotal*(page-1)), // start page
					(pageTotal * page)); // end page
		}else {
			//System.out.println("start page " + ((pageTotal*(page-1))) + " end page" + _guestbooklocalservice.getGuestbooksCount());
			guestbooks = _guestbooklocalservice.getGuestbooks(
					(pageTotal*(page-1)), // start page
					_guestbooklocalservice.getGuestbooksCount()); // end page			
		}
		
		renderRequest.setAttribute("pageTotal", pageTotal);
		renderRequest.setAttribute("size", _guestbooklocalservice.getGuestbooksCount());
		renderRequest.setAttribute("total", pageTotal);
		if(_guestbooklocalservice.getGuestbooksCount() != 0) {
			renderRequest.setAttribute("entries", guestbooks);
		}
		
		super.render(renderRequest, renderResponse);
	}

	public void addEntry(ActionRequest actionRequest,ActionResponse actionResponse) {
		
			ThemeDisplay themeDisplay= (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			String portraitURL = null;
			try {
			portraitURL = themeDisplay.getUser().getPortraitURL(themeDisplay);
			} catch (PortalException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			} catch (SystemException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			}
			
			String date = formatDate(new Date().toString());
			String name = ParamUtil.getString(actionRequest, "name");
			String message = ParamUtil.getString(actionRequest, "message");
			PortalUtil pt = new PortalUtil();
			HttpServletRequest httpreq = PortalUtil.getHttpServletRequest(actionRequest);

			Guestbook guestbook = _guestbooklocalservice.createGuestbook(CounterLocalServiceUtil.increment());
			guestbook.setName(name);
			guestbook.setMessage(message.replace("\n", "<br>"));
			guestbook.setMyDate(date);
			guestbook.setCreatedId(pt.getUserId(httpreq));
			guestbook.setImageUrl(portraitURL);
			try {
				_guestbooklocalservice.addGuestbook(guestbook);
			} catch (Exception e) {
				e.printStackTrace();
				SessionErrors.add(actionRequest, "error-key");
				SessionMessages.add(actionRequest, PortalUtil.getPortletId(actionRequest) + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);
			}
		
	}
	
	public void deleteEntry(ActionRequest actionRequest,ActionResponse actionResponse) {
		String fId = ParamUtil.getString(actionRequest, "theId");
		long num = Long.parseLong(fId);
		try {
			_guestbooklocalservice.deleteGuestbook(num);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String formatDate(String date) {
		String day = date.substring(8,10);
		String month = date.substring(4,7);
		String year = date.substring(24,28);
		switch(month) 
		{
				  case "Jan":
				    month = "01";
				    break;
				  case "Feb":
					    month = "02";
					    break;
				  case "Mar":
					    month = "03";
					    break;
				  case "Apr":
					    month = "04";
					    break;
				  case "May":
					    month = "05";
					    break;
				  case "Jun":
					    month = "06";
					    break;
				  case "Jul":
					    month = "07";
					    break;
				  case "Aug":
					    month = "08";
					    break;
				  case "Sep":
					    month = "09";
					    break;
				  case "Oct":
					    month = "10";
					    break;
				  case "Nov":
					    month = "11";
					    break;
				  case "Dec":
					    month = "12";
					    break;
		}
		return month + "/" + day + "/" + year;
	}
	
	
	
}