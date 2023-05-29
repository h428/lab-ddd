package com.lab.web.controller;

import ch.qos.logback.core.testUtil.RandomUtil;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("test")
    public String test() {
        return String.valueOf(RandomUtil.getPositiveInt());
    }

}
