# GreenRepo
Geographical Load Balancing (GLB) has great potential to green data centers by dispatching jobs to locations with sufficient renewable energy. However, when there is not enough renewable power anywhere, the electricity has to be drawn from the grid and the benefit is diminished. In this paper, we propose to optimize the green power portfolio of data centers to maximize the satisfaction of power demand with green energy, coined as the problem of Renewable Energy Portfolio Optimization (REPO). We observe two different types of data centers with largely different power demand patterns in the day.

For data centers with stable workload throughout the day such as those from Google, we aim to provide the highest expected power by utilizing the diversity of green power resources at different locations. We formulate the REPO problem as a Mixed Integer Quadratic Program (MIQP). For data centers with peak power demand during office hours such as those of ClarkNet or HP, we propose a method called Low Frequency Load Matching (LFLM) to match the green power portfolio with such a diurnal pattern in power demand.

We evaluate our approach with real-world workload data from Google and ClarkNet, as well as climatic information from 603 candidate locations. When simulated with the workload trace from Google, the optimal portfolio derived by solving the MIQP problem only needs 14.7% of electricity from the grid with installed capacity 5 times of the maximum power demand. As a comparison, a combination (based on Google data center locations) without consideration on mutual compensation has to draw up to 48.3% of electricity from grid. When simulated with the workload trace from ClarkNet, with installed capacity twice of the maximum power demand, the portfolio optimized for peak load matching needs 21.7% from the grid, while the portfolio optimized for providing stable supply needs to draw 25.0%.

# Folder Content
1. settings, .xml files, used to save settings for the project (prepared for parameter used in Java and Matlab)
2. calculateCoefficient, .m files, used to calculate the coefficent of potential wind/solar power at different locations. 
  Input: processed data from climatic data sets
  Output: mean speed of different locations; coefficient matrix between locations
3. portfolio, .java files, used to call CPLEX API to optimize the portfolio. 
  Input: output of calculateCoefficient
  Output: the percentage of capcaity installed at different locations
4. resultAnalysis, .m files, used analyze results and plot figures/tables in Matlab

# References
1. Fanxin Kong, Chuansheng Dong, Xue Liu, Haibo Zeng: Quantity Versus Quality: Optimal Harvesting Wind Power for the Smart Grid. Proceedings of the IEEE 102(11): 1762-1776 (2014)
2. Chuansheng Dong, Fanxin Kong, Xue Liu, Haibo Zeng: Green power analysis for Geographical Load Balancing based datacenters. IGCC 2013: 1-8
