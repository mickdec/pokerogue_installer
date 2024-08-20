DB_PASSWORD=""
INVITATION_PHRASE=""
VITE_SERVER_URL=""

echo "Killing pokerogue.."
killall pokerogue
killall rogueserver

echo "Removing previous installation.."
rm -Rf pokerogue_dir
mkdir pokerogue_dir
cd pokerogue_dir

echo "Updating.."
git clone https://github.com/pagefaultgames/pokerogue
git clone https://github.com/pagefaultgames/rogueserver

echo "Installing RogueServer.."
cp common.go pokerogue_dir/rogueserver/
cp register.go pokerogue_dir/rogueserver/
sed -i -e 's/winkwink/'$INVITATION_PHRASE'/g' pokerogue_dir/rogueserver/common.go
cp start_rogueserver.sh pokerogue_dir/rogueserver/start_rogueserver.sh
sed -i -e 's/winkwink/'$DB_PASSWORD'/g' pokerogue_dir/rogueserver/start_rogueserver.sh

cd pokerogue_dir/rogueserver
go build .
cd ../..

echo "Installing PokeRogue.."
cp _env_development pokerogue_dir/pokerogue/.env.development
sed -i --expression 's@winkwink@'$VITE_SERVER_URL'@g' pokerogue_dir/pokerogue/.env.development
cp package.json pokerogue_dir/pokerogue/package.json
cp start_pokerogue.sh pokerogue_dir/pokerogue/start_pokerogue.sh

cd pokerogue_dir/pokerogue
npm install
cd ../..

chmod +x pokerogue_dir/rogueserver/start_rogueserver.sh
chmod +x pokerogue_dir/pokerogue/start_pokerogue.sh
./pokerogue_dir/rogueserver/start_rogueserver.sh &
cd pokerogue_dir/pokerogue/
./start_pokerogue.sh
