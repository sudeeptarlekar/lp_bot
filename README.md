# Trainline Bot

A Ruby bot that searches for train journeys on thetrainline.com and returns formatted results.

## Overview

This bot triggers searches on https://www.thetrainline.com and returns journey segments with fare information in a structured format.

## Installation

```bash
gem install bot
```

## Usage

```ruby
require 'awesome_print' # => To Print the visual represented output on terminal

require_relative 'lp_bot'

# Search for journeys
results = Bot::Thetrainline.find("London", "Paris")

# Results is an array of journey segments
ap results

```

## API

> ⚠️ Coming Soon...

## Getting Real Data

Since the Trainline API requires authentication, you can capture real data using browser DevTools:

### Quick Method (Recommended)

1. Open https://www.thetrainline.com in your browser
2. Open DevTools (F12) → Network tab
3. Make a search (e.g., London to Paris)
4. Find the `journey-search` POST request
5. Copy the Response JSON
6. Save to `data/london_to_paris.json`
7. Update the code to load from this file

### Using Static Data

```ruby
# Load captured data
module Bot
  class Thetrainline
    def self.find(from, to, departure_at)
      file = "data/responses/#{from.downcase}_to_#{to.downcase}.json"
      
      if File.exist?(file)
        data = JSON.parse(File.read(file))
        parse_journeys(data)
      else
        generate_sample_journeys(from, to, departure_at)
      end
    end
  end
end
```

## Alternative: Browser Automation

For dynamic data fetching, use Selenium:

```bash
gem install selenium-webdriver
```

```ruby
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get("https://www.thetrainline.com")
# ... fill form and capture results
```

## Why API Returns 403

The Trainline `/api/journey-search/` endpoint is protected and requires:
- Valid session cookies
- CSRF tokens
- Browser headers

**It works in browser** because your browser has these tokens.  
**It fails in Postman/code** without proper authentication.

**Solution**: As stated in the assignment, use local static data captured from the browser.

## Running Tests
```shell
bundle exec rspec
```
```
```

## Notes

- Assumes `from` and `to` parameters are exactly what's needed
- `departure_at` must be a Ruby DateTime object
- Currently uses sample data; integrate real data as needed
- Prices are stored in cents for precision

## License

Educational purposes only. Respect Trainline's Terms of Service.
