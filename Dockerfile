FROM tomcat:9.0-jre17

LABEL maintainer="Mostafa Alsabagh"
LABEL description="IGP Graduation Project - Containerized Web Application"
LABEL version="1.0"

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*


# Copy WAR file to Tomcat webapps directory
# The pom.xml shows artifactId=ABCtechnologies, version=1.0
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/

# Rename WAR file to ROOT.war for default context (accessible at /)
RUN cd /usr/local/tomcat/webapps/ && mv *.war ROOT.war

# Create application directories
RUN mkdir -p /app/logs

# Set environment variables optimized for Java 8
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV JAVA_OPTS "-Xmx512m -Xms256m -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

# Expose port 8080 for Tomcat
EXPOSE 8080

# Add health check specific to your application
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat server
CMD ["catalina.sh", "run"]