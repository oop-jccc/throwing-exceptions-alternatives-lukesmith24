# In-Class Programming Assignment: Handling Errors with Custom Exceptions

## Objective

The goal of this exercise is to understand how to create and use custom exceptions for error handling. You'll start with a basic user authentication service that currently uses built-in exceptions. Your task is to create a custom exception and integrate it into the existing code.

## Starter Code

You are provided with a starter code that has a `User` record, an `AuthService` class, and some test cases. The `AuthService` class contains a `TODO` comment where you'll need to uncomment a line of code after creating your custom exception.

```csharp
// TODO: Uncomment this line after you have created the CustomUnauthorizedException class
// throw new CustomUnauthorizedException("Invalid username or password");
```

## Steps

1. **Create Custom Exception**: Create a new class called `CustomUnauthorizedException` that inherits from the `Exception` class. This class should have three constructors:
    - A parameterless constructor
    - A constructor that takes a message string
    - A constructor that takes a message string and an inner exception

2. **Integrate Custom Exception**: Once you've created the `CustomUnauthorizedException` class, go back to the `AuthService` class and uncomment the line that throws this custom exception.

3. **Update Test Cases**: In the `Tests` class, you'll find another `TODO` comment. Uncomment the line that uses `CustomUnauthorizedException` in the `Assert.Throws` method.

```csharp
// TODO: Uncomment this line after you have created the CustomUnauthorizedException class
// Assert.Throws<CustomUnauthorizedException>(() => { AuthService.Authenticate("user555", "password"); });
```

4. **Run Tests**: After uncommenting the lines, run the tests to make sure everything is working as expected.