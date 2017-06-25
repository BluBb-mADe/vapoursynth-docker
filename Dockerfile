FROM alpine:edge

WORKDIR /

RUN tail /etc/apk/repositories -n 1|sed s/community/testing/>>/etc/apk/repositories && \
  apk add --update git autoconf automake libtool python3 python3-dev lcms2-dev imagemagick-dev tesseract-ocr-dev coreutils build-base fdk-aac-dev curl nasm tar bzip2 zlib-dev openssl-dev yasm-dev lame-dev libogg-dev x264-dev libvpx-dev libvorbis-dev x265-dev freetype-dev libass-dev libwebp-dev libtheora-dev opus-dev && \
  pip3 install cython && \
  DIR=$(mktemp -d) && cd ${DIR}

RUN cd ${DIR} && \
  curl -s http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 | tar jxf - -C . && \
  cd ffmpeg && \
  ./configure --disable-debug --enable-avresample --enable-fontconfig --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-nonfree --enable-openssl --enable-postproc --enable-shared --enable-small --enable-version3  && \
  make -j && \
  make install && \
  cd ..

RUN cd ${DIR} && \
  git clone https://github.com/sekrit-twc/zimg && \
  cd zimg && \
    ./autogen.sh && \
  ./configure && \
  make -j && \
  make install && \
  cd ..

RUN cd ${DIR} && \
  git clone https://github.com/vapoursynth/vapoursynth.git && \
  cd vapoursynth && \
  ./autogen.sh && \
  ./configure --enable-plugins && \
  make -j && \
  ln -s  /usr/lib/python3.6 /usr/local/lib/python3.6  && \
  make install && \
  rm -rf ${DIR} && \
  apk del build-base curl tar bzip2 x264 openssl nasm && rm -rf /var/cache/apk/*
