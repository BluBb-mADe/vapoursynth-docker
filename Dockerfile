FROM alpine:edge

WORKDIR /

RUN tail /etc/apk/repositories -n 1|sed s/community/testing/>>/etc/apk/repositories && \
  BUILD_DEPS='\
    autoconf\
    automake\
    libtool\
    git\
    python3-dev\
    lcms2-dev\
    imagemagick-dev\
    tesseract-ocr-dev\
    coreutils\
    build-base\
    curl\
    nasm\
    tar\
    bzip2\
    zlib-dev\
    openssl-dev\
    yasm-dev\
    lame-dev\
    libogg-dev\
    x264-dev\
    x265-dev\
    libvpx-dev\
    libvorbis-dev\
    fdk-aac-dev\
    freetype-dev\
    libass-dev\
    libwebp-dev\
    libtheora-dev\
    opus-dev' && \
  apk add --no-cache --update $BUILD_DEPS python3 libtheora libwebp opus libass freetype x265 x264-libs lame libvorbis libvpx openssl fdk-aac&& \
  pip3 install cython && \
  DIR=$(mktemp -d) && cd ${DIR} && \
  curl -s http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 | tar jxf - -C . && \
  cd ffmpeg && \
  ./configure --disable-debug --enable-avresample --enable-fontconfig --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-nonfree --enable-openssl --enable-postproc --enable-shared --enable-small --enable-version3  && \
  make -j && \
  make install && \
  cd .. && \
  git clone https://github.com/sekrit-twc/zimg && \
  cd zimg && \
    ./autogen.sh && \
  ./configure && \
  make -j && \
  make install && \
  cd .. && \
  git clone https://github.com/vapoursynth/vapoursynth && \
  cd vapoursynth && \
  ./autogen.sh && \
  ./configure --enable-plugins && \
  make -j && \
  ln -s  /usr/lib/python3.6 /usr/local/lib/python3.6  && \
  make install && \
  rm -rf ${DIR} /var/cache/apk/* && \
  apk del --purge $BUILD_DEPS && rm -rf /var/cache/apk/*
