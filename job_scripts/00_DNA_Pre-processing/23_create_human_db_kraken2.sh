module load bioinfo-tools
module load Kraken2

mkdir ~/private/human_db
cp -r /sw/data/uppnex/Kraken2/latest/taxonomy ~/private/human_db
cp -r /sw/data/uppnex/Kraken2/latest/library ~/private/human_db

cd ~/private/human_db
kraken2-build --build  --db human
