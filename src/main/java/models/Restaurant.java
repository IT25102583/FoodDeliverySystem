package models;

public class Restaurant extends User {
    private String restaurantId;
    private String restaurantName;
    private String contactNumber;
    private String address;
    private boolean isOpen; // Added this to match the UberEats style

    // Default Constructor
    public Restaurant() {
        super(); // Calls the User default constructor
    }

    // Parameterized Constructor using 'super' keyword
    public Restaurant(String username, String password, String restaurantId, String restaurantName, String contactNumber, String address, boolean isOpen) {
        super(username, password); // Passes login info up to the User class
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.contactNumber = contactNumber;
        this.address = address;
        this.isOpen = isOpen;
    }

    // Getters and Setters
    public String getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isOpen() {
        return isOpen;
    }

    public void setOpen(boolean isOpen) {
        this.isOpen = isOpen;
    }

    // Helper method to write this object to a text file later (CSV format)
    public String toFileFormat() {
        return getUsername() + "," + getPassword() + "," + restaurantId + "," + restaurantName + "," + contactNumber + "," + address + "," + isOpen;
    }
}