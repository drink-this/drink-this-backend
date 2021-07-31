FROM ubuntu:18.04

RUN apt-get update && apt-get install -y python3-dev python3-pip
RUN python3 -m pip install numpy &&\
    python3 -m pip install pandas &&\
    python3 -m pip install sklearn
RUN apt-get install -y wget openssl build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev libpq-dev

RUN mkdir files
COPY . /home/files
RUN export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl"
RUN wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.2.tar.gz &&\
    tar xzf ruby-2.7.2.tar.gz &&\
    cd ruby-2.7.2 &&\
    ./configure &&\
    make &&\
    make install &&\
    cd .. &&\
    rm -rf ruby-2.7.2.tar.gz ruby-2.7.2

RUN export DEBIAN_FRONTEND=noninteractive &&\
    ln -fs /usr/share/zoneinfo/America/Mountain /etc/localtime &&\
    apt-get install -y tzdata
WORKDIR /home/files
RUN gem install bundler && bundle install
# COPY . . 
CMD ["bash"]  