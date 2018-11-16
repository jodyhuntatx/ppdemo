FROM cyberark/conjur-cli:5-latest
RUN echo 'root:Cyberark1' | chpasswd
VOLUME [ “/sys/fs/cgroup” ]
ENTRYPOINT ["/usr/sbin/init"]
