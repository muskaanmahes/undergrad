*****************************************************;
* STAT 3304;  * Professor Zoltan;
* Role Play - You're hired as a data scientist
* I am the high-profile CEO of a cutting edge data firm
* I hired you because of your SAS skills
* I need you to make sure the data is correct
* before I give my presentation to important clients
*
* Proprietary code from the senior programmers
* including SAS capabilites: Functions, PROC Transpose,
* Arrays, Do/End, Do Loops, Retain, .First .Last;
*****************************************************;

**********************************************
* Data Preparation, Quick Merge, Clean Merge *
**********************************************;

*libname statement;
libname mysaslib "C:\SASDATA";

*set SAS dataset of countries;
data Countries;
	set mysaslib.countries;
run;
proc sort data=Countries;
	by Continent;
run;

*set SAS dataset of continents and rename Name=Continent;
data Continents;
	set mysaslib.continents;
	rename Name=Continent;
	label Name="Continent";
run;
proc sort data=Continents;
	by Continent;
run;

*Data Step to merge countries and continents data by Continent, into new dataset CC;
data CC;
	merge Countries Continents;
	by Continent;
run;

*Notice the warning about the BY variable Continent in the merge.
* Because the length of Name is $35. (continent name in Continent dataset),
* while the length of Continent is $30. (continent name in Countries dataset);

* Make the correction to merge without errors;

data Continents;
	format Continent $30.;
	length Continent $30.;
	set mysaslib.continents;
	Continent=put(Name,$35.);
run;
proc sort data=Continents;
	by Continent;
run;

*Next some cleanup for the Countries dataset;

data Countries;
	set Countries;
	if Name = "Bermuda" then Continent = "North America";
	if Name = "Iceland" then Continent = "Europe";
	if Name = "Kalaallit Nunaat" then Continent = "North America";
run;
proc sort data=Countries;
	by Continent;
run;

*Data Step to prepare Continent dataset for clean merge:
*Use implicit retain (N+1) to add a numerical variable to the Continent dataset,
 numbering the continents (instead of N, can call it ContNum or similar);

data Continents;
	set Continents;
	rename Area=ContArea;
	drop Name;
	ContNum+1;
run;

*Redo Data Step to merge countries and continents data BY Continent, into a new dataset CC;
data CC;
	merge Countries Continents;
	by Continent;
run;


***************************************
* Retain, .First and .Last, Output #1 *
***************************************;

data CC(drop=SumPop SumArea ContDensity)
	 CCtotal(keep=Continent ContArea ContNum SumPop SumArea ContDensity);
	set CC;
	by Continent;
	format Density ContDensity 10.2;
	Density = Population/Area;
	retain SumPop SumArea 0;
	if first.Continent then do;
		SumPop = 0;
		SumArea = 0;
	end;
	SumPop = SumPop + Population;
	SumArea = SumArea + Area;
	if last.Continent then do;
		ContDensity = SumPop/SumArea;
		output CCtotal;
	end;
	output CC;
run;

*Do a PROC Print of the CCtotal dataset and paste it into your output;
proc print data=CCtotal;
run;

*Look at CCtotal dataset - ContArea is similar to SumArea, except for 2 continents.
*Is there a large transcontinental country, which could be classified as partially in different continents?;

**************************************
* PROC Transpose, Array, and Do Loop *
**************************************;

*Now use PROC Transpose on the Countries data (CC) into a new dataset (trCC),
*BY continent, VAR Population Area, and ID Name (the country);
proc transpose data=CC out=trCC;
	by Continent;
	var Population Area;
	id Name;
run;

*There is one continent in trCC that has no Countries.  Use a Data Step to delete rows for that Continent from trCC;

data trCC;
	set trCC;
	if Continent = "Antarctica" then delete;
run;

*In a Data Step, do the following:
*Create trCC_total, set trCC, and modify this dataset by creating an array of unknown size,
and assign the VARs of all the country names using the list operator "--" (i.e. Algeria--Venezuela);
* Open trCC and check the variable order to make sure you are capturing all countries in your list -
if your data had a different sort order before the PROC Transpose, you might have a different variable order in trCC;
* Create new variables with a length statement:  length Total Max1 Max2 8.;
* Format a text variable CountryName as $35.;
* Assign to new variable Total = sum(of ____ ) function to sum up all the array values across the row;
* Assign to new variable Max1 = max(of ____ ) function to get max of all the array values across the row;
* Do Loop exercise within this dataset:
* Find the length of the array and assign to numeric variable  i.e. HowMany = dim(arrayname);
* Or just use LBOUND(arrayname) and HBOUND(arrayname) for looping;
* Outside of a do loop, set MaxIndex=1 and LargeNum=0,
* Then a do loop from i=1 to HowMany (or LBOUND to HBOUND). Inside this loop:
* Compare array(i) to LargeNum:
  If array(i) is larger, then replace LargeNum=array(i) and replace MaxIndex=i;
* Running this do loop will result in a MaxIndex - index value of the largest number in the array;
* (for some rows LargeNum will be Population, and for some rows LargeNum will be Area);
* Once the loop is done, get the countryname of the maxvalue:
  Call label(array(MaxIndex),Countryname);
* Assign to Max2 = array(MaxIndex).  You will be able to compare this to Max1 (is it the same?);


data trCC_total;
	set trCC;
	length Total Max1 Max2 8.;
	format CountryName $35.;
	array allcountries[*] Algeria--Venezuela;
	Total = sum(of allcountries[*]);
	Max1 = max(of allcountries[*]);

	HowMany = dim(allcountries);
	LargeNum=0;
	MaxIndex=0;
	do i = 1 to HowMany;
		if allcountries(i) > LargeNum then do;
			LargeNum=allcountries(i);
			MaxIndex=i;
		end;
	end;
	call label(allcountries(maxindex),CountryName);
	Max2 = allcountries(MaxIndex);
run;

********************************************************************
* Separate Population and Area data, Merge by Continent, Output #2 *
********************************************************************;

* Your transposed dataset has rows for Population and rows for Area.;
* Use a Data Step to split this dataset into two datasets using "if... then output ...",
  one for Population and one for Area (Pop and Area or similar);
* For both datasets (Pop and Area), keep Continent Total Max1 Countryname.
* For the Pop dataset, rename Total as TotalPop, Max1 as MaxPop, and Countryname as MaxPopName.
* For the Area dataset, rename Total as TotalArea, Max1 as MaxArea, and Countryname as MaxAreaName.;

data Pop(rename=(Total=TotalPop Max1=MaxPop Countryname=MaxPopName))
     Area(rename=(Total=TotalArea Max1=MaxArea Countryname=MaxAreaName));
	set trCC_total;
	if _NAME_ = "Population" then output Pop;
	if _NAME_ = "Area" then output Area;
run;
data Pop; set Pop; keep Continent TotalPop MaxPop MaxPopName;
data Area; set Area; keep Continent TotalArea MaxArea MaxAreaName;

* Merge the two datasets (Pop and Area) back together BY Continent.
* Call the new dataset something like Density.
* Format a numeric variable Density as 10.2
     Density = TotalPop/TotalArea;

data Density;
	merge Pop Area;
	by Continent;
	format Density 10.2;
	Density = TotalPop/TotalArea;
run;

*Do a PROC Print of the Density dataset and paste it into your output;
proc print data=Density;
run;

* You can now see which country in each continent has the highest Population and the largest Area.
Check that your Density calculation matches your previous method of calculating Density.;
