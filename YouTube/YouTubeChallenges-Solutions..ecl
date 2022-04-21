IMPORT YouTube.rawFiles;
IMPORT STD;

rawFiles.US_DS;
rawFiles.CA_DS;



// Display the first 10 rows in US dataset?

// Answer: Contains 10 rows of US dataset

OUTPUT(CHOOSEN(rawFiles.US_DS, 10), NAMED('US_10Rows'));

//*********************************************************************************
//*********************************************************************************

// How many rows are in CA dataset?

// Answer: 40881

OUTPUT(COUNT(rawFiles.CA_DS), NAMED('CA_Count'));

//*********************************************************************************
//*********************************************************************************

// How many rows are in US dataset?

// Answer: 40949

OUTPUT(COUNT(rawFiles.US_DS), NAMED('US_Count'));

//*********************************************************************************
//*********************************************************************************

// In CA dataset how many rows have the same dates for publish_time and trending_date?
// Note: Comparison should happen only on "date" portion of the fields.

// Answer is: 0

sameDates := COUNT(rawFiles.CA_DS (publish_time = trending_date));
OUTPUT(sameDates, NAMED('Have_Same_Dates'));

//*********************************************************************************
//*********************************************************************************

// Between CA and US datasets which one has the most releases in 2018?

// Answer: CA

US2017 := COUNT(rawFiles.US_DS(publish_time[..4] = '2018'));
CA2017 := COUNT(rawFiles.CA_DS(publish_time[..4] = '2018'));

OUTPUT(IF(US2017 >= CA2017, 'US', 'CA'), NAMED('Most_Release2018'));

//*********************************************************************************
//*********************************************************************************

// Number of total rows in both US and CA dataset that  have 
// the title "A Very Cool Christmas - Movie Review - brutalmoose"

// Answer is: 1

Str := 'A Very Cool Christmas - Movie Review - brutalmoose';

OUTPUT(COUNT(rawFiles.US_DS(title = Str)) + 
       COUNT(rawFiles.CA_DS(title = Str)),
       NAMED('Total_Title_Count'));

//*********************************************************************************
//*********************************************************************************

// IGNORE FOR NOW ???????????????????????
// is there any dedups?
// How many dups?
/*
USDups := COUNT(DEDUP(rawFiles.US_DS, Video_ID));

// Whic US video has the most comments?
rawFiles.US_DS(MAX(rawFiles.US_DS, comment_count) = comment_count);

// Max like the same?
// ANswer:
CA_MAx := MAX(rawFiles.Ca_DS, likes);
US_Max := MAX(rawFIles.US_DS, likes);


x := rawFiles.US_DS(likes = US_Max);
y := rawFiles.CA_DS(likes = CA_Max);

x[1].title = y[1].title;

*/


//*********************************************************************************
//*********************************************************************************

// How many have both comment and rating disabled in US?

// Answer is: 106

OUTPUT(COUNT(rawFiles.US_DS(comments_disabled AND ratings_disabled)), NAMED('Disabled'));

//*********************************************************************************
//*********************************************************************************

// In CA dataset, Publish_Time includes date and time (2017-11-13T17:13:01.000Z), 
// We want to separate date and time for better readability and future processes and
// convert date format to mm/dd/yyyy.  

// Create a new dataset that includes 4 fields: Video_ID, Title, PublishedDate and PublishedTime.
// ECL standard library has a ConvertDateFormat() function that can be used to reformat date. 
// STRING ConvertDateFormat(STRING date_text, VARSTRING from_format='%m/%d/%Y', VARSTRING to_format='%Y%m%d') 
// You can use this function by using STD.Date.ConvertDateFormat( ) and sending the input variables. 
// Output the first 25 rows.

// Hint: The result dataset should look like following:
/*

Video_ID     | Title                | PublishedDate | PublishedTime
CpU72eM8vCo  | Operation: Dry Tank  | 11/13/2017    | 07:13:54

*/
// Answer : 

newRec := RECORD
    STRING    Video_ID;
    STRING    Title;
    STRING10  PublishedDate;
    STRING8   PublishedTime;
END;

newDS := PROJECT(rawfiles.CA_DS, //2017-11-12T20:19:24.000Z
            TRANSFORM(newRec,
                SELF.PublishedDate := STD.Date.ConvertDateFormat(LEFT.publish_time[..12], '%Y-%m-%d', '%m/%d/%Y');
                SELF.PublishedTime := (STRING) LEFT.publish_time[12..19];
                SELF := LEFT));

OUTPUT(newDS, NAMED('FormattingDate_Time'));

//*********************************************************************************
//*********************************************************************************

// Now we want to know total releases per year. Using the dataset you just created, 
// find out how many years of data is included in this dataset

// ANswer: 12 

totalreleases := TABLE(rawFiles.US_DS,
                       {
                           STRING Year := Publish_Time[..4],
                           INTEGER Total := COUNT(GROUP)
                       },
                           Publish_Time[..4]);

OUTPUT(totalreleases, NAMED('totalreleases'));

//*********************************************************************************
//*********************************************************************************

// From last result, what is the minium release

// Answer: 1

minReleases := MIN(totalreleases, Total);
OUTPUT(minReleases, NAMED('minReleases'));

//*********************************************************************************
//*********************************************************************************

// Which year the minimum release belong to?

// Answer:

OUTPUT(totalReleases(year = (STRING)minReleases), NAMED('Min_Year'));

//*********************************************************************************
//*********************************************************************************

// From last result, what is the maximum release

// Answer: 1

maxReleases := MAX(totalreleases, Total);
OUTPUT(maxReleases, NAMED('maxReleases'));

//*********************************************************************************
//*********************************************************************************

// Which year the maximum release belong to?

// Answer:

OUTPUT(totalReleases(year = (STRING)maxReleases), NAMED('Max_Year'));



// Show how many videos went viral per day.


// Capture num of years
/*
numOfYears := TABLE(rawFiles.US_DS,
                       {
                           STRING Year := Published_Time[..4]
                       })

*/
// A regular expression is a sequence of characters that specifies a search pattern in text. 
// The regular experssion for identifying all characters, numbers, -, and _ is : ^[a-zA-Z0-9_.-]*$
// Answer is: 
