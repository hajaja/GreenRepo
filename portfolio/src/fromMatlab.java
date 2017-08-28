import java.io.BufferedReader; 
import java.io.File; 
import java.io.FileNotFoundException; 
import java.io.FileReader; 
import java.io.IOException; 
import java.io.PrintWriter;
import java.util.StringTokenizer;

import ilog.concert.*;
import ilog.cplex.*;


public class fromMatlab {
	public static IloCplex cplex;
    public static void main(String[] args) throws IloException {
    	int statesNum = 40;
    	double [][] covMatrix = new double[statesNum][statesNum]; 
    	double [] meanSpeed = new double[statesNum];
    	IloNumExpr expr;
        double wMax = 0.5;
        double M = 1;
        double NLocation = 10;
        //double rBar = 984;
        double rBar = 0.2;
		double smallValue = -0.0001;		

    	//covMatrix = {1,2,3; 4,5,6};
    	int i,j;
        try { 
        	String path = "C:/Yun/Google/Research/Green Energy/IGCC2013/wind/TCPS/dataProcess/calculateCoefficient/";
            File csv = new File(path + "covMatrix.csv"); // CSV文件
            BufferedReader br = new BufferedReader(new FileReader(csv));
            // 读取直到最后一行 
            String line = "";
            i = 0;
            j = 0;
            
            //step 1.1 read covMatrix
            while ((line = br.readLine()) != null) { 
            	//System.out.println(line.length());
                // 把一行数据分割成多个字段 
                StringTokenizer st = new StringTokenizer(line, ",");
                //System.out.println(st.countTokens());
                j = 0;
                while (st.hasMoreTokens()) {
                    // 每一行的多个字段用TAB隔开表示 
                    //System.out.print(st.nextToken() + "/t");
                    //covMatrix[i][j] = Float.valueOf(st.nextToken());
                	//System.out.println(i);
                	//System.out.println(j);
                	covMatrix[i][j] = Double.parseDouble(st.nextToken());
                	j++;
                } 
                System.out.println(); 
                i++;
            } 
            br.close();
            
            
            //step 1.2 read meanSpeed
            csv = new File(path + "meanSpeed.csv"); // CSV文件
            br = new BufferedReader(new FileReader(csv));
            // 读取直到最后一行 
            line = "";
            i = 0;
            j = 0;

            line = br.readLine();
            StringTokenizer st = new StringTokenizer(line, ",");
            i = 0;
                while (st.hasMoreTokens()) {
                	
                    // 每一行的多个字段用TAB隔开表示 
                    //System.out.print(st.nextToken() + "/t");
                    //covMatrix[i][j] = Float.valueOf(st.nextToken());
                	//System.out.println(i);
                	//System.out.println(j);
                	//System.out.println(Double.parseDouble(st.nextToken()));
                	meanSpeed[i] = Double.parseDouble(st.nextToken());
                	i++;
                } 
                System.out.println(); 
                i++;
            br.close();
            
            //System.out.println(meanSpeed[3]);
            //System.out.println(covMatrix[23][56]);
            
            //step 2.1  variables
            	//2.1.1 w
            cplex = new IloCplex();
			// var LO-mode order of start time
            IloNumVar[] w = new IloNumVar[statesNum];
   			for(i=0; i<statesNum; i++) {
				String[] names = new String[statesNum];
				names[i] = "w"+i;
				w[i] = cplex.numVar(0, wMax, names[i]);
			}
   			
        	//2.1.2 b
			// var LO-mode order of start time
	        IloNumVar[] b = new IloNumVar[statesNum];
				for(i=0; i<statesNum; i++) {
				String[] names = new String[statesNum];
				names[i] = "b"+i;
				b[i] = cplex.boolVar(names[i]);
			}   	
				
			//2.1.3 y
		    IloNumVar[] y = new IloNumVar[statesNum];
				for(i=0; i<statesNum; i++) {
				String[] names = new String[statesNum];
				names[i] = "y"+i;
				y[i] = cplex.numVar(0, wMax, names[i]);
			}   	
				
			//step 2.2 constraints
			//2.2.1 binary 
			for (i = 1; i<statesNum; i++){
				//IloNumExpr expr = cplex.sum(cplex.prod(yLO[i][j], M), -1);
				expr = cplex.sum(y[i], cplex.prod(M, cplex.sum(1, cplex.prod(-1, b[i]))));
				cplex.addLe(w[i], expr);
			}
			for (i = 1; i<statesNum; i++){
				expr = cplex.prod(M, b[i]);
				cplex.addLe(y[i], expr);
			}
			
			// solar 
			for (i = statesNum / 2; i < statesNum; i++) {
				cplex.addLe(b[i], b[i - statesNum / 2]);
			}
			
			//2.2.2 sigma y = 1
			expr = cplex.sum(y);
			cplex.addEq(expr, 1);
			
			//2.2.3 sigma bi <= N
			expr = cplex.sum(b);
			cplex.addLe(expr, NLocation);
			
			//2.2.4 expectation 
			expr = cplex.numExpr();
			for(i = 0; i<statesNum; i++){
				expr = cplex.sum(expr, cplex.prod(y[i], meanSpeed[i]));
			}
			cplex.addGe(expr, rBar);
			
			//step 2.3 objective
			expr = cplex.numExpr();
			for(i = 0; i<statesNum; i++){
				for(j = 0; j<statesNum; j++){
					expr = cplex.sum(expr, cplex.prod(cplex.prod(y[i], y[j]), covMatrix[i][j]));
				}
			}
			cplex.addMinimize(expr);
			
			//step 3 solve
			cplex.exportModel("model.lp");
			if(cplex.solve()){
				System.out.println("seems OK");
				double[] yValues = cplex.getValues(y);
				double varValue = 0;
				for (i = 0; i<statesNum; i++){
					for (j = 0; j <statesNum; j++){
						//System.out.println(j);
						varValue = varValue + yValues[i]*yValues[j]*covMatrix[i][j];
					}
				}
				double[] bValues = cplex.getValues(b);
				int locationNum = 0;
				PrintWriter writer = new PrintWriter("wOptimal.csv");

				for (i = 0; i<statesNum; i++){
					locationNum = (int) (locationNum + bValues[i]);
					System.out.println(yValues[i]);
					writer.print(yValues[i]);
					if (i != statesNum - 1) {
						writer.print(",");
					}
					else {
						writer.print("\n");
					}
				}
				writer.close();
				System.out.println("number of locations:" + locationNum);
				System.out.println("standard deviation:" + Math.sqrt(varValue));

			}
			
        } catch (FileNotFoundException e) { 
            // 捕获File对象生成时的异常 
            e.printStackTrace(); 
        } catch (IOException e) { 
            // 捕获BufferedReader对象关闭时的异常 
            e.printStackTrace(); 
        } 
    } 
}