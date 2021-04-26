FROM alpine:latest
MAINTAINER Ludovic MAILLET <Ludovic@maillet.me>

EXPOSE 8118 9050

ENV TZ=Europe/Paris 

RUN apk -U add privoxy tor tzdata 


PRIVOXY Config

user-manual /usr/share/doc/privoxy/user-manual/ 
confdir /etc/privoxy 
logdir /var/log/privoxy 
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file 
actionsfile user.action      # User customizations 
filterfile default.filter 
filterfile user.filter      # User customizations 
listen-address 127.0.0.1:8118 
toggle  1 
enable-remote-toggle  0 
enable-remote-http-toggle  0
enable-edit-actions 0
enforce-blocks 0 
buffer-limit 4096 
enable-proxy-authentication-forwarding 0 
trusted-cgi-referer http://www.example.org/ 
forward-socks5t . / 127.0.0.1:9050  
forward-socks4 .  / 127.0.0.1:9050 
forward-socks4a . / 127.0.0.1:9050 
forward-socks5 .  / 127.0.0.1:9050 
forwarded-connect-retries  0
accept-intercepted-requests 1
allow-cgi-request-crunching 0
split-large-forms 0 
keep-alive-timeout 5 
tolerate-pipelining 1 
socket-timeout 300 
log-messages   1 
log-highlight-messages 1 


chown privoxy:privoxy /etc/privoxy/config

privoxy --user privoxy /etc/privoxy/config



TOR Config

AutomapHostsOnResolve 1 
ControlPort 9051 
ControlSocket /etc/tor/run/control 
ControlSocketsGroupWritable 1 
CookieAuthentication 1 
CookieAuthFile /etc/tor/run/control.authcookie 
CookieAuthFileGroupReadable 1 
DNSPort 5353 
DataDirectory /var/lib/tor 
ExitPolicy reject *:* 
Log notice stderr 
RunAsDaemon 0  
SocksPort 0.0.0.0:9050 IsolateDestAddr 
TransPort 0.0.0.0:9040 
User tor 
VirtualAddrNetworkIPv4 10.192.0.0/10 




/usr/sbin/privoxy --user privoxy /etc/privoxy/config 
exec /usr/bin/tor
