FROM davidemms/orthofinder:2.5.5.2

Label maintainer="rdemko2332@gmail.com"

RUN apt-get update && apt-get install -y default-jre samtools seqtk procps mafft bioperl cpanminus && apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /usr/bin/

RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p /usr/bin/miniconda3
RUN rm -rf ~/miniconda3/miniconda.sh
RUN miniconda3/bin/conda init bash
RUN miniconda3/bin/conda init zsh
RUN miniconda3/bin/conda install -c bioconda fasttree
RUN mv miniconda3/bin/fasttree fasttree

RUN cpanm Statistics::Basic Statistics::Descriptive::Weighted

RUN wget http://github.com/bbuchfink/diamond/releases/download/v2.0.15/diamond-linux64.tar.gz
RUN tar xzf diamond-linux64.tar.gz

RUN wget https://github.com/marbl/Mash/releases/download/v2.3/mash-Linux64-v2.3.tar
RUN tar -xf mash-Linux64-v2.3.tar --no-same-owner
RUN mv mash-Linux64-v2.3/mash /usr/bin

ADD /bin/* /usr/bin/

# Making all tools executable
RUN chmod +x *

WORKDIR /work
