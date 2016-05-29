FROM debian

# install required commands
RUN apt-get update && apt-get install -y wget expect

# download axigen install script and make it executable
RUN wget https://www.axigen.com/usr/files/axigen-10.0.0/axigen-10.0.0.amd64.deb.run && chmod +x ./axigen-10.0.0.amd64.deb.run

# copy expect file for axigen installer
COPY files/install-axigen.exp /

# install axigen with default settings and set to start at boot
# 	admin password 		= admin
# 	postmaster password = postmaster
RUN export TERM=xterm & chmod +x /install-axigen.exp && /install-axigen.exp

# Cleanup
RUN rm /install-axigen.exp

#expose required ports for SMTP, POP3, IMAP, POP3S, IMAPS, WebAdmin, Webmail and CLI
EXPOSE 25 110 143 993 995 9000 80 7000

# start the service
ENTRYPOINT /etc/init.d/axigen start


# set mountpoint for axigen datafiles
VOLUME ["/var/opt/axigen"]