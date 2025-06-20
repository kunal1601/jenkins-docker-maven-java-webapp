FROM tomcat:10.1.20-jdk21

RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/java-web-app*.war /usr/local/tomcat/webapps/ROOT.war
 
