# Challenge

For this challenge students will work with two YouTube Datasets.

Data and initial code for the challenge can be found at [CodeDay Workshop](https://ide.hpccsystems.com/workspaces/share/52e24f44-070c-47e8-a2f7-1748307444f1)
- rawFiles: Gives access to dataset, it's record layout, and fields name
- viewVideos: Code sample to output CA dataset 
- When creating a new .ecl for this challenge, make sure to IMPORT rawFiles module and STD library 


# Data Dictionary

|Field|Definition|
|---|---|       
Video_ID                       | Common id field to both comment and video csv files
Trending_Date                  | The day video went viral. Format: (year.day.month) 17.14.11
Title                          | Title of video
Channel_Title                  | Channel that published the video
Category_ID                    | ID of the category the video belongs to
Publish_Time                   | When vide was uploaded. Format: 2017-11-15T02:17:29.000Z
Tags                           | Video's tags. Each tag is separated by | character
Views                          | Total number of times that video was viewed
Likes                          | Total likes
Dislikes                       | Total dislikes
Comment_Count                  | Number of comment left on the video
Thumbnail_Link                 | Quick snapshot of your video while browsing YouTube.
Comments_Disabled              | Can it have comments?
Ratings_Disabled               | Can it have ratings? 
Video_Error_or_Removed         | Are the errors removed?

## Data Source

[Kaggle - YouTube](https://www.kaggle.com/datasets/datasnaek/youtube) trending YouTube video vtatistics and comments.