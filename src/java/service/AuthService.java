/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.UserDAO;
import model.UserAccount;

/**
 *
 * @author quangminhnguyen
 */
public class AuthService {
    private UserDAO userDAO;

    public AuthService() {
        userDAO = new UserDAO();
    }

    // Xử lý đăng nhập: gọi DAO kiểm tra username và password
    public UserAccount login(String username, String password) {
        return userDAO.checkLogin(username, password);
    }

    // Xử lý đăng ký: gọi DAO thêm người dùng mới
    public boolean register(UserAccount user) {
        return userDAO.registerUser(user);
    }
}
