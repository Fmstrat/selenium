FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

LABEL testing="true"

RUN apt-get update
RUN apt-get install -y \
	wget \
	python3 \
	python3-pip \
	python \
	python-pip \
	firefox \
	unzip
RUN apt-get clean -y
RUN apt-get purge -y

RUN pip3 install selenium
RUN pip install selenium

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
RUN tar xvfz geckodriver-v0.26.0-linux64.tar.gz 
RUN rm geckodriver-v0.26.0-linux64.tar.gz 
RUN mv geckodriver /bin

ENTRYPOINT ["python3"]
