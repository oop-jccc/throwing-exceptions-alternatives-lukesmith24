namespace throw_exception_alternative;

public class CustomUnauthorizedException : Exception
{
    public CustomUnauthorizedException()
        : base("Unauthorized: Invalid username or password")
    {
        // Empty body
    }

    public CustomUnauthorizedException(string message)
        : base(message)
    {
        // Empty body
    }

    public CustomUnauthorizedException(string message, Exception inner)
        : base(message, inner)
    {
        // Empty body
    }
}

public record User
{
    public string? Username { get; init; }
    public string? Password { get; init; }
}

public static class AuthService
{
    public static User Authenticate(string? username, string? password)
    {
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            throw new ArgumentException("Username and password must not be empty");
        }

        if (username != "admin" || password != "password")
        {
            throw new CustomUnauthorizedException("Invalid username or password");
        }

        return new User
        {
            Username = username,
            Password = password
        };
    }
}

public class Tests
{
    [Test]
    public void TestHappyPath()
    {
        var user = AuthService.Authenticate("admin", "password");
        Assert.Multiple(() =>
        {
            Assert.That(user.Username, Is.EqualTo("admin"));
            Assert.That(user.Password, Is.EqualTo("password"));
        });
    }

    [Test]
    public void TestEmptyUsername()
    {
        Assert.Throws<ArgumentException>(() => { AuthService.Authenticate("", "password"); });
    }

    [Test]
    public void TestNonAdmin()
    {
        Assert.Throws<CustomUnauthorizedException>(() => { AuthService.Authenticate("user555", "password"); });
    }
}