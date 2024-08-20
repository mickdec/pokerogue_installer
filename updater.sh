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
cp common.go rogueserver/
cp register.go rogueserver/
sed -i -e 's/winkwink/$INVITATION_PHRASE/g' rogueserver/common.go
chmod +x start_rogueserver.sh
cp start_pokerogue.sh rogueserver/start_rogueserver.sh
sed -i -e 's/winkwink/$DB_PASSWORD/g' rogueserver/start_rogueserver.sh

cd rogueserver
go build .
cd ..

echo "Installing PokeRogue.."
cp _env_development pokerogue/.env.development
sed -i -e 's/winkwink/$VITE_SERVER_URL/g' pokerogue/.env.development
cp package.json pokerogue/package.json
chmod +x start_pokerogue.sh
cp start_pokerogue.sh pokerogue/start_pokerogue.sh

cd pokerogue
npm install
cd ..

./pokerogue/start_rogueserver.sh &
./pokerogue/start_pokerogue.sh &
