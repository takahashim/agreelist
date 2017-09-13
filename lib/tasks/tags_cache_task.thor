class TagsCacheTask < Thor
  desc 'update_all',
       'Update occupations and schools cache'

  def update_all
    require './config/environment'
    OccupationsCache.update_all
    SchoolsCache.update_all
  end
end
