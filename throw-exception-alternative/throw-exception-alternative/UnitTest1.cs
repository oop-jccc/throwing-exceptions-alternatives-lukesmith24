namespace throw_exception_alternative;
// TODO: Create a CustomUnauthorizedException class that inherits from Exception

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
            // TODO: Uncomment this line after you have created the CustomUnauthorizedException class
            // throw new CustomUnauthorizedException("Invalid username or password");
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
        // TODO: Uncomment this line after you have created the CustomUnauthorizedException class
        // Assert.Throws<CustomUnauthorizedException>(() => { AuthService.Authenticate("user555", "password"); });
    }
}