package models;

// Inheritance: Restaurant IS-A User. It inherits username and password from User.
public class Restaurant extends User {

    // Encapsulation: Private fields specific to a Restaurant
    private String restaurantId;
    private String restaurantName;
    private String contactNumber;
    private String address;
    private boolean isOpen;

    // Default Constructor
    public Restaurant() {
        super(); // Calls the User default constructor
    }

    // Parameterized Constructor using the 'super' keyword
    public Restaurant(String username, String password, String restaurantId, String restaurantName, String contactNumber, String address, boolean isOpen) {
        super(username, password); // Passes login credentials up to the User class
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

    // Polymorphism: Overriding the abstract method from User.
    // A Restaurant's role is "RESTAURANT".
    @Override
    public String getRole() {
        return "RESTAURANT";
    }

    // Polymorphism: Overriding the abstract method from User.
    // Defines exactly how a Restaurant object is written to the data file (CSV format).
    @Override
    public String toFileFormat() {
        return getUsername() + "," + getPassword() + "," + restaurantId + "," + restaurantName + "," + contactNumber + "," + address + "," + isOpen;
    }
}
