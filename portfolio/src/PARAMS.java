import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedList;
import java.util.StringTokenizer;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.w3c.dom.Element;


public class PARAMS {
	// path and files
	public static String pathRoot = "C:/Yun/Google/Research/Green Energy/IGCC2013/wind/TCPS/dataProcess/";
	public static String fileSettings = pathRoot + "settings.xml";

	public static String pathCovRoot = pathRoot + "data/";
	public static String pathAnalysisRoot = pathRoot + "data/";

	public static String fileCovMatrix;
	public static String fileMeanSpeed;

	public static String fileStdMeanPairs;
	public static String fileWMatrix;
	public static String fileWOptimal;

	// read from xml
	public static String suffix;
	public static double ratioCapacity;
	public static String portType;
	public static String limit;

	public static String caseName;

	// set in Java
	public static int portNumPoints = 20;

	// read from csv
	public static int numPowers;
	public static double[][] covMatrix;
	public static double[] meanSpeed;
	public static double meanMin = 0.1; 
	public static double meanMax = 0.3; 
	public static double meanStep = (meanMax - meanMin) / portNumPoints;

	public static void set() throws ParserConfigurationException, SAXException, IOException {
		ClassXMLReader reader = new ClassXMLReader(PARAMS.fileSettings); 
		Element element = null;
		element = (Element) reader.document.getElementsByTagName("suffix").item(0);
		suffix = element.getAttribute("value");
		ratioCapacity = Double.parseDouble(element.getAttribute("ratioCapacity"));
		element = (Element) reader.document.getElementsByTagName("portType").item(0);
		portType = element.getAttribute("value");
		element = (Element) reader.document.getElementsByTagName("limit").item(0);
		limit = element.getAttribute("value");
		caseName = suffix + portType + limit; 

		setFilePaths();
		readMeanSpeed();
		readCovMatrix();
		System.out.println();
	}

	public static void setFilePaths() {
		fileCovMatrix = pathCovRoot + caseName + "/covMatrix.csv";
		fileMeanSpeed = pathCovRoot + caseName + "/meanSpeed.csv";

		fileStdMeanPairs = pathAnalysisRoot + caseName + "/stdMeanPairs.csv";
		fileWMatrix = pathAnalysisRoot + caseName + "/wMatrix.csv";
		fileWOptimal = pathAnalysisRoot + caseName + "/wOptimal.csv";
	}

	public static void readMeanSpeed() throws IOException {
		File csv = new File(fileMeanSpeed); // CSV文件
		BufferedReader br = new BufferedReader(new FileReader(csv));
		// 读取直到最后一行 
		String line = "";
		line = br.readLine();
		StringTokenizer st = new StringTokenizer(line, ",");
		LinkedList<Double> meanSpeedList = new LinkedList<Double>();
		while (st.hasMoreTokens()) {
			meanSpeedList.add(Double.parseDouble(st.nextToken()));
		}
		br.close();
		if (PARAMS.suffix.equals("Relative")) {
			numPowers = meanSpeedList.size() - 1;
			meanSpeed = new double[numPowers + 1];
		}
		else {
			numPowers = meanSpeedList.size();
			meanSpeed = new double[numPowers];
		}
		
		for (int i = 0; i < meanSpeed.length; i++) {
			meanSpeed[i] = meanSpeedList.get(i);
		}

		if (PARAMS.suffix.equals("Relative") == false) {
			meanMin = Double.MAX_VALUE;
			meanMax = Double.MIN_VALUE;
			for (int i = 0; i < meanSpeed.length; i++) {
				meanMin = Math.min(meanMin, meanSpeed[i]);
				meanMax = Math.max(meanMax, meanSpeed[i]);
			}
			meanStep = (meanMax - meanMin) / portNumPoints;
		}

	}

	public static void readCovMatrix() throws IOException {
		if (PARAMS.suffix.equals("Relative")) {
			covMatrix = new double[numPowers + 1][numPowers + 1]; 
		}
		else {
			covMatrix = new double[numPowers][numPowers]; 
		}

		File csv = new File(fileCovMatrix); // CSV文件
		BufferedReader br = new BufferedReader(new FileReader(csv));
		String line = "";
		int i = 0;
		int j = 0;

		while ((line = br.readLine()) != null) { 
			StringTokenizer st = new StringTokenizer(line, ",");
			j = 0;
			while (st.hasMoreTokens()) {
				covMatrix[i][j] = Double.parseDouble(st.nextToken());
				j++;
			} 
			System.out.println(); 
			i++;
		} 
		br.close();
	}

}
