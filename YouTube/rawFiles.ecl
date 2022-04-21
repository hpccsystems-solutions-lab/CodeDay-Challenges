EXPORT rawFiles := MODULE

    EXPORT YouTube_Rec := RECORD
        STRING   video_id;
        STRING8  trending_date;
        STRING   title;
        STRING   channel_title;
        INTEGER  category_id;
        STRING   publish_time;
        STRING   tags;
        INTEGER  views;
        INTEGER  likes;
        INTEGER  dislikes;
        INTEGER  comment_count;
        STRING   thumbnail_link;
        BOOLEAN  comments_disabled;
        BOOLEAN  ratings_disabled;
        BOOLEAN  video_error_or_removed;
        STRING   description;
    END;
    
    // US YouTube Dataset
    EXPORT US_DS := DATASET('~youtube::csv::raw::usvideos.csv', YouTube_Rec, 
                              CSV(HEADING(1)));
    
    // Canada YouTube Dataset
    EXPORT CA_DS := DATASET('~youtube::csv::raw::cavideos.csv', YouTube_Rec, 
                              CSV(HEADING(1)));

END;