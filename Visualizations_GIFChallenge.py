#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 16 12:50:29 2017

@author: SwatzMac
@Purpose: TENOR Data Challenge - Answer 1
 
@Challenge: TENOR Data Challenge
"""

import psycopg2
import pprint
import pandas.io.sql as sql
import numpy as np
import pandas as pd
from sqlalchemy import create_engine
import seaborn as sns
import plotly as py
import plotly.graph_objs as go
import plotly.plotly as ply


# Establish Connection
try:
    conn = psycopg2.connect(host="data-challenge.cpzsedc9pony.us-west-2.redshift.amazonaws.com",database="dev", user="testuser233", password="TenorTest233",port=5439)
    print("Connected to Database")
except:
    print("Unable to connect to database")
    
cur = conn.cursor()

try:
    cur.execute("""SELECT top 10 * from ios_events""")
except:
    print("I cant select from ios_events")

#row2 = cur.fetchall()
#cur.close()
#conn.close()
#data = np.array(row2)
#print(data)

### Count per search Term - Distributions ###

## Count per search term - use this for plotting results

engine = create_engine('postgresql://testuser233:TenorTest233@data-challenge.cpzsedc9pony.us-west-2.redshift.amazonaws.com:5439/dev')
df = pd.read_sql_query("SELECT TOP 10000 tags, count(*) as num FROM ios_events WHERE tags <> '' GROUP BY tags ORDER BY num desc", engine)
df1 = pd.read_sql_query("SELECT TOP 1000 tags, count(*) as num FROM ios_events WHERE tags <> '' GROUP BY tags", engine)


# Frequency Distribution - Histogram
trace1 = go.Scatter(x=df['tags'], y=df['num'], mode='lines', name='test')
layout = go.Layout(title='Unique Searches and Count', plot_bgcolor='rgb(230, 230,230)')
fig = go.Figure(data=[trace1], layout=layout)
py.offline.plot(fig,filename='frequency distribution')


# Plot data - Bar Plot
data = [go.Bar(x=df1['tags'], y=df1['num'])]
py.offline.plot(data,filename='basic-bar')


## How many unique gifs are shared? What does the distribution look like?

### GIF's Distribution ###
#gif = pd.read_sql_query("SELECT riffid, count(*) as count FROM ios_events WHERE eventname = 'share' GROUP BY riffid HAVING count(*) > 10000 ORDER BY count desc", engine)
gif1 = pd.read_sql_query("SELECT riffid, count(*) as count FROM ios_events WHERE eventname = 'share' GROUP BY riffid HAVING count(*) < 100 and count(*) > 50 ", engine)

# Frequency Distribution Histogram
trace1 = go.Scatter(x=gif['riffid'], y=gif['count'], mode='lines', name='test1')
layout = go.Layout(title='Unique GIFs and Count', plot_bgcolor='rgb(230, 230,230)')
fig1 = go.Figure(data=[trace1], layout=layout)
py.offline.plot(fig1,filename='GIF frequency distribution')


# Scatter Plot 
print(gif['riffid'].describe())
hist = sns.distplot(gif['count'])


