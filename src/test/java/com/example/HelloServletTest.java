package com.example;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.io.StringWriter;

import static org.mockito.Mockito.*;

/**
 * Unit tests for HelloServlet
 */
@DisplayName("HelloServlet Tests")
public class HelloServletTest {

    private HelloServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private StringWriter responseWriter;
    private PrintWriter printWriter;

    @BeforeEach
    void setUp() throws Exception {
        servlet = new HelloServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        
        responseWriter = new StringWriter();
        printWriter = new PrintWriter(responseWriter);
        when(response.getWriter()).thenReturn(printWriter);
    }

    @Test
    @DisplayName("Should return greeting with default name when no name parameter")
    void testDoGetWithoutNameParameter() throws Exception {
        // Arrange
        when(request.getParameter("name")).thenReturn(null);

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(response).setContentType("text/html");
        String output = responseWriter.toString();
        assertTrue(output.contains("Hello, World!"));
        assertTrue(output.contains("This is a basic Java web application."));
        assertTrue(output.contains("<html>"));
        assertTrue(output.contains("</html>"));
    }

    @Test
    @DisplayName("Should return greeting with provided name")
    void testDoGetWithNameParameter() throws Exception {
        // Arrange
        String testName = "TestUser";
        when(request.getParameter("name")).thenReturn(testName);

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(response).setContentType("text/html");
        String output = responseWriter.toString();
        assertTrue(output.contains("Hello, " + testName + "!"));
        assertTrue(output.contains("This is a basic Java web application."));
    }

    @Test
    @DisplayName("Should return greeting with default name when empty string provided")
    void testDoGetWithEmptyNameParameter() throws Exception {
        // Arrange
        when(request.getParameter("name")).thenReturn("");

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(response).setContentType("text/html");
        String output = responseWriter.toString();
        assertTrue(output.contains("Hello, World!"));
    }

    @Test
    @DisplayName("Should include back to home link")
    void testDoGetIncludesBackLink() throws Exception {
        // Arrange
        when(request.getParameter("name")).thenReturn("Test");

        // Act
        servlet.doGet(request, response);

        // Assert
        String output = responseWriter.toString();
        assertTrue(output.contains("<a href='index.jsp'>Back to Home</a>"));
    }

    @Test
    @DisplayName("Should generate valid HTML structure")
    void testDoGetGeneratesValidHtml() throws Exception {
        // Arrange
        when(request.getParameter("name")).thenReturn("Test");

        // Act
        servlet.doGet(request, response);

        // Assert
        String output = responseWriter.toString();
        assertTrue(output.contains("<html>"));
        assertTrue(output.contains("<head><title>Hello Servlet</title></head>"));
        assertTrue(output.contains("<body>"));
        assertTrue(output.contains("</body>"));
        assertTrue(output.contains("</html>"));
        assertTrue(output.contains("<h1>"));
        assertTrue(output.contains("<p>"));
    }
}