NWD=`pwd`
RACK_ENV=production bundle exec unicorn -c ${NWD}/config/unicorn.rb -E production -D
