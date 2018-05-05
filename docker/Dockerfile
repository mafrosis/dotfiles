FROM jrottenberg/ffmpeg

COPY ffconv /bin/

RUN sed -i 's/zsh/bash/g' /bin/ffconv && \
	sed -i 's/return/exit/g' /bin/ffconv

RUN chmod +x /bin/ffconv

CMD         ["-h"]
ENTRYPOINT  ["/bin/ffconv"]
