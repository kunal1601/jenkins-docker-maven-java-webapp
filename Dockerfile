FROM tomcat:8.0.20-jre8

RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/java-web-app*.war /usr/local/tomcat/webapps/ROOT.war
 
