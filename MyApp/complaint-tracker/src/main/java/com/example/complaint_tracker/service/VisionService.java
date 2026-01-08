package com.example.complaint_tracker.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Service
public class VisionService {

    @Value("${google.cloud.vision.api-key}")
    private String apiKey;

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public VisionService() {
        this.httpClient = HttpClient.newHttpClient();
        this.objectMapper = new ObjectMapper();
    }

    public String detectLabel(MultipartFile file) throws IOException {
        try {
            // Convert image to base64
            byte[] imageBytes = file.getBytes();
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);

            // Build the request payload
            String requestBody = buildRequestBody(base64Image);

            // Create HTTP request
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://vision.googleapis.com/v1/images:annotate?key=" + apiKey))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            // Send request
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            System.out.println("Vision API Response Status: " + response.statusCode());
            System.out.println("Vision API Response Body: " + response.body());

            if (response.statusCode() == 200) {
                return parseResponse(response.body());
            } else {
                throw new IOException("Vision API error: " + response.statusCode() + " - " + response.body());
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Request interrupted", e);
        } catch (Exception e) {
            throw new IOException("Failed to analyze image: " + e.getMessage(), e);
        }
    }

    private String buildRequestBody(String base64Image) {
        try {
            // Create the request body using HashMap
            Map<String, Object> requestMap = new HashMap<>();
            
            List<Map<String, Object>> requestsList = new ArrayList<>();
            Map<String, Object> request = new HashMap<>();
            
            // Image content
            Map<String, Object> imageMap = new HashMap<>();
            imageMap.put("content", base64Image);
            request.put("image", imageMap);
            
            // Features
            List<Map<String, Object>> featuresList = new ArrayList<>();
            
            Map<String, Object> labelFeature = new HashMap<>();
            labelFeature.put("type", "LABEL_DETECTION");
            labelFeature.put("maxResults", 10);
            featuresList.add(labelFeature);
            
            Map<String, Object> objectFeature = new HashMap<>();
            objectFeature.put("type", "OBJECT_LOCALIZATION");
            objectFeature.put("maxResults", 5);
            featuresList.add(objectFeature);
            
            request.put("features", featuresList);
            requestsList.add(request);
            requestMap.put("requests", requestsList);
            
            return objectMapper.writeValueAsString(requestMap);
        } catch (Exception e) {
            // Fallback simple request
            return "{\"requests\":[{\"image\":{\"content\":\"" + base64Image + "\"},\"features\":[{\"type\":\"LABEL_DETECTION\",\"maxResults\":10}]}]}";
        }
    }

    private String parseResponse(String responseBody) throws IOException {
        JsonNode root = objectMapper.readTree(responseBody);
        JsonNode responses = root.path("responses");
        
        if (responses.isEmpty() || responses.get(0).path("error").isObject()) {
            return "Unknown";
        }

        JsonNode firstResponse = responses.get(0);
        List<String> allLabels = new ArrayList<>();

        // Parse label annotations
        JsonNode labelAnnotations = firstResponse.path("labelAnnotations");
        for (JsonNode label : labelAnnotations) {
            if (label.path("score").asDouble() > 0.7) {
                allLabels.add(label.path("description").asText());
            }
        }

        // Parse object annotations
        JsonNode objectAnnotations = firstResponse.path("localizedObjectAnnotations");
        for (JsonNode object : objectAnnotations) {
            if (object.path("score").asDouble() > 0.7) {
                allLabels.add(object.path("name").asText());
            }
        }

        return allLabels.isEmpty() ? "Unknown" : String.join(", ", allLabels);
    }
}