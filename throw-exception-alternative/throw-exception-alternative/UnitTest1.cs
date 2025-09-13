namespace throw_exception_alternative;

public record Result<T>
{
    public T? Value { get; init; }
    public string? ErrorMessage { get; set; }
}

public record User
{
    public string? Username { get; init; }
    public string? Password { get; init; }
}

public static class AuthService
{
    public static Result<User> Authenticate(string username, string password)
    {
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            return new Result<User>
            {
                ErrorMessage = "Username and password must not be empty"
            };
        }

        if (username != "admin" || password != "password")
        {
            return new Result<User>
            {
                ErrorMessage = "Invalid username or password"
            };
        }

        return new Result<User>
        {
            Value = new User
            {
                Username = username,
                Password = password
            }
        };
    }
}

public class Tests
{
    [Test]
    public void TestHappyPath()
    {
        Result<User> user = AuthService.Authenticate("admin", "password");
        Assert.Multiple(() =>
        {
            Assert.That(user.Value?.Username, Is.EqualTo("admin")); // note the ? after Value
            Assert.That(user.Value?.Password, Is.EqualTo("password")); // note the ? after Value
        });
    }

    [Test]
    public void TestEmptyUsername()
    {
        Result<User> user = AuthService.Authenticate("", "password");
        Assert.That(user.ErrorMessage, Is.EqualTo("Username and password must not be empty"));
    }

    [Test]
    public void TestNonAdmin()
    {
        Result<User> user = AuthService.Authenticate("user555", "password");
        Assert.That(user.ErrorMessage, Is.EqualTo("Invalid username or password"));
    }
}