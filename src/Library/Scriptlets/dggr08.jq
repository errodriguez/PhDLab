# 0 Tweet, 1 Retweet, 2 Quoted, 3 Reply

def ents( s ):
#* If presents, already identified entities are extracted.
      ( s.entities.hashtags      |
                    [( .[]| 1, .indices[], .text      ) ] | @csv )?,
      ( s.entities.symbols       |
                    [( .[]| 2, .indices[], .text      ) ] | @csv )?,
      ( s.entities.user_mentions |
                    [( .[]| 3, .indices[], .id_str    ) ] | @csv )?,
      ( s.entities.urls          |
                    [( .[]| 4, .indices[], .url       ) ] | @csv )?,
      ( s.entities.media         |
                    [( .[]| 5, .indices[], .media_url ) ] | @csv )?
;


def out( t; c ):
#* Starts output record with tweet ID and creation timestamp. Tries to 
#& identified if it is a reply (3). Adds language.
    [ ( [ t.id_str, t.created_at,
          (  if t.in_reply_to_status_id_str != null 
                 then 3
                 else c
              end
          ),
          t.lang ] | @csv ),
#- From user structure, takes, ID, followings, followers and other stats.
      ( t.user | [ .id_str, 
                   .friends_count,
                   .followers_count,
                   .listed_count,
                   .statuses_count,
                   .created_at,
                   .geo_enabled,
                   .lang//"" ] | @csv ),  
#- If it is an "extended tweet", get its full text.
      ( if t.extended_tweet
            then t.extended_tweet.full_text
            else t.text
         end ),
#- Looks for identified entities, from the extended or normal tweet, as the
#& case may be.
      ( if t.extended_tweet
           then ents( t.extended_tweet )
           else ents( t )
        end )
#- Record is returned as separated by tabulators.
    ] | @tsv;


def ttype( t; c ):
#* Check tweet type : 0 Tweet, 1 Retweet, 2 Quoted, 3 Reply
    out( t; c ) + 
    if t.quoted_status
       then "\n" + ttype( t.quoted_status; 2 )
       elif t.retweeted_status
            then "\n"+ ttype( t.retweeted_status; 1 ) 
            else null
    end;


ttype(.;0)
