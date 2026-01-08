package com.example.complaint_tracker.controller;

import com.example.complaint_tracker.service.VisionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/complaints")
@CrossOrigin(origins = "*")
public class ComplaintController {

    private final VisionService visionService;

    public ComplaintController(VisionService visionService) {
        this.visionService = visionService;
    }

    @GetMapping("/test")
    public String testEndpoint() {
        System.out.println("=== TEST ENDPOINT HIT ===");
        return "Complaint API is working!";
    }

    @PostMapping("/upload")
    public ResponseEntity<Map<String, String>> uploadImage(@RequestParam("image") MultipartFile image) throws IOException {
        System.out.println("=== UPLOAD ENDPOINT HIT ===");
        
        try {
            if (image.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "No image provided"));
            }

            System.out.println("File received: " + image.getOriginalFilename());
            System.out.println("File size: " + image.getSize());
            
            // DEBUG: Check credentials
            String credPath = System.getenv("GOOGLE_APPLICATION_CREDENTIALS");
            System.out.println("GOOGLE_APPLICATION_CREDENTIALS: " + credPath);
            
            // ACTUALLY USE THE VISION SERVICE
            String detectedLabels = visionService.detectLabel(image);
            System.out.println("Detected labels: " + detectedLabels);
            
            String complaintType = mapLabelToCategory(detectedLabels);
            
            Map<String, String> response = new HashMap<>();
            response.put("detectedLabel", detectedLabels);
            response.put("complaintType", complaintType);
            response.put("message", "Image analyzed successfully");
            
            System.out.println("Returning: " + response);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to process image: " + e.getMessage()));
        }
    }

    private String mapLabelToCategory(String detectedLabels) {
        if (detectedLabels == null || detectedLabels.equals("Unknown")) {
            return "Image not detected"; // CHANGED: Clear message instead of wrong category
        }
        
        String lowercaseLabels = detectedLabels.toLowerCase();


        // Lift Detection
        if (lowercaseLabels.contains("elevator") || lowercaseLabels.contains("lift") ||
            lowercaseLabels.contains("escalator")) {
            return "Lift";
        }
        

        // Water Cooler/RO Detection
        if (/*lowercaseLabels.contains("water cooler") || lowercaseLabels.contains("water filter") ||
            lowercaseLabels.contains("ro") || lowercaseLabels.contains("purifier") ||
            lowercaseLabels.contains("dispenser") || lowercaseLabels.contains("water purification") ||*/
            lowercaseLabels.contains("water dispenser") ||
            (lowercaseLabels.contains("plastic") && lowercaseLabels.contains("water"))||
            lowercaseLabels.contains("kitchen appliance")) {
            return "Water Cooler/RO";
        }
        
        // WiFi Detection
        if (lowercaseLabels.contains("wifi") || lowercaseLabels.contains("router") || 
            lowercaseLabels.contains("wireless") || lowercaseLabels.contains("network") ||
            lowercaseLabels.contains("internet") || lowercaseLabels.contains("modem")) {
            return "Wifi";
        }
        
        // Laundary Detection
        if (lowercaseLabels.contains("washing machine") || lowercaseLabels.contains("laundry") ||
            lowercaseLabels.contains("textile") ||lowercaseLabels.contains("linens") ||
            lowercaseLabels.contains("cloth") || lowercaseLabels.contains("towel") ||
            lowercaseLabels.contains("washer") || lowercaseLabels.contains("dryer") ||
            lowercaseLabels.contains("blazer") || lowercaseLabels.contains("pocket") ||
             lowercaseLabels.contains("collar") || lowercaseLabels.contains("button") ||
             lowercaseLabels.contains("sleeve") || lowercaseLabels.contains("bag")) {
            return "Laundry";
        }
        
        // Mess Detection
        if (lowercaseLabels.contains("food") || lowercaseLabels.contains("spoon") ||
            lowercaseLabels.contains("dining") || lowercaseLabels.contains("meal") ||
            lowercaseLabels.contains("cook") || lowercaseLabels.contains("curry") || 
            lowercaseLabels.contains("ingredient") || lowercaseLabels.contains("stew") ||
            lowercaseLabels.contains("recipe") || lowercaseLabels.contains("produce")) {
            return "Mess";
        }
        
        // Carpentary Detection
        if (lowercaseLabels.contains("wood") || lowercaseLabels.contains("furniture") ||
            lowercaseLabels.contains("chair") || lowercaseLabels.contains("table") ||
            lowercaseLabels.contains("door") || lowercaseLabels.contains("window") ||
            lowercaseLabels.contains("cabinet")) {
            return "Carpentary";
        }

        // // Civil Works Detection
        // if (lowercaseLabels.contains("wall") ||( lowercaseLabels.contains("ceiling") && !lowercaseLabels.contains("ceiling fan"))  ||
        //     lowercaseLabels.contains("floor") || lowercaseLabels.contains("roof") ||
        //     lowercaseLabels.contains("paint") || lowercaseLabels.contains("crack") ||
        //     lowercaseLabels.contains("construction") || lowercaseLabels.contains("brick") ) {
        //     return "Civil works";
        // }
        

                // Electrical Detection
        if (lowercaseLabels.contains("electrical")||lowercaseLabels.contains("light fixture") || lowercaseLabels.contains("wire") ||lowercaseLabels.contains("fluorescent lamp")|| 
            lowercaseLabels.contains("socket") || lowercaseLabels.contains("outlet") ||
            lowercaseLabels.contains("switch") || lowercaseLabels.contains("fuse") ||
            lowercaseLabels.contains("circuit") || lowercaseLabels.contains("breaker") ||
            lowercaseLabels.contains("plug") || lowercaseLabels.contains("electric") || 
            lowercaseLabels.contains("ceiling fan") || lowercaseLabels.contains("electric") ||
            (lowercaseLabels.contains("electronics") && lowercaseLabels.contains("plastic")) ||
            lowercaseLabels.contains("electronics") || lowercaseLabels.contains("light") ||
            lowercaseLabels.contains("lighting")|| lowercaseLabels.contains("technology")) {
            return "Electrical";
        }
                // Civil Works Detection
        if (lowercaseLabels.contains("wall") ||( lowercaseLabels.contains("ceiling") && !lowercaseLabels.contains("ceiling fan"))  ||
            lowercaseLabels.contains("floor") || lowercaseLabels.contains("roof") ||
            lowercaseLabels.contains("paint") || lowercaseLabels.contains("crack") ||
            lowercaseLabels.contains("construction") || lowercaseLabels.contains("brick") ) {
            return "Civil works";
        }


        // //AC Detection
        // if (lowercaseLabels.contains("air conditioner") || lowercaseLabels.contains("ac") || 
        //    lowercaseLabels.contains("home appliance") ||
        //    lowercaseLabels.contains("electronic device") ||
        //     lowercaseLabels.contains("air conditioning") || lowercaseLabels.contains("vent") ||
        //     lowercaseLabels.contains("cooling") || lowercaseLabels.contains("air conditioning unit") ||
        //     !lowercaseLabels.contains("lighting")) {
        //     return "AC";
        // }
        // // Geyser Detection
        // if (!lowercaseLabels.contains("electrical cable")||lowercaseLabels.contains("water heater") || lowercaseLabels.contains("geyser") ||
        //     lowercaseLabels.contains("heater") || lowercaseLabels.contains("hot water") ||
        //     lowercaseLabels.contains("water heating")|| !lowercaseLabels.contains("pipe") ||
        //     !lowercaseLabels.contains("machine")|| lowercaseLabels.contains("plumbing fixture") ) {
        //     return "Geyser";
        // }

        // Plumbing Detection
        if (lowercaseLabels.contains("plumbing") || lowercaseLabels.contains("pipe") || 
            lowercaseLabels.contains("faucet") || lowercaseLabels.contains("tap") ||
            lowercaseLabels.contains("drain") || lowercaseLabels.contains("leak") ||
            lowercaseLabels.contains("water") || lowercaseLabels.contains("sink") ||
            lowercaseLabels.contains("toilet") || lowercaseLabels.contains("shower") ||
            lowercaseLabels.contains("fluid")) {
            return "Plumbing";
        }
        //AC Detection
        if (lowercaseLabels.contains("air conditioner") || lowercaseLabels.contains("ac") || 
           lowercaseLabels.contains("home appliance") ||
           lowercaseLabels.contains("electronic device") ||
            lowercaseLabels.contains("air conditioning") || lowercaseLabels.contains("vent") ||
            lowercaseLabels.contains("cooling") || lowercaseLabels.contains("air conditioning unit") ||
            !lowercaseLabels.contains("lighting")) {
            return "AC";
        }

        // Geyser Detection
        if (!lowercaseLabels.contains("electrical cable")||lowercaseLabels.contains("water heater") || lowercaseLabels.contains("geyser") ||
            lowercaseLabels.contains("heater") || lowercaseLabels.contains("hot water") ||
            lowercaseLabels.contains("water heating")|| !lowercaseLabels.contains("pipe") ||
            !lowercaseLabels.contains("machine")|| lowercaseLabels.contains("plumbing fixture") ) {
            return "Geyser";
        }
        // Cleaning Detection
        if (lowercaseLabels.contains("clean") || lowercaseLabels.contains("dirty") ||
            lowercaseLabels.contains("mess") || lowercaseLabels.contains("trash") ||
            lowercaseLabels.contains("garbage") || lowercaseLabels.contains("dust")) {
            return "Room/Washroom Cleaning";
        }
        
    
        
        // CHANGED: Return clear message instead of wrong category
        return "Image not detected"; // When no specific category matched
    }
}


