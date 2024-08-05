package com.example.eurekaclientprovider.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ProviderController {

    @Value("${server.port}")
    private String port;

    @Value("${provider.message}")
    private String message;

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello from Provider Service running at port:" + port;
    }

    @GetMapping("/test_config")
    public String testConfig() {
        return message;
    }
}
