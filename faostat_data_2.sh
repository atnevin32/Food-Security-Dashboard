#!/bin/bash
# FOOD PRICE INFLATION DATA

# Authenticate against the endpoint
BASE_URL=https://data.apps.fao.org/gismgr/api/v2
API_KEY=ad18e2a4798c66506acd1837a131d455b8a57896bd56ce2f05dc404bf15c33fdcc4e0c48a9e5c70f
curl -X "POST" -H "X-GISMGR-API-KEY: ${API_KEY}" -H “Accept: application/json” -H "Content-Length: 0" "${BASE_URL}/catalog/identity/accounts:signInWithApiKey"

Consumer_Price_Indices=https://bulks-faostat.fao.org/production/ConsumerPriceIndices_E_All_Data_\(Normalized\).zip
Food_Security_Data=https://bulks-faostat.fao.org/production/Food_Security_Data_E_All_Data_\(Normalized\).zip
Cost_Affordability=https://bulks-faostat.fao.org/production/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).zip
Food_Balances=https://bulks-faostat.fao.org/production/FoodBalanceSheets_E_All_Data_\(Normalized\).zip
Temp_Change=https://bulks-faostat.fao.org/production/Environment_Temperature_change_E_All_Data_\(Normalized\).zip

path="fao_temp"

source .venv/bin/activate

mkdir $path

curl -X "GET" -s -o $path/out1.zip $Consumer_Price_Indices
curl -X "GET" -s -o $path/out2.zip $Food_Security_Data
curl -X "GET" -s -o $path/out3.zip $Cost_Affordability
curl -X "GET" -s -o $path/out4.zip $Food_Balances
curl -X "GET" -s -o $path/out5.zip $Temp_Change

unzip $path/'*.zip' -d $path

#Create CSV output files and copy across headers
head -n 1 $path/FoodBalanceSheets_E_All_Data_\(Normalized\).csv > $path/FBS_Supply.csv
head -n 1 $path/ConsumerPriceIndices_E_All_Data_\(Normalized\).csv > $path/CPI.csv
head -n 1 $path/Food_Security_Data_E_All_Data_\(Normalized\).csv > $path/FSD.csv 
head -n 1 $path/Food_Security_Data_E_All_Data_\(Normalized\).csv > $path/CMN.csv 
head -n 1 $path/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).csv > $path/CAHD.csv
head -n 1 $path/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).csv > $path/COHD.csv
head -n 1 $path/FoodBalanceSheets_E_All_Data_\(Normalized\).csv > $path/FBS_Losses.csv
head -n 1 $path/Environment_Temperature_change_E_All_Data_\(Normalized\).csv > $path/TCOL.csv

#Filter data down to MZ and required elements, then append to file
cat $path/ConsumerPriceIndices_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Food price inflation" | >> $path/CPI.csv
cat $path/Food_Security_Data_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Per capita food supply variability (kcal/cap/day)" >> $path/FSD.csv
cat $path/Food_Security_Data_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Number of children under 5 years" >> $path/CMN.csv
cat $path/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Cost of a healthy diet" >> $path/COHD.csv
cat $path/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "afford a healthy diet" >> $path/CAHD.csv
cat $path/FoodBalanceSheets_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Food supply" >> $path/FBS_Supply.csv
cat $path/FoodBalanceSheets_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Losses" >> $path/FBS_Losses.csv
cat $path/Environment_Temperature_change_E_All_Data_\(Normalized\).csv | grep "Mozambique" | grep "Temperature change" >> $path/TCOL.csv

#Iterate load script to populate data
#python3 load_csv.py $path/FSD.csv FAO_FoodSecurityData
python3 load_csv.py $path/CMN.csv FAO_ChildStuntedWastingOverweight
#python3 load_csv.py $path/CAHD.csv FAO_CostAffordabilityHealthyDiet
#python3 load_csv.py $path/COHD.csv FAO_CostOfHealthyDiet
#python3 load_csv.py $path/CPI.csv FAO_ConsumerPriceIndices
#python3 load_csv.py $path/FBS_Supply.csv FAO_FoodBalanceSupply
#python3 load_csv.py $path/FBS_Losses.csv FAO_FoodSupplyLosses
python3 load_csv.py $path/TCOL.csv FAO_TempChange

#Cleanup
rm -rf fao_temp

