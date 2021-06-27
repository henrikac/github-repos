# github-repos

A shard that makes it easy to fetch data about specific repositories.  

This module was original made as part of a personal project which is why only a few properties has been added to `GitHub::Repo`, however, contributions are very welcome ;).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     github-repos:
       github: henrikac/github-repos
   ```

2. Run `shards install`

## Usage

Keep in mind that *"Unauthenticated clients can make 60 requests per hour"* [1](https://docs.github.com/en/rest/guides/getting-started-with-the-rest-api#authentication).

```crystal
require "github-repos"

repos = GitHub.fetch_repos("henrikac", ["pokeapi", "github-repos", "prettytable"])

if repos.empty?
  puts "Didn't find any repositories :'("
else
  repos.each { |r| puts r.title }
end
```

The original purpose of this module was to fetch repository data every 5 minutes. By doing this the data displayed to potential users was always up-to-date.

```crystal
require "github-repos"

mut = Mutex.new
repos = Array(GitHub::Repo).new

spawn do
  loop do
    mut.lock
    repos = GitHub.fetch_repos("henrikac", ["pokeapi", "github-repos", "prettytable"])
    mut.unlock

    sleep 5.minutes
  end
end

# code ...
```

## Contributing

1. Fork it (<https://github.com/henrikac/github-repos/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Henrik Christensen](https://github.com/henrikac) - creator and maintainer
