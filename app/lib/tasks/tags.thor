class Tags < Thor
  desc "set_entrepreneruship",
       "set tags for statements"

  def set_entrepreneurship
    require './config/environment'
    urls.each do |url|
      s = statement(url)
      s.tag_list.add("entrepreneurship")
      s.save
    end
  end

  private

  def statement(url)
    ::Statement.find_by_hashed_id(url.split("-").last)
  end

  def urls
    %w(http://www.agreelist.org/s/launch-early-get-feedback-and-start-iterating-kibothy610sj
       http://www.agreelist.org/s/entrepreneurs-should-have-a-sense-of-purpose-0u5gaxuav1w8
       http://www.agreelist.org/s/seek-out-negative-feedback-5brqzh7xaj5b
       http://www.agreelist.org/s/a-single-founder-in-a-startup-is-a-mistake-5udqtimqiicb
       http://www.agreelist.org/s/location-is-important-for-a-startup-zfrtumvrwtyd
       http://www.agreelist.org/s/stay-self-funded-as-long-as-possible-73rbrkrvztwb
       http://www.agreelist.org/s/don-t-go-all-in-with-your-business-re3xkpjeunfp
       http://www.agreelist.org/s/go-with-your-gut-rx54xxorby6y
       http://www.agreelist.org/s/don-t-give-up-olyhqve6j6sf
       http://www.agreelist.org/s/set-goals-4m7m7oidosa8)
  end
end
