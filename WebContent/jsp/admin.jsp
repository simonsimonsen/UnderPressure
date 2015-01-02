<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%@page import="java.io.InputStream" %>
<%@page import="java.util.Properties" %>

<form method="POST" action="UnderPressureServlet?admin=uboot">
	<%! public String initValue(String propname, HttpServletRequest request) {
			String value = "NA";
			if(request.getAttribute(propname) != null) {
				value = "" + request.getAttribute(propname);
			}
			return value;
		}
	
		public boolean initBoolean(String propname, HttpServletRequest request) {
			boolean value = false;
			if(request.getAttribute(propname) != null) {
				String helperString = "" + request.getAttribute("showAdminIsStromDecayRunning");
				value = Boolean.valueOf(helperString);
			}
			return value;
		}
	%><%
		InputStream stream = application.getResourceAsStream("/cfg/ViewElements.properties");
	    Properties props = new Properties();
	    props.load(stream);
	    
		// All Strom Variables
		String stromValue = initValue(props.getProperty("stromValue"), request);
		String stromValueRow = initValue(props.getProperty("stromValueRow"), request);
		String stromValueColumn = initValue(props.getProperty("stromValueCol"), request);
		String stromDecayValue = initValue(props.getProperty("stromDecayValue"), request);
		String stromDecayRate = initValue(props.getProperty("stromDecayRate"), request);
		boolean stromIsDecayRunning = initBoolean(props.getProperty("stromIsDecayRunning"), request);
		
		// All Depth Variables
		String depthValue = "NA";
		if(request.getAttribute("showAdminDepthValue") != null) {
			depthValue = "" + request.getAttribute("showAdminDepthValue");
		}

		String depthValueRow = "NA";
		if(request.getAttribute("showAdminDepthValueRow") != null) {
			depthValueRow = "" + request.getAttribute("showAdminDepthValueRow");
		}
		
		String depthValueColumn = "NA";
		if(request.getAttribute("showAdminDepthValueColumn") != null) {
			depthValueColumn = "" + request.getAttribute("showAdminDepthValueColumn");
		}
		
		String depthDecayAmount = "NA";
		if(request.getAttribute("showAdminDepthDecayAmount") != null) {
			depthDecayAmount = "" + request.getAttribute("showAdminDepthDecayAmount");
		}
		
		String depthDecayRate = "NA";
		if(request.getAttribute("showAdminDepthDecayRate") != null) {
			depthDecayRate = "" + request.getAttribute("showAdminDepthDecayRate");
		}
		
		boolean isDepthDecayRunning = false;
		if(request.getAttribute("showAdminIsDepthDecayRunning") != null) {
			String showAdminisDepthDecayRunning = "" + request.getAttribute("showAdminIsDepthDecayRunning");
			isDepthDecayRunning = Boolean.valueOf(showAdminisDepthDecayRunning);
		}
		
		// Water Temperature
		String waterTemperatureValue = "NA";
		if(request.getAttribute("showAdminWaterTemperatureValue") != null) {
			waterTemperatureValue = "" + request.getAttribute("showAdminWaterTemperatureValue");
		}

		String waterTemperatureValueRow = "NA";
		if(request.getAttribute("showAdminWaterTemperatureValueRow") != null) {
			waterTemperatureValueRow = "" + request.getAttribute("showAdminWaterTemperatureValueRow");
		}
		
		String waterTemperatureValueColumn = "NA";
		if(request.getAttribute("showAdminWaterTemperatureValueColumn") != null) {
			waterTemperatureValueColumn = "" + request.getAttribute("showAdminWaterTemperatureValueColumn");
		}
		
		// Deepflight Power
		String deepflighPowerValue = "NA";
		if(request.getAttribute("showAdminDeepflightPowerValue") != null) {
			deepflighPowerValue = "" + request.getAttribute("showAdminDeepflightPowerValue");
		}

		String deepflighPowerValueRow = "NA";
		if(request.getAttribute("showAdminDeepflightPowerValueRow") != null) {
			deepflighPowerValueRow = "" + request.getAttribute("showAdminDeepflightPowerValueRow");
		}
		
		String deepflighPowerValueColumn = "NA";
		if(request.getAttribute("showAdminDeepflightPowerValueColumn") != null) {
			deepflighPowerValueColumn = "" + request.getAttribute("showAdminDeepflightPowerValueColumn");
		}
		
	%>

<input type="hidden" name="adminRefresh" value="true"/>    
<div class="slot" id="top">
				NR-2 "Stonefish" Control Panel<br />
				<input class="submit" type="submit" value="[Refresh]" style="font-size:10pt; font-family:courier; font-weight:bold;" />
			</div>

			<!-- STROM SLOT -->
			<div class="slot" id="power">
				<img class="icon" src="jsp/img/battery-icon.png" style="height:15px"/> 
				<span class="slotHeader">Power Control >> Current Values</span> 
				<br />
				Power <input name="<% out.print(props.getProperty("adminStromValueField")); %>" class="textfield" type="text" placeholder="<% out.print(stromValue); %>" disabled="true"/><b>%</b> |
				Player View: 
				Z <input name="<% out.print(props.getProperty("adminStromRowField")); %>" class="textfield" type="text" placeholder="<% out.print(stromValueRow); %>" /> 
				S <input name="<% out.print(props.getProperty("adminStromColField")); %>" class="textfield" type="text" placeholder="<% out.print(stromValueColumn); %>" /> |
				Decay <input name="<% out.print(props.getProperty("adminStromDecayValueField")); %>" class="textfield" type="text" placeholder="<% out.print(stromDecayValue); %>" disabled="true"/><b>%</b> 
				every <input name="<% out.print(props.getProperty("adminStromDecayRateField")); %>" class="textfield" type="text" placeholder="<% out.print(stromDecayRate); %>" disabled="true"/> Sec  |
				<br />
				<hr>
				<!-- Admin -->
				Add Power <input name="<% out.print(props.getProperty("stromValueInput")); %>" class="textfield" type="text" value="0" /><b> %</b>
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminStromValueInputButton")); %>" value="add"> |
				Decayrate: 
				<input name="<% out.print(props.getProperty("stromNewDecayValue")); %>" class="textfield" type="text" value="<% out.print(stromDecayValue); %>" /><b>%</b> every
				<input name="<% out.print(props.getProperty("stromNewDecayRate")); %>" class="textfield" type="text" value="<% out.print(stromDecayRate); %>" /> Seconds 
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminStromDecayChangeButton")); %>" value="change"> &rarr;
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminStromDecayStartButton")); %>" value="start">
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminStromDecayStopButton")); %>" value="stop">
				<% 
				if(!stromIsDecayRunning) { out.print("<span class=\"notrunning\">[Decay disabled]</span>"); } 
				else { out.print("<span class=\"running\">[Decay enabled]</span>");	}
				%>
			</div>

			<div class="slot" id="depth">
				<img class="icon" src="jsp/img/gauge-icon.png" style="height:25px"/> 
				<span class="slotHeader">Dive Depth >> Current Values</span>
				<br />
				Depth <input name="currentDepth" class="textfield" type="text" placeholder="<% out.print(depthValue); %>" disabled="true"/><b>m</b> |
				Player View: Z <input name="depthRow" class="textfield" type="text" placeholder="<% out.print(depthValueRow); %>" /> S <input name="depthColumn" class="textfield" type="text" placeholder="<% out.print(depthValueColumn); %>" /> |
				Descent <input name="currentDescentRate" class="textfield" type="text" placeholder="<% out.print(depthDecayAmount); %>" disabled="true"/> <b>m</b> 
				every <input name="currentDescentInterval" class="textfield" type="text" placeholder="<% out.print(depthDecayRate); %>" disabled="true"/> Sec  |
				<br />
				<hr />
				Add Depth <input name="depthChangeValue" class="textfield" type="text" value="0" /><b> m</b>
				<input class="submit" type="submit" name="depthChangeAction" value="add"> | 
				Start Descending:
				<input name="newDescentValue" class="textfield" type="text" value="<% out.print(depthDecayAmount); %>" /> <b>m</b> every
				<input name="newDescentInterval" class="textfield" type="text" value="<% out.print(depthDecayRate); %>" /> Sec 
				<input class="submit" type="submit" name="descentChangeAction" value="change"> &rarr;
				<input class="submit" type="submit" name="startDescending" value="start">
				<input class="submit" type="submit" name="stopDescending" value="stop">
				<% if(!isDepthDecayRunning) {
					out.print("<span class=\"notrunning\">[Descend disabled]</span>");
				} else {
					out.print("<span class=\"running\">[Descend enabled]</span>");
				}
				%>
			</div>

			<div class="slot" id="temperature">
				<img class="icon" src="jsp/img/temperature-icon.png" style="height:20px"/> 
				<span class="slotHeader">Water Temperature >> Current Values</span> <br /> 
				Current Temperature <input name="currentTemperature" class="textfield" type="text" placeholder="<% out.print(waterTemperatureValue); %>" disabled="true"/><b>&#176;C</b> |
				Player View: Z <input name="waterTemperatureRow" class="textfield" type="text" placeholder="<% out.print(waterTemperatureValueRow); %>" /> S <input name="waterTemperatureValueColumn" class="textfield" type="text" placeholder="<% out.print(waterTemperatureValueColumn); %>" /> |
				New Temp. <input name="newWaterTemperature" class="textfield" type="text" value="0" /><b>&#176;C</b> 
				<input class="submit" type="submit" name="waterTemperatureChangeAction" value="change"> |
			</div>
			
			
			<div class="slot" id="deepflightpower">
				<img class="icon" src="jsp/img/battery-icon.png" style="height:20px"/> 
				<span class="slotHeader">Deepflight Power >> Current Values</span> <br /> 
				Current Power <input name="currentTemperature" class="textfield" type="text" placeholder="<% out.print(deepflighPowerValue); %>" disabled="true"/><b>%</b> |
				Player View: Z <input name="waterTemperatureRow" class="textfield" type="text" placeholder="<% out.print(deepflighPowerValueRow); %>" /> S <input name="waterTemperatureValueColumn" class="textfield" type="text" placeholder="<% out.print(deepflighPowerValueColumn); %>" /> |
				New Power <input name="newDeepflightPower" class="textfield" type="text" value="0" /><b>%</b> 
				<input class="submit" type="submit" name="deepflightPowerChangeAction" value="change"> |
			</div>
</form>