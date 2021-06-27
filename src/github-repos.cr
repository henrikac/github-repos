require "http/client"
require "json"

# `GitHub` is an easy-to-use module to fetch repositories.
module GitHub
  VERSION = "0.1.0"

  class Repo
    include JSON::Serializable

    @[JSON::Field(key: "name")]
    property title : String?

    property language : String?

    @[JSON::Field(key: "html_url")]
    property url : String?

    property description : String?

    @[JSON::Field(key: "stargazers_count")]
    property stars : Int32
  end

  # Returns the repositories with the given *titles* from the user with the given *username*.
  def self.fetch_repos(username : String, titles : Array(String)) : Array(Repo)
    repo_arr = Array(Repo).new

    headers = HTTP::Headers{"Accept" => "application/vnd.github.v3+json"}
    url = "https://api.github.com/users/#{username}/repos"

    loop do
      response = HTTP::Client.get url, headers

      if !response.success?
        # TODO: Something bad happened - figure out how to handle it
        return repo_arr
      end

      repos_from_json = Array(Repo).from_json(response.body)

      repos_from_json.each do |repo|
        titles.each do |title|
          if repo.title == title
            repo_arr << repo
          end
        end
      end

      url = check_for_next response.headers
      break if url.empty?
    end

    return repo_arr
  end

  # Return next page url if there is any, otherwise an empty string.
  #
  # Example of Link header:
  #
  # Link: ["<https://api.github.com/user/18054250/repos?page=2>; rel=\"next\", <https://api.github.com/user/18054250/repos?page=2>; rel=\"last\""]
  private def self.check_for_next(headers : HTTP::Headers) : String
    links = headers["Link"].split(',')
    split_link = links[0].split(';')
    has_next = split_link[1].includes?("next")

    if has_next
      return split_link[0][1..-2]
    end

    return ""
  end
end
