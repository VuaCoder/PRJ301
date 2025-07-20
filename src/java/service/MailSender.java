package service;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.Date;

public class MailSender {
    
    public static void sendPaymentConfirmation(String toEmail, String customerName) throws UnsupportedEncodingException {
        final String fromEmail = "ccc123cxqo@gmail.com"; // Sử dụng email đã hoạt động của bạn
        final String password = "kxbv ivla rxrt zdbv";    // App password đã hoạt động

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "Hotel Booking System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Xác nhận thanh toán thành công - Hotel Booking");
            message.setSentDate(new Date());

            // Tạo HTML content
            String htmlContent = createEmailContent(toEmail, customerName);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("✅ Email xác nhận thanh toán đã gửi đến " + toEmail);
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi gửi email: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to send email", e);
        }
    }
    
    private static String createEmailContent(String userEmail, String customerName) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <title>Xác nhận thanh toán</title>" +
                "</head>" +
                "<body style='font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f9f9f9;'>" +
                "    <div style='max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);'>" +
                "        <div style='text-align: center; margin-bottom: 30px;'>" +
                "            <h1 style='color: #28a745; margin-bottom: 10px;'>✅ Thanh toán thành công!</h1>" +
                "            <p style='color: #666; font-size: 16px;'>Hotel Booking System</p>" +
                "        </div>" +
                "        " +
                "        <div style='background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;'>" +
                "            <h3 style='color: #333; margin-top: 0;'>Chi tiết giao dịch:</h3>" +
                "            <p><strong>Khách hàng:</strong> " + customerName + "</p>" +
                "            <p><strong>Email:</strong> " + userEmail + "</p>" +
                "            <p><strong>Thời gian:</strong> " + new Date().toString() + "</p>" +
                "            <p><strong>Trạng thái:</strong> <span style='color: #28a745; font-weight: bold;'>Thành công</span></p>" +
                "        </div>" +
                "        " +
                "        <div style='margin: 20px 0;'>" +
                "            <p style='font-size: 16px; line-height: 1.6;'>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</p>" +
                "            <p style='font-size: 16px; line-height: 1.6;'>Chúng tôi đã nhận được thanh toán của bạn và đang xử lý đơn hàng.</p>" +
                "        </div>" +
                "        " +
                "        <div style='text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;'>" +
                "            <p style='color: #666; font-size: 14px; margin: 0;'>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.</p>" +
                "            <p style='color: #666; font-size: 14px; margin: 5px 0 0 0;'>Email: support@hotelbooking.com | Hotline: 1900-1234</p>" +
                "        </div>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }
}