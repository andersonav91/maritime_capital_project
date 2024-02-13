#!/bin/bash

# update repos
sudo apt update

# sqlite3 install
sudo apt install sqlite3
if sqlite_version=$(sqlite3 --version); then
  echo "SQLite installed. Version: $sqlite_version"
else
  echo "Invalid SQLITE installation, exiting..."
  exit 1
fi

# install rails requirements
sudo apt install -y curl gnupg2 dirmngr
# install rvm
if command -v rvm &> /dev/null; then
    echo "RVM already installed."
else
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
    curl -sSL https://get.rvm.io | bash -s stable
    rvm install 3.1.1
    rvm use 3.1.1 --default
fi

# install node
sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/yarn.gpg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn

# install rails
gem install rails
gem install bundle
bundle install

# migrate models and data
rails db:migrate
rails db:seed

# compile assets
rake assets:precompile

# execute app
rails s -b 0.0.0.0 -e development
