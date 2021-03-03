<%@page import="in.co.rays.ors.controller.TimeTableCtl"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="in.co.rays.ors.util.HTMLUtility"%>
<%@page import="in.co.rays.ors.bean.TimeTableBean"%>
<%@page import="java.util.List"%>
<%@page import="in.co.rays.ors.controller.TimeTableListCtl"%>
<%@page import="in.co.rays.ors.util.DataUtility"%>
<%@page import="in.co.rays.ors.util.ServletUtility"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
<head>
<link rel="icon" type="image/png" href="<%=ORSView.APP_CONTEXT%>/img/logo.png" sizes="16*16"/>
<title> TimeTable Register Page</title>

  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

  <script>
  
  var d = new Date();
  function disableSunday(d){
	  var day = d.getDay();
	  if(day==0)
	  {
	   return [false];
	  }else
	  {
		  return [true];
	  }
  }
  
  $( function() {
	  $( "#udate" ).datepicker({
		  changeMonth :true,
		  changeYear :true,
		  yearRange :'1980:2030',
		  dateFormat:'dd-mm-yy',

// Disable for Sunday
		  beforeShowDay : disableSunday,		  
// Disable for back date
		  minDate : 0   
	  });
  } );
  </script>


</head>
<body>
<jsp:useBean id="bean" class="in.co.rays.ors.bean.TimeTableBean" scope="request"></jsp:useBean>
	<%@include file="Header.jsp" %>

<form action="<%=ORSView.TIMETABLE_CTL %>" method="post">
	<%
	List <TimeTableBean> courseList =(List<TimeTableBean>)request.getAttribute("CourseList"); 
	List <TimeTableBean> subjectList = (List<TimeTableBean>)request.getAttribute("SubjectList");
	%>
	
	<input type="hidden" name="id" value="<%=bean.getId() %>">
	<input type="hidden" name="createdby" value="<%=bean.getCreatedBy() %>">
	<input type="hidden" name="modifiedby" value="<%=bean.getModifiedBy() %>">
	<input type="hidden" name="createddatetime" value="<%=DataUtility.getTimestamp(bean.getCreatedDatetime()) %>">
	<input type="hidden" name="modifiedby" value="<%=DataUtility.getTimestamp(bean.getModifiedDatetime())%>">
	
	<div align = "center">
		<h1 >
		
			<%
				if(bean != null && bean.getId() >0 ){	
			%>
		
		<tr ><th ><font size="5px"> Update TimeTable</font></th></tr>
		
			<%}else{ %>
		
		<tr ><th >
		<font size="5px"> Add TimeTable</font></th></tr>	
		
			<% } %>
		</h1>
	
	<div align="center">
	<h2 align="center"><font style="color: red"><%=ServletUtility.getErrorMessage(request)%></font></h2>
	<h2 align="center"><font style="color: green"><%=ServletUtility.getSuccessMessage(request) %></font></h2>
	
	</div>

<table>
	<tr>
	<th align="right">Course <span style="color: red">*</span></th>
	<td><%=HTMLUtility.getList("courseId", String.valueOf(bean.getCourseId()), courseList) %></td>
	<td style="position: fixed;"><font color="red"><%=ServletUtility.getErrorMessage("courseId",request) %></font> 
	</td></tr>
	
 <tr><th style="padding: 3px"></th></tr>   
	
	<tr><th align="right">Subject <span style="color: red">*</span></th>
	<td><%=HTMLUtility.getList("subjectId", String.valueOf(bean.getSubjectId()), subjectList) %></td>
	<td style="position: fixed;"><font color="red"><%=ServletUtility.getErrorMessage("subjectId",request) %></font> 
	</td></tr>
	
 <tr><th style="padding: 3px"></th></tr>   
	
	<tr>
	<th align="right">Semester<span style="color: red">*</span></th>
	<td><%
		LinkedHashMap<String , String> map = new LinkedHashMap< String , String>();
		map.put("1st","1st");
		map.put("2st","2st");
		map.put("3st","3st");
		map.put("4st","4st");
		map.put("5st","5st");
		map.put("6st","6st");
		map.put("7st","7st");
		map.put("8st","8st");
	
		String htmlList = HTMLUtility.getList("semester", bean.getSemester(), map);
	%>
	<%=htmlList %>
	</td>
	<td style="position: fixed;"><font color="red"><%=ServletUtility.getErrorMessage("semester",request) %></font> 
	</td></tr>
	
 <tr><th style="padding: 3px"></th></tr>   
	<tr><th align="right">Exam Date <span style="color: red">*</span></th>
	<td> <input type="text" readonly="readonly" id="udate" size="25" placeholder="Select Date" name="ExDate" value="<%=DataUtility.getDateString(bean.getExamDate()) %>">
	<td style="position: fixed;"><font color="red"><%=ServletUtility.getErrorMessage("ExDate",request) %></font> 
	</td></tr>
	
 <tr><th style="padding: 3px"></th></tr>   
	<tr><th align="right">Exam Time <span style="color: red">*</span></span></th>
	<td>
	<%
		LinkedHashMap<String , String > map1 = new LinkedHashMap<String  ,String >();
		map1.put("08:00 AM to 11:00 AM","08:00 AM to 11:00 AM");
		map1.put("12:00 PM to 03:00 PM","12:00 PM to 03:00 PM");
		map1.put("04:00 PM to 07:00 PM","04:00 PM to 07:00 PM");
	
		String htmlList1 = HTMLUtility.getList("ExTime", bean.getExamTime(), map1);
	%>
	<%=htmlList1 %>
	</td>
	<td style="position: fixed;"><font color="red"><%=ServletUtility.getErrorMessage("ExTime",request) %></font> 
	</td></tr>
	
<%-- 	<tr><th align = "right">Description <span style="color: red">*</span></th>
	<td><input type="text" name="description" placeholder="Enter Description" size="25" value="<%=DataUtility.getStringData(bean.getDescription())%>">
	
	<%
	if(bean != null && bean.getId()>0) {
	%>
	<%=DataUtility.getStringData(bean.getDescription()) %>
	<% } %>
	</td>
	<td style="position: fixed;"><font color="red"><%=ServletUtility.getErrorMessage("description", request) %>	</font>	</td></tr>
	
 --%>
 
 	<tr><th style="padding: 3px"></th>
	<td></td></tr>
	
	<tr>
		<th></th>
		<td></td>
	</tr>
	<tr align="center">
		
	<%
	if(bean != null && bean.getId() > 0){
	%>
		<td colspan="2">
		<input type="submit" name="operation" value="<%=TimeTableCtl.OP_UPDATE%>">
		<input type="submit" name="operation" value="<%=TimeTableCtl.OP_CANCEL%>">
		</td>
		<%} else { %>
		
		<td colspan="2">
		<input type="submit" name="operation" value="<%=TimeTableCtl.OP_SAVE%>">
		<input type="submit" name="operation" value="<%=TimeTableCtl.OP_RESET%>">
		</td>
		<% } %>
	</tr>
</table>
		</div>
</form>	
	<%@include file="Footer.jsp" %>
</body>
</html>