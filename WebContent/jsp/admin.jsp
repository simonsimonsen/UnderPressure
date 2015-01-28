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
				String helperString = "" + request.getAttribute(propname);
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
		String stromMinValue = initValue(props.getProperty("stromMinValue"), request);
		String stromMaxValue = initValue(props.getProperty("stromMaxValue"), request);
		String stromValueRow = initValue(props.getProperty("stromValueRow"), request);
		String stromValueColumn = initValue(props.getProperty("stromValueCol"), request);
		String stromDecayValue = initValue(props.getProperty("stromDecayValue"), request);
		String stromDecayRate = initValue(props.getProperty("stromDecayRate"), request);
		boolean stromIsDecayRunning = initBoolean(props.getProperty("stromIsDecayRunning"), request);
		
		// All Depth Variables
		String depthValue = initValue(props.getProperty("depthValue"), request);
		String depthMinValue = initValue(props.getProperty("depthMinValue"), request);
		String depthMaxValue = initValue(props.getProperty("depthMaxValue"), request);
		String depthValueRow = initValue(props.getProperty("depthValueRow"), request);
		String depthValueColumn = initValue(props.getProperty("depthValueCol"), request);
		String depthDecayValue = initValue(props.getProperty("depthDecayValue"), request);
		String depthDecayRate = initValue(props.getProperty("depthDecayRate"), request);
		boolean depthIsDecayRunning = initBoolean(props.getProperty("depthIsDecayRunning"), request);
		
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
				<span class="slotHeader">Power Control >> Current Values >> Values From [<% out.print(stromMinValue); %> to <% out.print(stromMaxValue); %> %]</span> 
				<br />
				Power <input name="<% out.print(props.getProperty("adminStromValueField")); %>" class="textfield" type="text" placeholder="<% out.print(stromValue); %>" disabled /><b>%</b> |
				Player View: 
				Z <input name="<% out.print(props.getProperty("adminStromRowField")); %>" class="textfield" type="text" placeholder="<% out.print(stromValueRow); %>" /> 
				S <input name="<% out.print(props.getProperty("adminStromColField")); %>" class="textfield" type="text" placeholder="<% out.print(stromValueColumn); %>" /> |
				Decay <input name="<% out.print(props.getProperty("adminStromDecayValueField")); %>" class="textfield" type="text" placeholder="<% out.print(stromDecayValue); %>" disabled /><b>%</b> 
				every <input name="<% out.print(props.getProperty("adminStromDecayRateField")); %>" class="textfield" type="text" placeholder="<% out.print(stromDecayRate); %>" disabled /> Sec  |
				<% 
				if(!stromIsDecayRunning) { out.print("<span class=\"notrunning\">[Decay disabled]</span>"); } 
				else { out.print("<span class=\"running\">[Decay enabled]</span>");	}
				%>
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
			</div>

			<!-- DEPTH SLOT -->
			<div class="slot" id="depth">
				<img class="icon" src="jsp/img/gauge-icon.png" style="height:25px"/> 
				<span class="slotHeader">Dive Depth >> Current Values >> Values From [<% out.print(depthMinValue); %> to <% out.print(depthMaxValue); %> m]</span>
				<br />
				Depth <input name="<% out.print(props.getProperty("adminDepthValueField")); %>" class="textfield" type="text" placeholder="<% out.print(depthValue); %>" disabled /><b>m</b> |
				Player View: 
				Z <input name="<% out.print(props.getProperty("adminDepthRowField")); %>" class="textfield" type="text" placeholder="<% out.print(depthValueRow); %>" /> 
				S <input name="<% out.print(props.getProperty("adminDepthColField")); %>" class="textfield" type="text" placeholder="<% out.print(depthValueColumn); %>" /> |
				Descent <input name="<% out.print(props.getProperty("adminDescentValueField")); %>" class="textfield" type="text" placeholder="<% out.print(depthDecayValue); %>" disabled /> <b>m</b> 
				every   <input name="<% out.print(props.getProperty("adminDescentRateField")); %>" class="textfield" type="text" placeholder="<% out.print(depthDecayRate); %>" disabled /> Sec  |
				<% if(!depthIsDecayRunning) {
					out.print("<span class=\"notrunning\">[Descent disabled]</span>");
				} else {
					out.print("<span class=\"running\">[Descent enabled]</span>");
				}
				%>
				<br />
				<hr />
				Add Depth <input name="<% out.print(props.getProperty("depthValueInput")); %>" class="textfield" type="text" value="0" /><b> m</b>
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminDepthValueInputButton")); %>" value="add"> | 
				Start Descending:
				<input name="<% out.print(props.getProperty("depthNewDecayValue")); %>" class="textfield" type="text" value="<% out.print(depthDecayValue); %>" /> <b>m</b> every
				<input name="<% out.print(props.getProperty("depthNewDecayRate")); %>" class="textfield" type="text" value="<% out.print(depthDecayRate); %>" /> Sec 
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminDepthDecayChangeButton")); %>" value="change"> &rarr;
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminDepthDecayStartButton")); %>" value="start">
				<input class="submit" type="submit" name="<% out.print(props.getProperty("adminDepthDecayStopButton")); %>" value="stop">
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