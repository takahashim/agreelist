class Cache < Thor
  desc 'update_occupations_cache',
       'update_occupations_cache'

  def update_occupations_cache
    require './config/environment'
    OccupationsCache.update_all
  end
end
