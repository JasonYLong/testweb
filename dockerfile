FROM tomcat
MAINTAINER "Jason Yuan"
ADD testweb_svn.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
