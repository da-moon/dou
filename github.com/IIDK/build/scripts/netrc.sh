# !/bin/bash
echo "Create git netrc"
touch ~/.netrc
echo "machine github.com" >> ~/.netrc
echo "login $USER" >> ~/.netrc |tee
echo "password $PASSWORD" >> ~/.netrc |tee
