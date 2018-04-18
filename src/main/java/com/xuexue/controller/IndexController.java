package com.xuexue.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 
 * @author jiaxu
 *
 * @version $Id: IndexController.java, v 0.1 2018/4/16 17:32 jiaxu Exp $$
 */
@Controller
public class IndexController {
    @RequestMapping("/index.htm")
    public String doGet(Model model) {
        return "index";
    }
}
