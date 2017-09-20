require(dplyr)
require(RPostgreSQL)

driver <- dbDriver("PostgreSQL")
con <- dbConnect(driver, dbname = "dev",
                 host = "data-challenge.cpzsedc9pony.us-west-2.redshift.amazonaws.com", port = 5439, user = "testuser233", password = "TenorTest233")

# checking to see if connection was made and table exists
dbExistsTable(con, "ios_events")

session_data <- dbGetQuery(con, "SELECT TOP 1000 * from ios_events ")

gif_sessions <- session_data %>%
  arrange(keyboardid, timestamp) %>%
  group_by(keyboardid) %>%
  mutate(Seconds_After_Last = difftime(timestamp, lag(timestamp), units = "secs"),
         New_Session_Flag = is.na(lag(keyboardid)) | Seconds_After_Last > 10,
         session_sequence_number = cumsum(New_Session_Flag),
         session_id = paste(keyboardid, session_sequence_number, sep ="_")
  ) %>%
  group_by(keyboardid, session_sequence_number, session_id) %>%
  summarize( 
    number_searches = n(),
    session_started_at = first(timestamp),
    session_ended_at = last(timestamp),            
    session_length = difftime(last(timestamp, first(timestamp))))

# The session sequence number starts at 1 for each visitor and is incremented whenever the time interval is 
# greater than 10seconds This is done as follows: 
# 1. Compute the time lag, in mins, from prior record 
# 2. Set session flag as True or False when: True = there is no prior record for visitor OR False = lag to prior record is > 10secs
# 3. Perform Cumulative sum of session flags to get session sequence number

## Track sessions for individual User record using Keyboardid and timestamp and aggregating values to calculate session length
session_data3 <- dbGetQuery(con, "SELECT * from ios_events where keyboardid = 'MTExMjY2MjEw'")

gif_sessions3 <- session_data3 %>%
  arrange(keyboardid, timestamp) %>%
  group_by(keyboardid) %>%
  mutate(Seconds_After_Last = difftime(timestamp, lag(timestamp), units = "secs"),
         New_Session_Flag = is.na(lag(keyboardid)) | Seconds_After_Last > 10,
         session_sequence_number = cumsum(New_Session_Flag),
         session_id = paste(keyboardid, session_sequence_number, sep ="_")
  )%>%
  group_by(keyboardid, session_sequence_number, session_id) %>%
  summarize( 
    session_started_at = first(timestamp),
    session_ended_at = last(timestamp),
    session_duration = last(timestamp)-first(timestamp))

session_data2 <- dbGetQuery(con, "SELECT TOP 100 * from ios_events where keyboardid = 'MTA1ODA2Mzgw'")

gif_sessions2 <- session_data2 %>%
  arrange(keyboardid, timestamp) %>%
  group_by(keyboardid) %>%
  mutate(Seconds_After_Last = difftime(timestamp, lag(timestamp), units = "secs"),
         New_Session_Flag = is.na(lag(keyboardid)) | Seconds_After_Last > 5,
         session_sequence_number = cumsum(New_Session_Flag),
         session_id = paste(keyboardid, session_sequence_number, sep ="_")
  )%>%
  group_by(keyboardid, session_sequence_number, session_id) %>%
  summarize( 
    session_started_at = first(timestamp),
    session_ended_at = last(timestamp),
    session_duration = last(timestamp)-first(timestamp))



    