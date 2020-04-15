<%@ include file="../init.jsp" %>

		<a href="http://localhost:8080/th/web/guest/home"><liferay-ui:message key="language-thai" /></a><a> |</a>
		<a href="http://localhost:8080/en/web/guest/home">English</a>
        <div>    
		<%
			String 	_ContentLength = "50";
			String _showProfilePic = "true";
			String _showCaptcha = "true";
			String test = "noChange";
			

			if(Validator.isNotNull(session.getAttribute("_ContentLength"))){

				_ContentLength = (String) session.getAttribute("_ContentLength");
				_showProfilePic = (String) session.getAttribute("_showProfilePic");
				_showCaptcha = (String) session.getAttribute("_showCaptcha");
				test = (String) httpreq.getAttribute("test");
			}
		
			String userType = "noUserType";

			//Check config
			
			if(Validator.isNotNull(_showProfilePic)){
				if(_showProfilePic.toString().equals("false")){
					_showProfilePic = "none";
				}else{
					_showProfilePic = "notNone";
				}
			}
			
			if(Validator.isNotNull(_showCaptcha)){
				if(_showCaptcha.toString().equals("false")){
					_showCaptcha = "none";
				}else{
					_showCaptcha = "notNone";
				}
			}
			
			//Check Role
			List<Role> _userTypeId = (List<Role>) renderRequest.getAttribute("userTypeId");
			List<Integer> roleList = new ArrayList<Integer>();
			for (Role temp : _userTypeId) {
				roleList.add((int) temp.getRoleId());
			}
			
			if(roleList.contains(20107)){
				userType = "Admin";
			}else if(roleList.contains(20112)){
				userType = "User";
			}else{
				userType = "Guest";
			}
				
			
		%>
			
		<%
			List<Guestbook> entries = (List<Guestbook>) renderRequest.getAttribute("entries");
			//add comment
			if(entries != null){
				int number = entries.size();
				for(int i = 0;i<number;i++)
				{
		%>
            <div id="nameGuest">
                <div id="name">
                    <ul>
                        <li>
                            <span id="name"><%= entries.get(i).getName().replace("'", "&quot;") %></span>
                        </li>
                        <li>
                            <span id="date">
                                <%= entries.get(i).getMyDate() %>
                            </span>
                        </li>
                    </ul>
                </div>
                <div id="statement">
                    <p>
                    	<% String mssg = entries.get(i).getMessage().replace("\r\n", "<br />\r\n"); %>
                    	<%= mssg.replace("'", "&quot;") %>
                    </p>
                </div>
                <div>
                	<%  
                		if(!_showProfilePic.equals("none")){
                	%>
                    <img src="<%= entries.get(i).getImageUrl() %>" width="100" height="100">
                    <%
                		}
                    %>
		                <portlet:actionURL name="deleteEntry" var="DeleteEntry">
		                	<portlet:param name="theId" value="<%= Long.toString(entries.get(i).getMyId())%>" />
		                </portlet:actionURL>
                    <% 
                    	if(userType.equals("Admin")){
                    %>
                    	<aui:form action="<%= DeleteEntry %>" name="<portlet:namespace />gf">
                    		<button id="delete" style="<liferay-ui:message key='image-delete'/>" onClick="return confirm('Are you sure?')" type="submit" value="Save"></button>
                    		<input style="display:none;" id="fname" name="theId" value="<%= entries.get(i).getMyId()%>"></input>
                    		
                    	</aui:form>
                    <%
                    	}else if(userType.equals("User")){
                    		Long fId = (Long) renderRequest.getAttribute("userId");
                    		Long usId = entries.get(i).getCreatedId();
                    		if(fId.equals(usId)){
                    %>
                    	<aui:form action="<%= DeleteEntry %>" name="<portlet:namespace />gf">
                    		<button id="delete" type="submit" value="Save"></button>
                    		<input style="display:none;" id="fname" name="theId" value="<%= entries.get(i).getMyId()%>"></input>
                    	</aui:form>
                    <%
                    		}
                    	}
                    %>
                </div>
            </div>
			<% }} %>
            <div id="paginate">
                <div class="btn-group">
                <portlet:renderURL  var="leftBtn">
                	<portlet:param name="button" value="leftArrow" />
                </portlet:renderURL>
                <aui:form action="<%= leftBtn %>">
                    <button class="button" id="left"></button>
                </aui:form>
                    <%
                    System.out.println("this is current page " + renderRequest.getAttribute("currentPage"));
                    if(entries != null){
                    	int pageSize = (int) renderRequest.getAttribute("total");;
                    	int totalEl = (int) renderRequest.getAttribute("size");
                    	int totalPage = 0;
                    	if(totalEl % ((int) renderRequest.getAttribute("pageTotal")) != 0){
                    		totalPage = (totalEl / pageSize) + 1;
                    	}else{
                    		totalPage = totalEl / pageSize;
                    	}
                    	
						for(int i = 1 ; i<=totalPage;i++){
					%>
                    <portlet:renderURL var="paginate">
                    	<portlet:param name="page" value="<%= i + "" %>" />
                    </portlet:renderURL>
                    <aui:form action="<%= paginate %>">
                    <button name="<%=i%>" class="buttonNum" id="number"><span><%= i %></span></button>
                    </aui:form> 
						<% 
	
						}
						
                    
                    } %>
                    <script>
                    	var numEl = document.getElementsByName(<%=renderRequest.getAttribute("currentPage")%>);
                    	numEl[0].id = "active";
                    	if(document.getElementById("active") == null){
                    		var el = document.getElementById("active")
                    		el.id = "number"
                    	}
                    </script>
                    <portlet:renderURL  var="rightBtn">
                    	<portlet:param name="button" value="rightArrow" />
                    </portlet:renderURL>
					<aui:form action="<%= rightBtn %>">
                    	<button class="button" id="right"></button>
                    </aui:form>	
                </div>
            </div>
            <br>
            <% if(userType.equals("Admin") || userType.equals("User"))
            {
            %>
            <liferay-ui:error key="error-key" message="error-message" />
            <portlet:actionURL name="addEntry" var="addNewEntry"></portlet:actionURL>
            <div class="formfill">
                <aui:form action="<%= addNewEntry %>" method="post" name="gbForm">
                    <aui:input placeholder="" label="name-required-field" id="fname" name="name" style="width:342px">
				        <aui:validator name="required" />
                    </aui:input>
                    <aui:input cols='60' rows='8'  label="message-required-field" name="message" maxlength="<%= _ContentLength %>" type="textarea" style="width:342px">
				        <aui:validator name="required" /> 
                    </aui:input>
                    <%  
                		if(!_showCaptcha.equals("none")){
                	%>
                    <img src="<%= themeDisplay.getURLPortal() + request.getContextPath() %>/img/textVer.png" alt="textVerifi"><br><br>
                    <aui:input placeholder="" label="veri-required-field" id="fname" name="textverification" style="width:342px">
				        <aui:validator name="required" />                  	
                    </aui:input>
                    <%
                		}
                    %>
                    <span style="display:none;" placeholder="" id="errorReport">*Error you need to input all of the field</span>
                    <button type="submit" value="Save"><liferay-ui:message key="submit-button" /></button>
                </aui:form>
              <% 
             }
              %>
            </div>