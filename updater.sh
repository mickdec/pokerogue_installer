DB_PASSWORD=""
INVITATION_PHRASE=""
VITE_SERVER_URL=""

echo "Killing pokerogue.."
killall pokerogue
killall rogueserver

echo "Removing previous installation.."
rm -Rf ../pokerogue_dir
mkdir ../pokerogue_dir
cd ../pokerogue_dir

echo "Updating.."
git clone https://github.com/pagefaultgames/pokerogue
git clone https://github.com/pagefaultgames/rogueserver

cd ../pokerogue_installer

echo "Installing RogueServer.."
cp RES/common.go ../pokerogue_dir/rogueserver/
cp RES/register.go ../pokerogue_dir/rogueserver/
sed -i -e 's/winkwink/'$INVITATION_PHRASE'/g' ../pokerogue_dir/rogueserver/common.go

cd ../pokerogue_dir/rogueserver
go build .
cd ../../pokerogue_installer

echo "Installing PokeRogue.."
cp RES/_env_development ../pokerogue_dir/pokerogue/.env.development
sed -i --expression 's@winkwink@'$VITE_SERVER_URL'@g' ../pokerogue_dir/pokerogue/.env.development
cp RES/package.json ../pokerogue_dir/pokerogue/package.json
cp RES/start_pokerogue.sh ../pokerogue_dir/pokerogue/start_pokerogue.sh
sed -i -e 's/winkwink/'$DB_PASSWORD'/g' ../pokerogue_dir/pokerogue/start_pokerogue.sh

cd ../pokerogue_dir/pokerogue
npm install
cp ../rogueserver/rogueserver .

chmod +x rogueserver
chmod +x pokerogue/start_pokerogue.sh
./start_pokerogue.sh
