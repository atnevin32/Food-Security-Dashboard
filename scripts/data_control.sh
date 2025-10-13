#!/bin/bash
# FOOD PRICE INFLATION DATA

country_name=$1

# Authenticate against the endpoint
BASE_URL=https://data.apps.fao.org/gismgr/api/v2
API_KEY= #INSERT API KEY HERE
curl -X "POST" -H "X-GISMGR-API-KEY: ${API_KEY}" -H “Accept: application/json” -H "Content-Length: 0" "${BASE_URL}/catalog/identity/accounts:signInWithApiKey"

Consumer_Price_Indices=https://bulks-faostat.fao.org/production/ConsumerPriceIndices_E_All_Data_\(Normalized\).zip
Food_Security_Data=https://bulks-faostat.fao.org/production/Food_Security_Data_E_All_Data_\(Normalized\).zip
Cost_Affordability=https://bulks-faostat.fao.org/production/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).zip
Food_Balances=https://bulks-faostat.fao.org/production/FoodBalanceSheets_E_All_Data_\(Normalized\).zip
Temp_Change=https://bulks-faostat.fao.org/production/Environment_Temperature_change_E_All_Data_\(Normalized\).zip

path=`pwd`"/fao_temp"
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

#Filter data down to country and required elements, then append to file
cat $path/ConsumerPriceIndices_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Food price inflation" | >> $path/CPI.csv
cat $path/Food_Security_Data_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Per capita food supply variability (kcal/cap/day)" >> $path/FSD.csv
cat $path/Food_Security_Data_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Number of children under 5 years" >> $path/CMN.csv
cat $path/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Cost of a healthy diet" >> $path/COHD.csv
cat $path/Cost_Affordability_Healthy_Diet_\(CoAHD\)_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "afford a healthy diet" >> $path/CAHD.csv
cat $path/FoodBalanceSheets_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Food supply" >> $path/FBS_Supply.csv
cat $path/FoodBalanceSheets_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Losses" >> $path/FBS_Losses.csv
cat $path/Environment_Temperature_change_E_All_Data_\(Normalized\).csv | grep "$country_name" | grep "Temperature change" >> $path/TCOL.csv


echo "Loading FAO data set..."
#Iterate load script to populate data
python3 data_upload.py $1 csv $path/FSD.csv FAO_FoodSecurityData
python3 data_upload.py $1 csv $path/CMN.csv FAO_ChildStuntedWastingOverweight
python3 data_upload.py $1 csv $path/CAHD.csv FAO_CostAffordabilityHealthyDiet
python3 data_upload.py $1 csv $path/COHD.csv FAO_CostOfHealthyDiet
python3 data_upload.py $1 csv $path/CPI.csv FAO_ConsumerPriceIndices
python3 data_upload.py $1 csv $path/FBS_Supply.csv FAO_FoodBalanceSupply
python3 data_upload.py $1 csv $path/FBS_Losses.csv FAO_FoodSupplyLosses
python3 data_upload.py $1 csv $path/TCOL.csv FAO_TempChange

echo "Loading Worldbank dataset..."
python3 data_upload.py $1 json https://api.worldbank.org/v2/country/moz/indicator/SP.POP.GROW?format=json WB_PopulationGrowth
python3 data_upload.py $1 json https://api.worldbank.org/v2/country/moz/indicator/FP.CPI.TOTL.ZG?format=json WB_ConsumerPriceInflation 
python3 data_upload.py $1 json https://api.worldbank.org/v2/country/moz/indicator/IP.IDS.RSCT?format=json WB_IndustrialDesignApplications

echo "Loading IDX dataset..."
python3 data_upload.py $1 json affected-people/refugees-persons-of-concern IDX_Refugees
python3 data_upload.py $1 json affected-people/humanitarian-needs IDX_Humanitarian
python3 data_upload.py $1 json affected-people/returnees IDX_returnees
echo "Loaded 'Affected people'"

python3 data_upload.py $1 json coordination-context/operational-presence IDX_OperationalPresence
python3 data_upload.py $1 json coordination-context/funding IDX_Funding
python3 data_upload.py $1 json coordination-context/conflict-events IDX_ConflictEvents
python3 data_upload.py $1 json coordination-context/national-risk IDX_NationalRisk
echo "Loaded 'Coordination Context'"

python3 data_upload.py $1 json food-security-nutrition-poverty/food-security IDX_FoodSecurity
python3 data_upload.py $1 json food-security-nutrition-poverty/food-prices-market-monitor IDX_FoodPrices
python3 data_upload.py $1 json food-security-nutrition-poverty/poverty-rate IDX_PovertyRate
echo "Loaded 'Food Security Nutrition Poverty'"

python3 data_upload.py $1 json geography-infrastructure/baseline-population IDX_BaselinePopulation
echo "Loaded 'Geography Infrastructure'"

python3 data_upload.py $1 json climate/rainfall IDX_Rainfall
echo "Loaded 'Climate Rainfall data'"

rm -rf fao_temp

