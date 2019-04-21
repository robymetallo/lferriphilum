# Build Nitrospirae DB
# Go to the following webpage and download all assemblies for Nitrospirae
# https://www.ncbi.nlm.nih.gov/assembly/?term=Nitrospirae

# Do the same for Proteobacteria (use the following search filters)
# "Proteobacteria"[Organism] AND (latest[filter] AND "complete genome"[filter] AND
# "reference genome"[filter] AND all[filter] NOT anomalous[filter])

# At the moment the taxonomy file is not available at NCBI.
# I've used this copy http://refdb.s3.climb.ac.uk/k2_taxonomy_20190409.tar.gz

# Extract the sequences in $HOME/Bioinformatics_data/genomes/nitrospirae/

# Concatenate FASTA.gz files
cd ~/Bioinformatics_data/genomes/nitrospirae/ncbi-genomes-2019-04-19
zcat *.fna.gz | pbzip2 -c -p4 -m2000 >  nitrospirae_genomes.fasta.bz2

cd ~/Bioinformatics_data/genomes/proteobacteria/ncbi-genomes-2019-04-19/
zcat *.fna.gz | pbzip2 -c -p4 -m2000 >  proteobacteria_genomes.fasta.bz2

# Kraken wants uncompressed FASTA to create a database... so...
cd ~/Bioinformatics_data/genomes/nitrospirae/ncbi-genomes-2019-04-19
bzcat nitrospirae_genomes.fasta.bz2 > nitrospirae_genomes.fasta
cd ~/Bioinformatics_data/genomes/proteobacteria/ncbi-genomes-2019-04-19/
bzcat proteobacteria_genomes.fasta.bz2 > proteobacteria_genomes.fasta

cd ~/Bioinformatics_data/genomes/                                                                                                
bzcat ~/Bioinformatics_data/genomes/nitrospirae/ncbi-genomes-2019-04-19/nitrospirae_genomes.fasta.bz2 \
      ~/Bioinformatics_data/genomes/proteobacteria/ncbi-genomes-2019-04-19/proteobacteria_genomes.fasta.bz2 \
      > nitro_and_proteo_genomes.fasta



cd ~/Bioinformatics_data/krakenDB
kraken2-build --add-to-library \
~/Bioinformatics_data/genomes/nitrospirae/ncbi-genomes-2019-04-19/nitrospirae_genomes.fasta \
--db nitrospirae

kraken2-build --add-to-library \
~/Bioinformatics_data/genomes/proteobacteria/ncbi-genomes-2019-04-19/proteobacteria_genomes.fasta \
--db proteobacteria

kraken2-build --add-to-library \
~/Bioinformatics_data/genomes/nitro_and_proteo_genomes.fasta --db nitro_and_proteo

ln -s ~/Bioinformatics_data/krakenDB/taxonomy ~/Bioinformatics_data/krakenDB/nitrospirae
ln -s ~/Bioinformatics_data/krakenDB/taxonomy ~/Bioinformatics_data/krakenDB/proteobacteria
ln -s ~/Bioinformatics_data/krakenDB/taxonomy ~/Bioinformatics_data/krakenDB/nitro_and_proteo

rm ~/Bioinformatics_data/genomes/nitrospirae/ncbi-genomes-2019-04-19/nitrospirae_genomes.fasta
rm ~/Bioinformatics_data/genomes/proteobacteria/ncbi-genomes-2019-04-19/proteobacteria_genomes.fasta
rm ~/Bioinformatics_data/genomes/nitro_and_proteo_genomes.fasta

cd ~/Bioinformatics_data/krakenDB
kraken2-build --threads 4 --build --db nitrospirae
kraken2-build --threads 4 --build --db proteobacteria
kraken2-build --threads 4 --build --db nitro_and_proteo

# Build Human DB on Rackham
mkdir $SNIC_TMP/kraken2_DB && cd $SNIC_TMP/kraken2_DB
mkdir -p human/library
module load bioinfo-tools
module load Kraken2

# Copy human library and ferch NCBI taxonomy
cp -r $KRAKEN2_DEFAULT_DB/library/human $SNIC_TMP/kraken2_DB/human/library
cd $SNIC_TMP/kraken2_DB && wget http://refdb.s3.climb.ac.uk/k2_taxonomy_20190409.tar.gz
tar xvz k2_taxonomy_20190409.tar.gz -C taxonomy

# Using multiple threads gives an error... so build the DB using only one core
cd $SNIC_TMP/kraken2_DB && kraken2-build --build --db human
mv $SNIC_TMP/kraken2_DB ~/private