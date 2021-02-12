# -*- coding: utf-8 -*-
"""
Created on Fri Feb 12 11:39:22 2021

@author: utilisateur
"""
import mysql.connector as mysqlConnector
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import folium 
import json
%matplotlib inline


#####################################Graph n°1#######################################

conn = mysqlConnector.connect(host='Localhost',user='root',passwd='Rikalio1*', database='projet_foody')
if conn: 
    print('Connection Succesful')
else:
    print('Connection Failed!')
cur=conn.cursor()
cur.execute("Select NomMess,count(NoCom) as nb_commande from commande natural join messager group by NomMess;")
for row in cur:
    print(row)
x=pd.read_sql("Select NomMess,count(NoCom) as nb_commande from commande natural join messager group by NomMess;",conn)
sns.barplot(x='NomMess',y='nb_commande',data=x)


#####################################Graph n°2#######################################

conn = mysqlConnector.connect(host='Localhost',user='root',passwd='Rikalio1*', database='projet_foody')
if conn: 
    print('Connection Succesful')
else:
    print('Connection Failed!')
cur=conn.cursor()
cur.execute("Select PaysLiv,count(Distinct NoCom) as 'Nombre de commandes' from commande group by PaysLiv order by count(Distinct NoCom)desc;")
for row in cur:
    print(row)

data=pd.read_sql("Select PaysLiv,count(Distinct NoCom) as 'Nombre de commandes' from commande group by PaysLiv order by count(Distinct NoCom)desc;",conn)

sns.barplot(x='Nombre de commandes',y='PaysLiv',data=data)

#####################################Graph n°3#######################################

conn = mysqlConnector.connect(host='Localhost',user='root',passwd='Rikalio1*', database='projet_foody')
if conn: 
    print('Connection Succesful')
else:
    print('Connection Failed!')
cur=conn.cursor()
cur.execute("Select PaysLiv,count(Distinct NoCom) as 'Nombre de commandes' from commande group by PaysLiv order by count(Distinct NoCom) DESC;")
for row in cur:
    print(row)
    
url = ('https://raw.githubusercontent.com/python-visualization/folium/master/examples/data')
world_path = f"{url}/world-countries.json"
data = pd.read_sql("Select PaysLiv,count(Distinct NoCom) as 'Nombre de commandes' from commande group by PaysLiv order by count(Distinct NoCom) DESC;",conn)
data.shape

data_to_plot = data[['PaysLiv','Nombre de commandes']]
data_to_plot.head()

m = folium.Map(location=[100, 0], zoom_start=1.5)
hist_indicator =  'Number of purchases by country'
folium.Choropleth(geo_data=world_path, name="choropleth",data=data_to_plot, columns=['PaysLiv', 'Nombre de commandes'], key_on='feature.id', fill_color='YlGnBu', fill_opacity=0.7, line_opacity=0.2,legend_name=hist_indicator).add_to(m)
folium.LayerControl().add_to(m)
m