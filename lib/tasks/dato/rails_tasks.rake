namespace :dato do
  namespace :cache do
    task clear: :environment do
      Dato::Cache.clear!
    end
  end
end
