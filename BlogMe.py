# -*- coding: utf-8 -*-
"""
Created on Wed Mar  8 12:05:37 2023

@author: 17706
"""

import pandas as pd
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

#reading an excel or xlsx files

data = pd.read_excel('articles.xlsx')


#summary of the data
data.describe()

#summary of the columns
data.info()

#count the number of articles per source
#format of groupby: df.groupby(['column_to_group'])['column_to_count'].count()


data.groupby(['source_id'])['article_id'].count()

#number of reactions by a publisher
data.groupby(['source_id'])['engagement_reaction_count'].sum()

#dropping a column
data = data.drop('engagement_comment_plugin_count', axis = 1)

#functions in python, functions are also used to create and return variables

def thisfunction():
    print('This is my first function!')

thisfunction()

#this is a function with variables 

def aboutMe(name, surname, location):
    print('This is '+name+ ' My surname is '+surname+' I am from'+location)
    return name, surname, location
    
a= aboutMe('Eric', 'Mendez', 'Atlanta')


#using forloops in functions 

def favfood(food):
    for x in food: 
        print('Top food is '+x)

    
fastfood =['tacos','pizza','pie','fries']

favfood(fastfood)

#creating a keyword flag 

keyword = 'crash'

#let's create a for loop to isolate each title row

# length= len(data)
# keyword_flag=[]
# for x in range(0,length): 
#     heading = data['title'][x]
#     if keyword in heading: 
#         flag = 1
#     else: 
#         flag = 0 
#     keyword_flag.append(flag)

#creating a function


def keywordflag(keyword):
    length = len(data)
    keyword_flag =[]
    for x in range(0, length): 
        heading = data['title'][x]
        try:
            if keyword in heading: 
                flag = 1
            else: 
                flag = 0 
        except:
            flag = 0
        keyword_flag.append(flag)
    return keyword_flag
    
keywordflag = keywordflag('murder')


# creating a new colunmn

data['keyword_flag'] = pd.Series(keywordflag)

#SentimentIntensityAnalyzer

sent_int = SentimentIntensityAnalyzer()

text = data['title'][16]
sent = sent_int.polarity_scores(text)

neg = sent['neg']

pos = sent['pos']

neu = sent['neu']

#adding a for loop to extract sentiment per title

title_neg_sentiment = []
title_pos_sentiment = []
title_neu_sentiment = []

length = len(data)

for x in range (0,length):
    try:
        text = data['title'][x]
        sent_int = SentimentIntensityAnalyzer()
        sent = sent_int.polarity_scores(text)
        neg = sent['neg']
        pos = sent['pos']
        neu = sent['neu']
    except: 
        neg = 0
        pos = 0
        neu = 0
    title_neg_sentiment.append(neg)
    title_pos_sentiment.append(pos)
    title_neu_sentiment.append(neu)

title_neg_sentiment = pd.Series(title_neg_sentiment)
title_pos_sentiment = pd.Series(title_pos_sentiment)
title_neu_sentiment = pd.Series(title_neu_sentiment)

#add the above back as columns

data['title_neg_sentiment'] = title_neg_sentiment
data['title_pos_sentiment'] = title_pos_sentiment
data['title_neu_sentiment'] = title_neu_sentiment

#writing the data/ exporting the data

data.to_excel('blogme_clean.xlsx', sheet_name= 'blogmedata', index=False)
