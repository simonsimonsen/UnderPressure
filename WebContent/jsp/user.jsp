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
		
		String depthValueRow = initValue(props.getProperty("depthValueRow"), request);
		String depthValueColumn = initValue(props.getProperty("depthValueCol"), request);
		
		String waterTemperatureValueRow = initValue(props.getProperty("waterTemperatureValueRow"), request);
		String waterTemperatureValueColumn = initValue(props.getProperty("waterTemperatureValueCol"), request);
		
		String deepflightPowerValueRow = initValue(props.getProperty("deepflightPowerValueRow"), request);
		String deepflightPowerValueColumn = initValue(props.getProperty("deepflightPowerValueCol"), request);
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
		<span class="slotKey">Z</span> <input name="<% out.print(props.getProperty("userDepthRowField")); %>" class="textfield" type="text" value="<% out.print(depthValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="<% out.print(props.getProperty("userDepthColField")); %>" class="textfield" type="text" value="<% out.print(depthValueColumn); %>" disabled="true"/>
	</div>

	<div class="slot" id="temperature">
		<img class="icon" src="jsp/img/temperature-icon.png" style="height:20px"/> 
		<span class="slotHeader">Water Temperature </span> <br />
		<span class="slotKey">Z</span> <input name="<% out.print(props.getProperty("userWaterTemperatureRowField")); %>" class="textfield" type="text" value="<% out.print(waterTemperatureValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="<% out.print(props.getProperty("userWaterTemperatureColField")); %>" class="textfield" type="text" value="<% out.print(waterTemperatureValueColumn); %>" disabled="true"/>
	</div>
	
	<div class="slot" id="deepflight-power">
		<img class="icon" src="jsp/img/battery-icon.png" style="height:20px"/> 
		<span class="slotHeader">Deepflight Power </span> <br />
		<span class="slotKey">Z</span> <input name="<% out.print(props.getProperty("userDeepflightPowerRowField")); %>" class="textfield" type="text" value="<% out.print(deepflightPowerValueRow); %>" disabled="true"/> 
		<span class="slotKey">S</span> <input name="<% out.print(props.getProperty("userDeepflightPowerColField")); %>" class="textfield" type="text" value="<% out.print(deepflightPowerValueColumn); %>" disabled="true"/>
	</div>
</form>