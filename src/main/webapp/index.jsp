<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Basic Java Web Application</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 600px;
        }
        h1 { color: #333; }
        input[type="text"] {
            padding: 10px;
            width: 200px;
            margin-right: 10px;
        }
        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Basic Java Web Application</h1>
        <p>This application is built with Maven and deployed on Tomcat.</p>

        <form action="hello" method="get">
            <label for="name">Enter your name:</label><br><br>
            <input type="text" id="name" name="name" placeholder="Your name">
            <button type="submit">Submit</button>
        </form>

        <hr>
        <p><strong>Server Info:</strong> <%= application.getServerInfo() %></p>
        <p><strong>Current Time:</strong> <%= new java.util.Date() %></p>
    </div>
</body>
</html>

