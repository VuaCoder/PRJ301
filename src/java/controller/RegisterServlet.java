/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.Role;
import model.UserAccount;

/**
 *
 * @author quangminhnguyen
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Mặc định role là "customer"
        Role role = new Role(1, "customer");
        UserAccount user = new UserAccount();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setUsername(email); // nếu bỏ username thì dùng email thay thế
        user.setRoleId(role);

        boolean success = new UserDAO().registerUser(user);
      if (success) {
    // Tạo customer gắn với user vừa tạo
    Customer customer = new Customer();
    customer.setUserId(user); // Gán user cho Customer
    new CustomerDAO().createCustomer(customer); // DAO tự viết như dưới

    request.setAttribute("message", "Đăng ký thành công! Hãy đăng nhập.");
    request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
}

         else {
            request.setAttribute("error", "Đăng ký thất bại! Email có thể đã tồn tại.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
        }
    }
}
