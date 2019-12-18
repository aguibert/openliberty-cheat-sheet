# Table of Contents

# What is Open Liberty?

[OpenLiberty is](https://openliberty.io/) is a lightweight open framework for building fast and efficient cloud-native Java microservices. It supports some of the most popular Java standards today, including:
- Java EE 7 and 8
- Microprofile 1.X, 2.X, and 3.X
- Spring Boot 1.5 and 2.0

# Getting Started

Generate a basic Liberty project using Maven:

```
mvn archetype:generate \
    -DarchetypeGroupId=io.openliberty.tools \
    -DarchetypeArtifactId=liberty-archetype-webapp \
    -DarchetypeVersion=3.1 \
    -DgroupId=org.example \
    -DartifactId=liberty-app \
    -Dversion=1.0-SNAPSHOT
```

This creates a Maven project with a simple Servlet class in it:

```java
@WebServlet(urlPatterns="/servlet")
public class HelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Hello! How are you today?");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
```

You can start the application in "dev mode" using the command:
```
mvn liberty:dev
```

Then open a web browser to http://localhost:9080/test/servlet to access the Servlet. To run unit and integration tests, press the `Enter` key. To exit dev mode press `Ctrl+C`.

A more detailed Getting Started walkthrough can be found in the [OpenLiberty Maven guide](https://openliberty.io/guides/maven-intro.html#what-youll-learn).

# Configuration

The primary source of configuration for a Liberty server is the `server.xml` file. In most projects it is located at `src/main/liberty/config/server.xml` and might look like this:

```xml
<server>
    <featureManager>
        <feature>servlet-4.0</feature>
    </featureManager>
    
    <httpEndpoint httpPort="9080" httpsPort="9443" id="defaultHttpEndpoint" />
    
    <webApplication id="test" location="test.war" name="test"/>
</server>
```

For more info see: [OpenLiberty server configuration overview](https://openliberty.io/docs/ref/feature/)

## Dynamic Configuration

All configuration in `server.xml` is dynamic by default, meaning that if you modify it while the server is running, the server will automatically update to account for the change -- typically in a few milliseconds.

## Features

The features enabled for a Liberty server are listed in the `<featureManager>` element. A Liberty feature may include other Liberty features. For example, the `jsp-2.3` feature pulls in the `servlet-4.0` feature, and the `webProfile-8.0` feature pulls in all of the features for Java EE 8 Web Profile.

**TIP:** Only enable the features that you need! While it may be convenient to enable "convenience" features like `javaee-8.0` initially, over time you should only enable features that your application actually needs. Less features = faster startup and lower disk/memory footprint

Some of the most common Liberty features are:

### Java EE 8
- `webProfile-8.0`: Enables all features in Java EE 8 Web profile: Bean Validation 2.0, CDI 2.0, EJB Lite 3.2, EL 3.0, JAX-RS 2.1, JNDI 1.0, JPA 2.2, JSF 2.3, JSON-B 1.0, JSON-P 1.1, JSP 2.3, Servlet 4.0, WebSocket 1.1
- `javaee-8.0`: Enables all features in Java EE 8 Full Profile: `webProfile-8.0` plus Java Batch 1.0, EE Concurrency 1.0, EJB 3.2, JavaMail 1.6, JAX-WS 2.2, JCA 1.7, JMS 2.0
- `jaxrs-2.1`: Java XML RESTful Web Services (JAX-RS) 2.1
- `cdi-2.0`: Context Dependency Injection (CDI) 2.0
- `jpa-2.2`: Java Persistence Architecture (JPA) 2.2
- `jsf-2.3`: Java Server Faces (JSF) 2.3
- `jsonb-1.0`: JSON Binding (JSON-B) 1.0
- `servlet-4.0`: Servlet 4.0

### Java EE 7
- `webProfile-7.0`: Enables all features in Java EE 7 Web Profile
- `javaee-7.0`: Enables all features in Java EE 7 Full Profile

**TIP:** You cannot mix Java EE 7 and 8 features in the same server.xml!

### MicroProfile 3.3
- `microProfile-3.3`: Enables all features in MicroProfile 3.3 platform
- `cdi-2.0`
- `jaxrs-2.1`
- `jsonb-1.0`
- `mpConfig-1.4`: MicroProfile Config 1.4
- `mpHealth-2.1`: MicroProfile Health 2.1
- `mpMetrics-2.2`: MicroProfile Metrics 2.2
- `mpRestClient-1.3`: MicroProfile REST Client 1.3

A complete list of all Liberty features can be found here: [OpenLiberty Server Features](https://openliberty.io/docs/ref/feature/)

# Docker

The basic Liberty Dockerfile looks like this:

```
FROM openliberty/open-liberty:full-java8-openj9-ubi
COPY src/main/liberty/config /config/
ADD target/myApp.war /config/dropins

# Running configure.sh takes ~20s at docker build time but will greatly
# reduce container start time. You may not want to run this for local
# development if you are constant changing the app layer
RUN configure.sh
```

There are also base layers using Java 11 and 13 which can be found here: [OpenLiberty Docker Hub](https://hub.docker.com/r/openliberty/open-liberty)

# Supported Java SE versions

OpenLiberty is currently supported on Java SE 8, 11, and 13. Official documentation can be found here: [JavaSE support](https://openliberty.io/docs/ref/general/#java-se.html)

# Included Open Source Components

| Liberty Feature | OSS Component|
| --------------- |--------------|
| `beanValidation-2.0` | Apache BVal 1.1 |
| `cdi-1.2` | Weld 2.4.X |
| `cdi-2.0` | Weld 3.X |
| `javaMail-1.5` | Sun ref impl |
| `javaMail-1.6` | Sun ref impl |
| `jaxb-2.2` | Sun ref impl |
| `jaxb-2.3` | Sun ref impl |
| `jaxrs-2.0` | Apache CXF 2.6 |
| `jaxrs-2.2` | Apache CXF 3.2 |
| `jaxws-2.2` | Apache CXF 2.6 |
| `jaxws-2.3` | Apache CXF 3.2 |
| `jpa-2.1` | EclipseLink 2.6 | 
| `jpa-2.2` | EclipseLink 2.7 |
| `jsonb-1.0` | Eclipse Yasson 1.0 |
| `jsonp-1.0` | Glassfish ref impl |
| `jsonp-1.1` | Glassfish ref impl |
| `mpReactiveMessaging-1.0` | SmallRye Reactive Messaging |

