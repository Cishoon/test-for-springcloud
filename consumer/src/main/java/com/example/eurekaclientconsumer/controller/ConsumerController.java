package com.example.eurekaclientconsumer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class ConsumerController {

    @Autowired
    private RestTemplate restTemplate;

    @GetMapping("/invoke")
    public String invokeProviderService() {
        return restTemplate.getForObject("http://provider-service/hello", String.class);
    }
}
