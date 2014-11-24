# DataManager module which allows for getting API data and parsing it.
# In addition, this module allows for getting teams from a particular
# conference and sorting that conference by winning percentage, points for
# and points against.
module DataManager
  # Function which returns a hash corresponding to the conference_id
  # passed in as a parameter
  # @param conference_id ID corresponding to a particular FBS conference
  # @param url url corresponding to API call
  def parse_json(conference_id, url)
    sports_data = JSON.load(open(url)) # hash containing info from json file

    # array of FBS conferences
    conferences = sports_data['division']['conferences']

    # select conferences with the same ID as conference_id
    conference_array = conferences.select do |conference|
      conference['id'] == conference_id
    end

    conference_array[0] # return the only element of conference_array
  end

  # Function which sorts a conference in place by winning percentage,
  # and breaks ties according to points for, and then points against.
  # @param conference_hash Hash of teams to sort
  def sort_teams_by_wpct(conference_hash)
    conference_hash['teams'].sort_by! do |team|
      [team['overall']['wpct'],
       team['points']['for'],
       team['points']['against']]
    end.reverse!
  end

  # Function which prints out the teams of a conference by naming the team
  # name, winning percentage, points for and points against.
  # @param conference_hash Hash of teams to list
  def list_teams(conference_hash)
    rank = 1
    conference_hash['teams'].each do |team|
      name = team['market'] + ' ' + team['name']
      wpct = team['overall']['wpct']
      pts_for = team['points']['for']
      pts_against = team['points']['against']

      print("Team: #{name}\nRank: #{rank}\nWinning Percentage: #{wpct}\n" +
                "Points For: #{pts_for}\nPoints Against: #{pts_against}\n\n")
      rank += 1
    end
  end
end

include DataManager # needed for functions in module above
require 'open-uri'  # needed to open API url
require 'json'      # needed to parse json data

# url corresponding to API call for FBS standings
url = 'http://api.sportsdatallc.org/ncaafb-t1/teams/FBS/2014/REG/standings.json?api_key=ushjeuzyq2w9bpxqrmu3jdsp'

# create a hash of big ten teams, using the url above
big_ten_hash = parse_json('BIG-TEN', url)

# sort and print out teams
sort_teams_by_wpct(big_ten_hash)
list_teams(big_ten_hash)