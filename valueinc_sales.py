import pandas as pd

#file_name = pd.read_csv('file.csv) <----- format of read.csv

data = pd.read_csv('C:/Users/17706/Desktop/Data Analytics/python/transaction.csv')

data = pd.read_csv('C:/Users/17706/Desktop/Data Analytics/python/transaction.csv',sep=';')

#summary of the data

data.info()

#playing around with variables

var = 'Hello World'

var= 2.5

var = range(10)

car = { 'name':'Dee', 'Location': 'South Africa'}
 
#working withgh calculations

#defining variables

CostPerItem = 11.73
SellingPricePerItem = 21.11
NumberOfItemsPurchased= 6

#mathematical operations on tableau 

ProfitPerItem = 21.11-11.73
ProfitPeritem = SellingPricePerItem - CostPerItem

ProfitPerTransaction = NumberOfItemsPurchased * ProfitPeritem
CostPerTransaction = NumberOfItemsPurchased*CostPerItem
SellingPricePerTransaction = NumberOfItemsPurchased*SellingPricePerItem

#CostPerTransaction column calculation

#CostPerTransaction = CostPerItem * NumberOfItemsPurchased
# Variable = dataframe ['Column_name']

CostPerItem = data['CostPerItem']
NumberOfItemsPurchased = data['NumberOfItemsPurchased']


#CostPerTransaction column calculation
CostPerTransaction = CostPerItem * NumberOfItemsPurchased

#Adding new column to dataframe

data['CostPerTransaction'] = CostPerTransaction

#sales per transaction
data['SalesPerTransaction'] = data['SellingPricePerItem'] * data['NumberOfItemsPurchased']

#Calculate Profit (sales - cost) and Mark Up (Sales - cost)/cost

data['ProfitPerTransaction'] = data['SalesPerTransaction'] - data['CostPerTransaction']
data['MarkUp'] = (data['SalesPerTransaction'] - data['CostPerTransaction'])/data['CostPerTransaction']

data['MarkUp'] =data['ProfitPerTransaction'] /data['CostPerTransaction']

# rounding function used for returning a certain number of decimals -- rounding markup

RoundMarkUp = round(data['MarkUp'],2)

data['MarkUp'] = round(data['MarkUp'],2)

#combining date fields

my_name = 'Dee'+'Naido'
my_date = 'Day'+'-'+'Month'+'-'+'Year'

#Checking columns datatype

print(data['Day'].dtype)

#change columns type 
day = data['Day'].astype(str)
year = data['Year'].astype(str)

print(day.dtype)
print(year.dtype)

my_date = day+'-'+data['Month']+'-'+year
data['data'] = my_date

#using iloc to view specific coumns/rows

data.iloc[0] #shows first row of your dataframe, row with row equal to zero
data.iloc[0:3] # shows firs 3 rows 
data.iloc[-5:] # shows last 5 rows

data.head(5) #brings in the first 5 rows

data.iloc[:,2] # brings in all rows of a specific column

data.iloc[4,2] #brings in specific row, specific column -- 4th row, 2nd column

#using split to split client keywords field
#new_var = column.str.split('sep',expand = True)

split_col=data['ClientKeywords'].str.split(',', expand = True)

#creating a new column for the split columns in client keywords

data['ClientAge'] = split_col[0]
data['ClientType'] = split_col[1]
data['LengthOfContract'] = split_col[2]

#using the replace function

data['ClientAge'] = data['ClientAge'].str.replace('[','')
data['LengthOfContract'] = data['LengthOfContract'].str.replace(']','')

#usinng the lower function to change item to lowercase

data['ItemDesription'] = data['ItemDescription'].str.lower()

# how to merge files 
#bringing in a new dataset

seasons = pd.read_csv('C:/Users/17706/Desktop/Data Analytics/python/value_inc_seasons.csv',sep=';')

#merging files: merge_df= pd.merge(df_old,df_new,on = 'key')
#key is the common field 

data = pd.merge(data, seasons, on = 'Month')

# Dropping columns,we also need do drop day, month, and year bc they are redundate. 

#df = df.drop'column_name', axis = 1)

data = data.drop('ClientKeywords', axis = 1)

data = data.drop('Day', axis = 1)

data = data.drop(['Year','Month'], axis = 1)

#export into a csv

data.to_csv('ValueInc_Cleaned.csv', index = False)

