require 'net/http'

Net::HTTP.start("http://api.twitter.com") { |http|
  resp = http.get("/1/users/profile_image/alfranken.png?size=mini")
  open("pie.png" ,"wb") { |file|
    file.write(resp.body)
  }
}
