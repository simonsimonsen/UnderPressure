package controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.FileDao;

/**
 * Servlet implementation class UnderPressureServlet
 */
@WebServlet("/UnderPressureServlet")
public class UnderPressureServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	InputStream viewStream = getStream("ViewElements.properties");
	Properties viewProps = new Properties();

	InputStream pathStream = getStream("FilePaths.properties");
	Properties pathProps = new Properties();
	
	private final String stromTable;
	private final String depthTable;
	private final String waterTable;
	private final String deepflightTable;
	private final String simplePassPhrase;

	/**
	 * All Variables for Strom
	 */
	private Integer currentStromValue;
	private final int startStromValue = 100;
	private FileDao stromFile;
	private List<Integer> stromValues;
	private long stromDecayRate = 360000; // 3 Sekunden
	private long stromDecayValue = 1;
	public boolean isStromDecayRunning;

	/**
	 * All Variables for Depth 
	 */
	private Integer currentDepthValue;
	private final int startDepthValue = 10;
	private FileDao depthFile;
	private List<Integer> depthValues;
	private long descentAmount = 10; // Meter
	private long descentRate = 30000; // 1 Sekunde
	private Integer fluctuationAmount = 10;
	public boolean isDescending;
	public boolean isFluctuating;

	/**
	 * All Variables for WaterTemperature 
	 */
	private Integer currentWaterTemperature;
	private final int startWaterTemperatureValue = 10;
	private FileDao waterTemperatureFile;
	private List<Integer> waterTemperatureValues;

	/**
	 * All Variables for Deepflight Power 
	 */
	private Integer currentDeepflightPower;
	private final int startDeepflightPowerValue = 100;
	private FileDao deepflightPowerFile;
	private List<Integer> deepflightPowerValues;

	public enum ValueEnum {
		STROM, TIEFE, TEMPERATUR, DEEPFLIGHTPOWER
	}

	@Override
	public void init() {
	}

	public UnderPressureServlet() {
		super();
		try {
			viewProps.load(viewStream);
			pathProps.load(pathStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		this.stromTable = pathProps.getProperty("stromTable");
		this.depthTable = pathProps.getProperty("depthTable");
		this.waterTable = pathProps.getProperty("waterTable");
		this.deepflightTable = pathProps.getProperty("deepflightTable");
		this.simplePassPhrase = pathProps.getProperty("simplePassPhrase"); 

		// Initialize Stromvariables
		this.currentStromValue = startStromValue;
		this.stromFile = new FileDao(stromTable);
		this.stromValues = new ArrayList<Integer>();
		this.isStromDecayRunning = false;

		// Initialize Depthvariables
		this.currentDepthValue = startDepthValue;
		this.depthFile = new FileDao(depthTable);
		this.depthValues = new ArrayList<Integer>();
		this.isDescending = false;
		this.isFluctuating = false;

		// Initialize Water Temperature Variables
		this.currentWaterTemperature = startWaterTemperatureValue;
		this.waterTemperatureFile = new FileDao(waterTable);
		this.waterTemperatureValues = new ArrayList<Integer>();

		// Initialize DeepflightPower Variables
		this.currentDeepflightPower = startDeepflightPowerValue;
		this.deepflightPowerFile = new FileDao(deepflightTable);
		this.deepflightPowerValues = new ArrayList<Integer>();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("jsp/index.jsp").forward(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		boolean isAdmin = false;
		if (request.getParameter("admin") != null) {
			if (request.getParameter("admin").equals(simplePassPhrase)) {
				isAdmin = true;
			}
		}
		
		// USER PANEL
		if ((request.getParameter("userRefresh") != null) && (!isAdmin)) {
			handleUserPanelStrom(request, response);
			handleUserPanelDepth(request, response);
			handleUserPanelWaterTemperature(request, response);
			handleUserPanelDeepflightPower(request,response);
		}

		// ADMIN PANEL
		if (isAdmin) {
			handleAdminPanelStrom(request, response);
			handleAdminPanelDepth(request, response);
			handleAdminPanelWaterTemperature(request, response);
			handleAdminPanelDeepflightPower(request,response);
		}
		request.getRequestDispatcher("jsp/index.jsp").forward(request,response);
	}
	
	// USER Strom
	public void handleUserPanelStrom(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		updateRowAndColumn(ValueEnum.STROM);
		setValuesToResponse(this.stromValues, ValueEnum.STROM, request, response);
	}

	// USER Depth
	public void handleUserPanelDepth(HttpServletRequest request,
			HttpServletResponse response) throws IOException, ServletException {
		updateRowAndColumn(ValueEnum.TIEFE);
		setValuesToResponse(this.depthValues, ValueEnum.TIEFE, request, response);
	}

	// USER Deepflight Power
	public void handleUserPanelDeepflightPower(HttpServletRequest request,
			HttpServletResponse response) throws IOException, ServletException {
		updateRowAndColumn(ValueEnum.DEEPFLIGHTPOWER);
		setValuesToResponse(this.deepflightPowerValues, ValueEnum.DEEPFLIGHTPOWER, request, response);
	}

	// USER Water Temperature
	public void handleUserPanelWaterTemperature(HttpServletRequest request,
			HttpServletResponse response) throws IOException, ServletException {
		updateRowAndColumn(ValueEnum.TEMPERATUR);
		setValuesToResponse(this.waterTemperatureValues, ValueEnum.TEMPERATUR, request, response);
	}

	// --------------------------------- ADMIN PANELS -----------------------------------------------
	// ADMIN Strom
	public void handleAdminPanelStrom(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		// Handle Add Power Button
		if (request.getParameter(viewProps.getProperty("adminStromValueInputButton")) != null) {
			if (request.getParameter(viewProps.getProperty("stromValueInput")) != null) {
				Integer currentStromValue = this.currentStromValue;
				Integer stromChangeValue = Integer.parseInt(request.getParameter(viewProps.getProperty("stromValueInput"))); 
				if (currentStromValue+stromChangeValue >= 100) {
					setCurrentStromValue(100);
				} else if (currentStromValue+stromChangeValue <= 0) {
					setCurrentStromValue(0);
				} else {
					setCurrentStromValue(currentStromValue+stromChangeValue);	
				}
			}
		}

		// Handle Change Decay Button
		if (request.getParameter(viewProps.getProperty("adminStromDecayChangeButton")) != null) {
			if (request.getParameter(viewProps.getProperty("stromNewDecayValue")) != null) {
				Integer stromDecayValue = Integer.parseInt(request.getParameter(viewProps.getProperty("stromNewDecayValue"))); 
				int dv = stromDecayValue;
				setStromDecayValue(dv);
			}
			if (request.getParameter(viewProps.getProperty("stromNewDecayRate")) != null) {
				Integer stromDecayRate = Integer.parseInt(request.getParameter(viewProps.getProperty("stromNewDecayRate"))); 
				int dr = stromDecayRate*1000;
				setStromDecayRate(dr);
			}
			setStromDecayRunning(false);
			startStromDecay();
		}

		// Start Decay
		if (request.getParameter(viewProps.getProperty("adminStromDecayStartButton")) != null && (!isStromDecayRunning())) {
			setStromDecayRunning(true);
			startStromDecay();
		}

		// Stop Decay
		if (request.getParameter(viewProps.getProperty("adminStromDecayStopButton")) != null && (isStromDecayRunning())) {
			setStromDecayRunning(false);
			startStromDecay();
		}
		request.setAttribute(viewProps.getProperty("stromValue"), this.currentStromValue);
		request.setAttribute(viewProps.getProperty("stromDecayValue"), this.stromDecayValue);
		request.setAttribute(viewProps.getProperty("stromDecayRate"), fromMillisToSeconds(this.stromDecayRate));
		request.setAttribute(viewProps.getProperty("stromIsDecayRunning"), this.isStromDecayRunning);
		updateRowAndColumn(ValueEnum.STROM);		
		setValuesToResponse(this.stromValues, ValueEnum.STROM, request, response);
	}

	// ADMIN Depth
	public void handleAdminPanelDepth(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		
		if (request.getParameter("depthChangeAction") != null) {
			if (request.getParameter("depthChangeValue") != null) {
				Integer currentDepthValue = this.currentDepthValue;
				Integer depthChangeValue = Integer.parseInt(request.getParameter("depthChangeValue")); 
				if (currentDepthValue+depthChangeValue >= 2000) {
					setCurrentDepthValue(2000);
				} else if (currentDepthValue+depthChangeValue <= 0) {
					setCurrentDepthValue(depthChangeValue);
				} else {
					setCurrentDepthValue(currentDepthValue+depthChangeValue);	
				}
			}
		}

		if (request.getParameter("descentChangeAction") != null) {
			if (request.getParameter("depthDecayValue") != null) {
				Integer depthDecayValue = Integer.parseInt(request.getParameter("depthDecayValue")); 
				int dv = depthDecayValue;
				setDescentAmount(dv);
			}
			if (request.getParameter("depthDecayInterval") != null) {
				Integer depthDecayInterval = Integer.parseInt(request.getParameter("depthDecayInterval")); 
				int di = depthDecayInterval*1000;
				setDescentRate(di);
			}
			setDescending(false);
			startDescending();
		}

		if (request.getParameter("startDescending") != null && (!isDescending())) {
			setDescending(true);
			startDescending();
		}

		if (request.getParameter("stopDescending") != null && (isDescending())) {
			setDescending(false);
			startDescending();
		}

		if (request.getParameter("startFluctating") != null && (!isFluctuating() && (!isDescending()))) {
			setFluctuating(true);
		}

		if (request.getParameter("stopFluctating") != null && (isFluctuating() && (!isDescending()))) {
			setFluctuating(false);
		}

		updateRowAndColumn(ValueEnum.TIEFE);
		request.setAttribute("showAdminDepthValue", this.currentDepthValue);
		request.setAttribute("showAdminDepthDecayAmount", this.descentAmount);
		request.setAttribute("showAdminDepthDecayRate", fromMillisToSeconds(this.descentRate));
		request.setAttribute("showAdminIsDepthDecayRunning", this.isDescending());
		request.setAttribute("showAdminIsFluctating", this.isFluctuating);
		request.setAttribute("showAdminFluctuationAmount", this.fluctuationAmount);

		if (this.depthValues.size() >= 1) {
			request.setAttribute("showAdminDepthValueRow", this.depthValues.get(0));
			request.setAttribute("showAdminDepthValueColumn", this.depthValues.get(1));
		} else {
			PrintWriter writer = response.getWriter();
			writer.println("<span class=\"error\">No DepthValues in List" + this.depthValues.toString() + "</span>");
			writer.close();
		}
	}

	public void handleAdminPanelWaterTemperature(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		if (request.getParameter("waterTemperatureChangeAction") != null) {
			if (request.getParameter("newWaterTemperature") != null) {
				Integer newWaterTemperature = Integer.parseInt(request.getParameter("newWaterTemperature")); 
				if (newWaterTemperature >= 100) {
					this.currentWaterTemperature = 100;
				} else if (newWaterTemperature <= 4) {
					this.currentWaterTemperature = 4;
				} else {
					this.currentWaterTemperature = newWaterTemperature;
				}
			}
		}

		updateRowAndColumn(ValueEnum.TEMPERATUR);
		request.setAttribute("showAdminWaterTemperatureValue", this.currentWaterTemperature);

		if (this.stromValues.size() >= 1) {
			request.setAttribute("showAdminWaterTemperatureValueRow", this.waterTemperatureValues.get(0));
			request.setAttribute("showAdminWaterTemperatureValueColumn", this.waterTemperatureValues.get(1));
		} else {
			PrintWriter writer = response.getWriter();
			writer.println("<span class=\"error\">No StromValues in List" + this.waterTemperatureValues.toString() + "</span>");
			writer.close();
		}
	}

	public void handleAdminPanelDeepflightPower(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		if (request.getParameter("deepflightPowerChangeAction") != null) {
			if (request.getParameter("newDeepflightPower") != null) {
				Integer newDeepflightPower = Integer.parseInt(request.getParameter("newDeepflightPower")); 
				if (newDeepflightPower >= 100) {
					this.currentDeepflightPower = 100;
				} else if (newDeepflightPower <= 1) {
					this.currentDeepflightPower = 1;
				} else {
					this.currentDeepflightPower = newDeepflightPower;
				}
			}
		}

		updateRowAndColumn(ValueEnum.DEEPFLIGHTPOWER);
		request.setAttribute("showAdminDeepflightPowerValue", this.currentDeepflightPower);

		if (this.stromValues.size() >= 1) {
			request.setAttribute("showAdminDeepflightPowerValueRow", this.deepflightPowerValues.get(0));
			request.setAttribute("showAdminDeepflightPowerValueColumn", this.deepflightPowerValues.get(1));
		} else {
			PrintWriter writer = response.getWriter();
			writer.println("<span class=\"error\">No StromValues in List" + this.deepflightPowerValues.toString() + "</span>");
			writer.close();
		}
	}


	@Override
	public void destroy() {
		// do nothing
	}

	//	----------------------  GETTERS AND SETTERS --------------------------
	public Integer getCurrentStromValue() {
		return this.currentStromValue;
	}

	public void setCurrentStromValue(Integer newStromValue) {
		this.currentStromValue = newStromValue;
	}

	public void addToCurrentStromValue(Integer stromBonus) {
		this.currentStromValue += stromBonus;
	}

	public long getStromDecayRate() {
		return this.stromDecayRate;
	}

	public void setStromDecayRate(long stromDecayRate) {
		this.stromDecayRate = stromDecayRate;
	}
	
	public long getStromDecayValue() {
		return this.stromDecayValue;
	}

	public void setStromDecayValue(long stromDecayValue) {
		this.stromDecayValue = stromDecayValue;
	}

	public boolean isStromDecayRunning() {
		return isStromDecayRunning;
	}

	public void setStromDecayRunning(boolean isStromDecayRunning) {
		this.isStromDecayRunning = isStromDecayRunning;
	}

	public Integer getCurrentDepthValue() {
		return this.currentDepthValue;
	}

	private void setCurrentDepthValue(Integer newDepthValue) {
		this.currentDepthValue = newDepthValue;
	}

	public long getDescentAmount() {
		return descentAmount;
	}

	public void setDescentAmount(long descentAmount) {
		this.descentAmount = descentAmount;
	}

	public long getDescentRate() {
		return descentRate;
	}

	public void setDescentRate(long descentRate) {
		this.descentRate = descentRate;
	}

	public boolean isDescending() {
		return isDescending;
	}

	public void setDescending(boolean isDescending) {
		this.isDescending = isDescending;
	}

	public boolean isFluctuating() {
		return isFluctuating;
	}

	public Integer getFluctuationAmount() {
		return fluctuationAmount;
	}

	public void setFluctuationAmount(Integer fluctuationAmount) {
		this.fluctuationAmount = fluctuationAmount;
	}

	public void setFluctuating(boolean isFluctuating) {
		this.isFluctuating = isFluctuating;
	}
	
	
	/**
	 * ---------------------------- HELPER METHODS ---------------------------------------
	 */
	
	public InputStream getStream (String relativePath) {
		InputStream stream = this.getClass().getClassLoader().getResourceAsStream(relativePath);
		return stream;
	}
	
	public long fromMillisToSeconds(long millis) {
		long seconds = Math.round((millis / 1000));
		return seconds;
	}
	
	public void updateRowAndColumn(ValueEnum value) {
		switch (value) {
		case STROM:
			this.stromValues = this.stromFile.findValue(this.currentStromValue);
			break;
		case TIEFE:
			this.depthValues = this.depthFile.findValue(this.currentDepthValue);
			break;
		case TEMPERATUR:
			this.waterTemperatureValues = this.waterTemperatureFile.findValue(this.currentWaterTemperature);
			break;
		case DEEPFLIGHTPOWER:
			this.deepflightPowerValues = this.deepflightPowerFile.findValue(this.currentDeepflightPower);
			break;
		default:
			break;
		}
	}

	public void setValuesToResponse(List<Integer> valueList, ValueEnum value, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String row = "";
		String col = "";

		switch (value) {
		case STROM:
			row = this.viewProps.getProperty("stromValueRow");
			col = this.viewProps.getProperty("stromValueCol");
			break;
		case TIEFE:
			row = this.viewProps.getProperty("depthValueRow");
			col = this.viewProps.getProperty("depthValueCol");
			break;
		case TEMPERATUR:
			row = this.viewProps.getProperty("waterTemperatureValueRow");
			col = this.viewProps.getProperty("waterTemperatureValueCol");
			break;
		case DEEPFLIGHTPOWER:
			row = this.viewProps.getProperty("deepflightPowerValueRow");
			col = this.viewProps.getProperty("deepflightPowerValueCol");
			break;
		default:
			break;
		}
		if (valueList.size() >= 1) {
			request.setAttribute(row, valueList.get(0));
			request.setAttribute(col, valueList.get(1));
		} else {
			PrintWriter writer = response.getWriter();
			writer.println("<span class=\"error\">No Values in List" + valueList.toString() + "</span>");
			writer.close();
		}
	}

	public void startStromDecay() {
		long delay = 1000;
		long period = this.stromDecayRate;
		final Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {

			@Override
			public void run() {
				if (!isStromDecayRunning()) {
					timer.cancel();
					return;
				}

				Long decayAmount = getStromDecayValue();
				final int stromValueOld = getCurrentStromValue();
				final int stromDecayAmount = decayAmount.intValue();
				if (stromValueOld <= 0) {
					timer.cancel();
					return;
				}
				setCurrentStromValue(stromValueOld-stromDecayAmount);;
			}

		}, delay, period);
	}

	public void startDescending() {
		long delay = 1000;
		long period = getDescentRate();
		final Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {

			@Override
			public void run() {
				if (!isDescending()) {
					timer.cancel();
					return;
				}

				Long dAmount = getDescentAmount();
				final int depthValueOld = getCurrentDepthValue();
				final int descentAmount = dAmount.intValue();
				if (depthValueOld <= 0) {
					timer.cancel();
					return;
				}
				setCurrentDepthValue(depthValueOld+descentAmount);;
			}

		}, delay, period);
	}



}
