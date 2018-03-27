FROM tatsushid/alpine-py3-tensorflow-jupyter
RUN pip3 install tensorboard
EXPOSE 6006