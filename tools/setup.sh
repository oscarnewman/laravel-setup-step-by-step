#! /bin/bash

echo -e "\033[1;32mSetting up your local dev environment\033[0m"
echo -e "\033[1;41mWarning! This will destroy your local database and reseed it with test data.\033[0m"
# Exit if they say no
read -p "Are you sure you want to continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi


echo "Installing composer dependencies..."
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v $(pwd):/opt \
    -w /opt \
    laravelsail/php82-composer:latest \
    composer install --ignore-platform-reqs

echo "Installing npm dependencies..."
npm i

echo "Decrypting .env file..."
make env:decrypt

echo "Booting up Sail in the background..."
echo -e "\033[1;30m(note: Run \`sail up\` to reconnect)\033[0m"
./vendor/bin/sail up -d

echo "Generating application key..."
./vendor/bin/sail artisan key:generate

echo "Migrating and seeding database..."
./vendor/bin/sail artisan migrate:fresh --seed

echo "Building frontend..."
npm run build

echo "Running tests..."
./vendor/bin/sail test
```
