%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
].each { |path| Spring.watch(path) }

Spring.after_fork do
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
end