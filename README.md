# In-Class Programming Assignment: Handling Errors with Result<T>

## Objective

The goal of this exercise is to understand how to use `Result<T>` for error handling in a more functional way, as opposed to using exceptions. You'll start with a basic user authentication service that currently has `TODO` comments where you need to implement error handling using `Result<T>`.

## Starter Code

You are provided with a starter code that includes a `Result<T>` record, a `User` record, an `AuthService` class, and some test cases. The `AuthService` class contains `TODO` comments where you'll need to return a `Result` object with the appropriate error message.

```csharp
// TODO: return Result with error message instead of throwing exception
```

## Steps

1. **Implement Error Handling**: In the `AuthService` class, replace the `TODO` comments with code that returns a `Result<User>` object with the appropriate error message. You can find the correct error message strings in the test cases.

2. **Run Tests**: After implementing the error handling, run the test cases to make sure that your implementation is correct. The test cases check both the happy path and the error cases.