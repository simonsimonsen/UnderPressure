<%@page import="apple.laf.JRSUIConstants.ShowArrows"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%@page import="java.io.InputStream" %>
<%@page import="java.util.Properties" %>

<form method="POST" action="UnderPressureServlet">
	<input type="hidden" name="userRefresh" value="true"/> 		
	<div class="slot" id="top">
		NR-2 "Stonefish" Control Panel<br /><br />
		<input class="submit" type="submit" value="Check Values" style="font-size:20pt; font-family:courier; font-weight:bold;" />
	</div>
	<%! public String initValue(String propname, HttpServletRequest request) {
			String value = "NA";
			if(request.getAttribute(propname) != null) {
				value = "" + request.getAttribute(propname);
			}
			return value;
		}
	%>	
	<%
		InputStream stream = application.getResourceAsStream("/cfg/ViewElements.properties");
	    Properties props = new Properties();
	    props.load(stream);
	
		String stromValueRow = initValue(props.getProperty("stromValueRow"), request);
		String stromValueColumn = initValue(props.getProperty("stromValueCol"), request);
		
		String depthValueRow = "NA";
		if(request.getAttribute("showUserDepthValueRow") != null) {
			depthValueRow = "" + request.getAttribute("showUserDepthValueRow");
		}
		
		String depthValueColumn = "NA";
		if(request.getAttribute("showUserDepthValueColumn") != null) {
			depthValueColumn = "" + request.getAttribute("showUserDepthValueColumn");
		}
		
		String waterTemperatureValueRow = "NA";
		if(request.getAttribute("showUserWaterTemperatureRow") != null) {
			waterTemperatureValueRow = "" + request.getAttribute("showUserWaterTemperatureRow");
		}
		
		String waterTemperatureValueColumn = "NA";
		if(request.getAttribute("showUserWaterTemperatureColumn") != null) {
			waterTemperatureValueColumn = "" + request.getAttribute("showUserWaterTemperatureColumn");
		}
		
		String deepflightPowerValueRow = "NA";
		if(request.getAttribute("showUserDeepflightPowerRow") != null) {
			deepflightPowerValueRow = "" + request.getAttribute("showUserDeepflightPowerRow");
		}
		
		String deepflightPowerValueColumn = "NA";
		if(request.getAttribute("showUserDeepflightPowerColumn") != null) {
			deepflightPowerValueColumn = "" + request.getAttribute("showUserDeepflightPowerColumn");
		}
		
	%>

	<div class="slot" id="power">
		<img class="icon" src="jsp/img/battery-icon.png" style="height:15px"/> 
		<span class="slotHeader">Power Control </span> <br />
		<span class="slotKey">Z</span> <input name="<% out.print(props.getProperty("userStromRowField")); %>" class="textfield" type="text" value="<% out.print(stromValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="<% out.print(props.getProperty("userStromColField")); %>" class="textfield" type="text" value="<% out.print(stromValueColumn); %>" disabled="true"/>
	</div>

	<div class="slot" id="depth">
		<img class="icon" src="jsp/img/gauge-icon.png" style="height:25px"/> 
		<span class="slotHeader">Dive Depth </span> <br />
		<span class="slotKey">Z</span> <input name="depthRow" class="textfield" type="text" value="<% out.print(depthValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="depthColumn" class="textfield" type="text" value="<% out.print(depthValueColumn); %>" disabled="true"/>
	</div>

	<div class="slot" id="temperature">
		<img class="icon" src="jsp/img/temperature-icon.png" style="height:20px"/> 
		<span class="slotHeader">Water Temperature </span> <br />
		<span class="slotKey">Z</span> <input name="temperatureRow" class="textfield" type="text" value="<% out.print(waterTemperatureValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="temperatureColumn" class="textfield" type="text" value="<% out.print(waterTemperatureValueColumn); %>" disabled="true"/>
	</div>
	
		<div class="slot" id="deepflight-power">
		<img class="icon" src="jsp/img/battery-icon.png" style="height:20px"/> 
		<span class="slotHeader">Deepflight Power </span> <br />
		<span class="slotKey">Z</span> <input name="temperatureRow" class="textfield" type="text" value="<% out.print(deepflightPowerValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="temperatureColumn" class="textfield" type="text" value="<% out.print(deepflightPowerValueColumn); %>" disabled="true"/>
	</div>
</form>