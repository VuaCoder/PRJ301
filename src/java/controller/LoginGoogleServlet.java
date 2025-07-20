//package controller;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//
//import java.io.IOException;
//import java.net.URLEncoder;
//
//@WebServlet("/login-google")
//public class LoginGoogleServlet extends HttpServlet {
//
//    private static final String CLIENT_ID = "701939732906-jtaqhn70lb55hsk4iod5q66635s22gql.apps.googleusercontent.com";
//    private static final String REDIRECT_URI = "http://localhost:9999/login"; // callback về AuthServlet
//    private static final String SCOPE = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile";
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String oauthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
//                + "?scope=" + URLEncoder.encode(SCOPE, "UTF-8")
//                + "&access_type=online"
//                + "&include_granted_scopes=true"
//                + "&response_type=code"
//                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
//                + "&client_id=" + CLIENT_ID;
//
//        resp.sendRedirect(oauthUrl);
//    }
//}
