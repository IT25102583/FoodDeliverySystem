package models;

// Abstraction: User is an abstract class - it cannot be instantiated directly.
// It defines the common blueprint for all user types in the system.
public abstract class User {

    // Encapsulation / Information Hiding: Private fields
    private String username;
    private String password;

    // Default Constructor
    public User() {
    }

    // Parameterized Constructor
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // Abstraction: Abstract methods that every subclass MUST implement.
    // This enforces a contract without revealing implementation details here.

    // Polymorphism: Each subclass will return its own role type.
    public abstract String getRole();

    // Polymorphism: Each subclass will define how its data is saved to a file.
    public abstract String toFileFormat();
}
