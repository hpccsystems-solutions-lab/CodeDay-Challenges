IMPORT YouTube.rawFiles;
IMPORT STD;



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

// How many records in CA don't have any tag assigned?

// Answer: 2385

NoTags := COUNT(rawFiles.CA_DS(Tags = ''));

OUTPUT(NoTags, NAMED('CA_NoTags'));

//*********************************************************************************
//*********************************************************************************

// Between CA and US datasets which one has the most releases in 2018?

// Answer: CA

US2017 := COUNT(rawFiles.US_DS(Publish_Time[..4] = '2018'));
CA2017 := COUNT(rawFiles.CA_DS(Publish_Time[..4] = '2018'));

OUTPUT(IF(US2017 >= CA2017, 'US', 'CA'), NAMED('Most_Release2018'));


//*********************************************************************************
//*********************************************************************************

// Number of total rows in both US and CA dataset that have 
// title "A Very Cool Christmas - Movie Review - brutalmoose"

// Answer is: 1

Str := 'A Very Cool Christmas - Movie Review - brutalmoose';

OUTPUT(COUNT(rawFiles.US_DS(title = Str)) + 
       COUNT(rawFiles.CA_DS(title = Str)),
       NAMED('Total_Title_Count'));

//*********************************************************************************
//*********************************************************************************

// How many records have both comment and rating disabled in US?

// Answer is: 106

OUTPUT(COUNT(rawFiles.US_DS(comments_disabled AND ratings_disabled)), NAMED('Disabled'));

//*********************************************************************************
//*********************************************************************************

// In US dataset how many videos have more Dislikes than Likes?

// Answer: 576

dislike := rawFiles.US_DS(Dislikes > Likes);

OUTPUT(COUNT(dislike), NAMED('More_Dislikes'));

//*********************************************************************************
//*********************************************************************************

// In US dataset are there any videos that the total of Dislikes and Likes are equal to Views count?

// Answer: No

isEqual := rawFiles.US_DS(Dislikes + Likes = Views);
isEqual;
OUTPUT(EXISTS(isEqual), NAMED('isEqual'));

//*********************************************************************************
//*********************************************************************************


// In CA dataset, How many video has more Likes and Dislikes is than the number of Views?
// Note: we are not interested in equal ones.


// Answer: 0

bigSum := rawFiles.CA_DS (Likes + Dislikes > Views);


OUTPUT(bigSum, NAMED('BigSum'));


//*********************************************************************************
//*********************************************************************************

// In CA dataset, Publish_Time includes date and time (2017-11-13T17:13:01.000Z).
// We want to separate date and time for better readability and future processing.
// Also convert date format to mm/dd/yyyy.  

// Create a new dataset that includes 4 fields: Video_ID, Title, PublishedDate and PublishedTime.
// ECL standard library has a ConvertDateFormat() function that can be used to reformat date. 
// STRING ConvertDateFormat(STRING date_text, VARSTRING from_format='%m/%d/%Y', VARSTRING to_format='%Y%m%d') 
// You can use this function by using STD.Date.ConvertDateFormat( ) and sending the input variables. 
// Output the first 25 rows. 
// Name your new dataset NewDS.

// Hint: The result dataset should look like following:
/*

Video_ID     | Title                | PublishedDate | PublishedTime
CpU72eM8vCo  | Operation: Dry Tank  | 11/13/2017    | 07:13:54

*/

// Answer : Result should contain 25 rows with abovt format.

newRec := RECORD
    STRING    Video_ID;
    STRING    Title;
    STRING10  PublishedDate;
    STRING8   PublishedTime;
END;

newDS := PROJECT(rawfiles.CA_DS, //2017-11-12T20:19:24.000Z
            TRANSFORM(newRec,
                SELF.PublishedDate := STD.Date.ConvertDateFormat(LEFT.Publish_Time[..12], '%Y-%m-%d', '%m/%d/%Y');
                SELF.PublishedTime := (STRING) LEFT.Publish_Time[12..19];
                SELF := LEFT));

OUTPUT(CHOOSEN(newDS, 25), NAMED('FormattingDate_Time'));

//*********************************************************************************
//*********************************************************************************

// In ECL CountWords function is used to count the number of words using a separator
// CountWords: https://hpccsystems.com/training/documentation/standard-library-reference/html/CountWords.html
// Can you find out how vidoes has the  most tags in US? 

// Note: Keep in mind, that a video can be trended in more than one day,
// which will result in duplicated Video_ID and Title.

// Answer:  2

tagRec := RECORD
    STRING    Video_ID;
    STRING    Title;
    INTEGER   TagCount;
END;

mostTags := PROJECT(rawfiles.US_DS,
                TRANSFORM(tagRec,
                    SELF.TagCount := STD.STR.CountWords(LEFT.Tags, '|'),
                    SELF := LEFT)); 
                    
MaxTag := DEDUP(mostTags(TagCount = MAX(mostTags, TagCount)), Video_ID, Title);

OUTPUT(MaxTag, nAMED('MaxTag'));

//*********************************************************************************
//*********************************************************************************


// In CA dataset how many rows have the same dates (day, month, and year) for Publish_Time and Trending_Date?
// Note: Keep in mind that Publish_Time and Trending_Date don't have the same format. 
// For comparison you need the exact same format on both fields. 

// Answer is: 	2042

TrendDate := STD.Date.ConvertDateFormat(rawFiles.CA_DS.Trending_Date, '%Y.%d.%m', '%m/%d/%Y');
PublishedDate := STD.Date.ConvertDateFormat(rawFiles.CA_DS.Publish_Time[3..12], '%Y-%m-%d', '%m/%d/%Y');

sameDates := COUNT(rawFiles.CA_DS (TrendDate = PublishedDate));

OUTPUT(sameDates, NAMED('Have_Same_Dates'));


//*********************************************************************************
//*********************************************************************************


// Now we want to know total releases per year in US. Using the NewDS dataset you just created, 
// or finding another solution, show number of releases per year.  
// Looing at the result, how many years is included in this dataset?

// Answer: 12 

totalreleases := TABLE(rawFiles.US_DS,
                       {
                           STRING Year := Publish_Time[..4],
                           INTEGER Total := COUNT(GROUP)
                       },
                           Publish_Time[..4]);

OUTPUT(totalreleases, NAMED('totalreleases'));

//*********************************************************************************
//*********************************************************************************

// From "total releases per year" for US, what is the minimum release total and what year it belongs to?

// Answer: 2006 and 1

minReleases := MIN(totalreleases, Total);
OUTPUT(totalReleases(Total = minReleases), NAMED('Min_Year'));

//*********************************************************************************
//*********************************************************************************

// From "total releases per year" for US, what is the maximum release total and what year it belongs to?

// Answer: 2018 and 30231

maxReleases := MAX(totalreleases, Total);
OUTPUT(totalReleases(Total = maxReleases), NAMED('Max_Year'));

//*********************************************************************************
//*********************************************************************************

// Find the number of videos that went viral on the same Trending_Date in both US and CA.

// Answer: 4790

Viral := COUNT(JOIN(rawFiles.US_DS, rawFiles.CA_DS,
            LEFT.Video_ID = RIGHT.Video_ID AND
            LEFT.Trending_Date = RIGHT.Trending_Date,
            TRANSFORM(LEFT)));


OUTPUT(Viral, NAMED('US_CA_Viral'));

//*********************************************************************************
//*********************************************************************************

// Which Channel_Title released the most videos in year 2017 in CA?

// Answer: 	VikatanTV

getYear := rawFiles.CA_DS(Publish_Time[1..4] = '2017');


titleCount := TABLE(getYear,
                       {
                           Channel_Title,
                           INTEGER Total := COUNT(GROUP)
                       },
                           Channel_Title);

maxCount := MAX(titleCount, Total);

OUTPUT(titleCount(maxCount = Total), NAMED('titleCount'));


//*********************************************************************************
//*********************************************************************************

// How many videos have different Channel_Title between US and CA. 
// Note: remember to eliminate duplicated videos. 

// Answer: 8
diffChannel := DEDUP(JOIN(rawFiles.US_DS, rawFiles.CA_DS,
                        LEFT.Video_ID = RIGHT.Video_ID AND
                        LEFT.Channel_Title  != RIGHT.Channel_Title,
                        TRANSFORM(LEFT)),
                                    Video_ID);

OUTPUT(COUNT(diffChannel), NAMED('diffChannel'));

