package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.Map;

public class saveImageUtil {

    private final Cloudinary cloudinary;

    // ⚙️ Cấu hình tài khoản Cloudinary
    public saveImageUtil() {
        this.cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "datmsosje",
            "api_key", "466369822117672",
            "api_secret", "Us-cuX0XjITqihcrviCABaRZF7s"
        ));
    }

    // 📤 Upload ảnh
    public String upload(Part filePart) throws IOException {
        File tempFile = File.createTempFile("upload-", filePart.getSubmittedFileName());
        filePart.write(tempFile.getAbsolutePath());

        Map uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());

        tempFile.delete(); // dọn file tạm
        return (String) uploadResult.get("secure_url");
    }

    // 📤 Upload video
    public String uploadVideo(Part filePart) throws IOException {
        File tempFile = File.createTempFile("upload-", filePart.getSubmittedFileName());
        filePart.write(tempFile.getAbsolutePath());

        Map uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.asMap(
            "resource_type", "video"
        ));

        tempFile.delete(); // dọn file tạm
        return (String) uploadResult.get("secure_url");
    }
}
