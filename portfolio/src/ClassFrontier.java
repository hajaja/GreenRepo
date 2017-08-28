import ilog.concert.IloException;
import ilog.concert.IloNumExpr;
import ilog.concert.IloNumVar;
import ilog.cplex.IloCplex;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.StringTokenizer;


public class ClassFrontier {
	private double[] meanVec = new double[PARAMS.portNumPoints];
	private double[] stdVec = new double[PARAMS.portNumPoints];
	private double[] numLocationsVec = new double[PARAMS.portNumPoints];
	private double[][] wMatrix = new double[PARAMS.portNumPoints][PARAMS.numPowers];
	public ClassFrontier() throws IloException, FileNotFoundException {
		IloCplex cplex = new IloCplex();
		for (int n = 0; n < PARAMS.portNumPoints; n++){
			cplex.clearModel();
			double meanValue = PARAMS.meanMin + PARAMS.meanStep * n;
			onePort(cplex, n, meanValue);
			System.out.println(n + "," + meanValue);
		}
		write();
	}

	public void onePort(IloCplex cplex, int nPort, double meanValue) throws IloException, FileNotFoundException {
		double wMin = 0.05;
		double wMax = 0.35;
		double M = 1;
		double NLocation = 10;
		double rBar = meanValue;
		double smallValue = -0.0001;	
		int i, j;
		IloNumExpr expr;

		// set constraints according to XML
		if (PARAMS.limit.equals("All")) {
			NLocation = 100;
		}
		else if (PARAMS.limit.equals("Ten")) {
			NLocation = 10;
		}
		else {
			System.out.println("Error: incorrect PARAMS.limit");
			System.exit(0);
		}


		//step 2.1  variables
		//2.1.1 w
		// var LO-mode order of start time
		IloNumVar[] w = new IloNumVar[PARAMS.numPowers];
		for(i=0; i<PARAMS.numPowers; i++) {
			String[] names = new String[PARAMS.numPowers];
			names[i] = "w"+i;
			w[i] = cplex.numVar(wMin, wMax, names[i]);
		}

		//2.1.2 b
		// var LO-mode order of start time
		IloNumVar[] b = new IloNumVar[PARAMS.numPowers];
		for(i=0; i<PARAMS.numPowers; i++) {
			String[] names = new String[PARAMS.numPowers];
			names[i] = "b"+i;
			b[i] = cplex.boolVar(names[i]);
		}   	

		//2.1.3 y
		IloNumVar[] y = new IloNumVar[PARAMS.numPowers];
		for(i=0; i<PARAMS.numPowers; i++) {
			String[] names = new String[PARAMS.numPowers];
			names[i] = "y"+i;
			y[i] = cplex.numVar(0, wMax, names[i]);
		}   	

		//step 2.2 constraints
		//2.2.1 binary 
		for (i = 1; i<PARAMS.numPowers; i++){
			//IloNumExpr expr = cplex.sum(cplex.prod(yLO[i][j], M), -1);
			expr = cplex.sum(y[i], cplex.prod(M, cplex.sum(1, cplex.prod(-1, b[i]))));
			cplex.addLe(w[i], expr);
		}
		for (i = 1; i<PARAMS.numPowers; i++){
			expr = cplex.prod(M, b[i]);
			cplex.addLe(y[i], expr);
		}

		// solar only exists when wind is selected for a location
		if (PARAMS.portType.equals("WindSolar")){
			for (i = PARAMS.numPowers / 2; i < PARAMS.numPowers; i++) {
				cplex.addLe(b[i], b[i - PARAMS.numPowers / 2]);
			}
		}
		//2.2.2 sigma y = 1
		expr = cplex.sum(y);
		if (PARAMS.suffix.equals("Relative")) {
			cplex.addEq(expr, 1 - rBar);
		}
		else {
			cplex.addEq(expr, 1);
		}

		//2.2.3 sigma bi <= N
		expr = cplex.sum(b);
		cplex.addLe(expr, NLocation);

		//2.2.4 expectation 
		expr = cplex.numExpr();
		IloNumVar sumExp = cplex.numVar(0, 1);

		for(i = 0; i<PARAMS.numPowers; i++){
			expr = cplex.sum(expr, cplex.prod(y[i], PARAMS.meanSpeed[i]));
		}
		cplex.addEq(sumExp, expr);

		if (PARAMS.suffix.equals("Relative")) {
			expr = cplex.sum(expr, rBar * PARAMS.meanSpeed[PARAMS.numPowers]);
			cplex.addGe(expr, 0);
			
		}
		else {
			cplex.addGe(expr, rBar);
		}
		
		//step 2.3 objective
		expr = cplex.numExpr();
		for(i = 0; i<PARAMS.numPowers; i++){
			for(j = 0; j<PARAMS.numPowers; j++){
				expr = cplex.sum(expr, cplex.prod(cplex.prod(y[i], y[j]), PARAMS.covMatrix[i][j]));
			}
		}
		if (PARAMS.suffix.equals("Relative")) {
			for(i = 0; i<PARAMS.numPowers; i++){
				expr = cplex.sum(expr, cplex.prod(cplex.prod(y[i], rBar), 2*PARAMS.covMatrix[i][PARAMS.numPowers]));
			}		
			expr = cplex.sum(expr, rBar * rBar * PARAMS.covMatrix[PARAMS.numPowers][PARAMS.numPowers]);
		}
		cplex.addMinimize(expr);

		//step 3 solve
		cplex.exportModel("model.lp");
		if(cplex.solve()){
			System.out.println("seems OK");

			// variance
			double[] yValues = cplex.getValues(y);
			double varValue = 0;
			for (i = 0; i<PARAMS.numPowers; i++){
				for (j = 0; j <PARAMS.numPowers; j++){
					//System.out.println(j);
					varValue = varValue + yValues[i]*yValues[j]*PARAMS.covMatrix[i][j];
				}
			}
			
			if (PARAMS.suffix.equals("Relative")) {
				for (i = 0; i <PARAMS.numPowers; i++){
					//System.out.println(j);
					varValue = varValue + 2 * yValues[i] * rBar * PARAMS.covMatrix[i][PARAMS.numPowers];
				}
				varValue = varValue + rBar * rBar * PARAMS.covMatrix[PARAMS.numPowers][PARAMS.numPowers];
			}
			
			double[] bValues = cplex.getValues(b);
			int locationNum = 0;

			// w 
			for (i = 0; i < yValues.length; i++) {
				wMatrix[nPort][i] = yValues[i];
				System.out.println("weight: " + i + " " + yValues[i]);
			}

			// total number of locations selected
			if (PARAMS.portType.equals("WindSolar")) {
				for (i = 0; i<PARAMS.numPowers / 2; i++){
					if (yValues[i] > 0) {
						locationNum += 1;
					}
				}
			}
			else {
				for (i = 0; i<PARAMS.numPowers; i++){
					if (yValues[i] > 0) {
						locationNum += 1;
					}				
				}
			}

			if (PARAMS.suffix.equals("Relative")) {
				stdVec[nPort] = Math.sqrt(varValue) / (1 - meanValue);
				meanVec[nPort] = meanValue / (1 - meanValue);
				numLocationsVec[nPort] = locationNum;
				for (i = 0; i < yValues.length; i++) {
					wMatrix[nPort][i] = yValues[i] / (1 - meanValue);
				}
			}
			else {
				stdVec[nPort] = Math.sqrt(varValue);
				meanVec[nPort] = meanValue;
				numLocationsVec[nPort] = locationNum;
			}
			
			System.out.println("standard deviation:" + stdVec[nPort]);
			System.out.println("mean:" + meanVec[nPort]);
			System.out.println("number of locations:" + numLocationsVec[nPort]);
			System.out.println("weighted sum of expectation:" + cplex.getValue(sumExp));

		}
	}

	public void write() throws FileNotFoundException {
		// write wMatrix
		PrintWriter writer = new PrintWriter(PARAMS.fileWMatrix);
		for (int n = 0; n < PARAMS.portNumPoints; n++)
			for (int i = 0; i<PARAMS.numPowers; i++){
				writer.print(wMatrix[n][i]);
				if (i != PARAMS.numPowers - 1) {
					writer.print(",");
				}
				else {
					writer.print("\n");
				}
			}
		writer.close();

		// write std mean numLocations 
		writer = new PrintWriter(PARAMS.fileStdMeanPairs);
		for (int n = 0; n < PARAMS.portNumPoints; n++){
			if (stdVec[n] == 0) {
				break;
			}
			writer.print(stdVec[n] + ",");
			writer.print(meanVec[n] + ",");
			writer.print(numLocationsVec[n] + "\n");
		}
		writer.close();
	}
}
