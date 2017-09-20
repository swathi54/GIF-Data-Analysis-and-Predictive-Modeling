# GIF-Data-Analysis-and-Predictive-Modeling
Analyzing User Sessions, Click/ Share/ Search Rate for GIFs, Predictive Model Building and Graph DB Analysis on GIF events data

Visualizations_GIFChallenge.py - The distribution resembles a PROBABILITY DENSITY FUNCTION (PDF) graph. The histogram plotted shows properties of underlying data which is plotted on “tags” and their counts. 
frequency distribution.html, Basic-bar.html, Searches-Count.html  are the Plotly graphs for this data 

Advanced Metrics:
SessionRecords_GIFChallenge.R - The session sequence number starts at 1 for each visitor and is incremented whenever the time interval is 
greater than 10seconds This is done as follows: 
1.	Compute the time lag, in mins, from prior record 
2.	Set session flag as True or False when: True = there is no prior record for visitor OR False = lag to prior record is > 10secs/ 5 seconds
3.	Perform Cumulative sum of session flags to get session sequence number

Experimental design (hint: A/B testing):
- Suppose you've built a new model for the search engine that you'd like to test against the current model.
* How would you measure the effectiveness of the new model?
* What additional data would you need in the dataset to compare the effectiveness of the new vs. current models?
* How would you determine the statistical significance of the results?

Predictive Modeling - Apply k-means Clustering, followed by Classification; Can also apply this data within Neo4j GraphDB software 
in order to understand keyword dependencies between each other 

