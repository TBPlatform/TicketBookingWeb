package com.unimelb.swen90007.reactexampleapi.api.controllers.bookings;

import com.unimelb.swen90007.reactexampleapi.api.domain.BookingLogic;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.io.IOException;
import java.io.PrintWriter;

/* Servlet for processing GET requests to /. note capital letters
 */
@CrossOrigin
@WebServlet(name = "DeleteBooking", value = "/delete-booking")
public class DeleteBooking extends HttpServlet {

    // response to GET request. displays header just to show that it is running
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        System.out.println("DeleteBooking GET method");
        PrintWriter writer = response.getWriter();
        writer.println("<h3>DeleteBooking GET page</h3>");
        writer.println("<p>Send a DELETE request to delete a booking</p>");
    }

    // POST request
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        System.out.println("CreateBooking DELETE method");
        response.setContentType("application/json");
        PrintWriter writer = response.getWriter();

        try {
            BookingLogic.deleteBooking(request.getParameter("id"));
            response.setStatus(200);
        } catch (Exception e) {
            response.setStatus(400);
        }
    }

}
