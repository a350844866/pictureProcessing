package com.xuexue.controller;

import com.xuexue.utils.FileUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * 
 * @author jiaxu
 *
 * @version $Id: uploadController.java, v 0.1 2018/4/16 12:24 jiaxu Exp $$
 */
@Controller
public class UploadController {

    @RequestMapping(value = "/uploadPicture")
    public void upload(HttpServletRequest request,String styleName) throws Exception {
        MultipartFile file = ((MultipartHttpServletRequest) request).getFile("upload-img");
        String[] split = file.getContentType().split("/");
        if (split[0].equals("image")) {
            String filePath = request.getSession().getServletContext().getRealPath("/staticfile/images/");
            FileUtil.uploadFile(file.getBytes(),filePath,styleName+"."+split[1]);
        }
    }

}
