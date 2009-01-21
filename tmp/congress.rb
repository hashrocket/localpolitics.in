module NewYorkTimes
  
  class Congress
    include HTTParty
    format :xml
    
    API_KEY = APP_CONFIG[:nyt_congress_api_key]
    
    # httparty 'http://api.nytimes.com/svc/politics/v2/us/legislative/congress/members/L000447.xml?api-key=api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066'
    def get_legislator_by_bioguide_id(bioguide_id)
      HTTParty.get("http://api.nytimes.com/svc/politics/v2/us/legislative/congress/members/#{bioguide_id}?api-key=#{API_KEY}")
    end
    
    # httparty 'http://api.nytimes.com/svc/politics/v2/us/legislative/congress/members/S001163/votes.xml?api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066'
    def voting_record(bioguide_id)
      Congress.get("http://api.nytimes.com/svc/politics/v2/us/legislative/congress/members/#{bioguide_id}/votes.xml?api-key=#{API_KEY}")
    end
    
  end
  
end

# <?xml version="1.0"?>
# <result_set>
#   <status>OK</status>
#   <copyright>Copyright (c) 2009 The New York Times Company.  All Rights Reserved.</copyright>
#   <results>
#     <member_id>C001041</member_id>
#     <total_votes>100</total_votes>
#     <offset>0</offset>
#     <votes>
#       <vote>
#         <member_id>C001041</member_id>
#         <chamber>Senate</chamber>
#         <congress>110</congress>
#         <session>2</session>
#         <roll_call>215</roll_call>
#         <date>2008-12-11</date>
#         <time>22:42:00</time>
#         <position>Yes</position>
#       </vote>
#       <vote>
#         <member_id>C001041</member_id>
#         <chamber>Senate</chamber>
#         <congress>110</congress>
#         <session>2</session>
#         <roll_call>214</roll_call>
#         <date>2008-11-20</date>
#         <time>15:01:00</time>
#         <position>Yes</position>
#       </vote>
#       <vote>
#         <member_id>C001041</member_id>
#         <chamber>Senate</chamber>
#         <congress>110</congress>
#         <session>2</session>
#         <roll_call>213</roll_call>
#         <date>2008-10-01</date>
#         <time>21:22:00</time>
#         <position>Yes</position>
#       </vote>
#       ...
#       <vote>
#         <member_id>C001041</member_id>
#         <chamber>Senate</chamber>
#         <congress>110</congress>
#         <session>2</session>
#         <roll_call>79</roll_call>
#         <date>2008-03-13</date>
#         <time>11:54:00</time>
#         <position>No</position>
#       </vote>
#     </votes>
#   </results>
# </result_set>
