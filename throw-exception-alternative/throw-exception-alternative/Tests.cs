using throw_exception_alternative.models;
using static throw_exception_alternative.MainController;

namespace throw_exception_alternative;

public class Tests
{
    [Test]
    public void MpgHappyPath()
    {
        var expectedMpg = new MilesPerGallon { Miles = 100.0, Gallons = 5.0, Mpg = 20.0 };
        var actualMpg = GetMilesPerGallon(miles: 100.0, gallons: 5.0);

        Assert.That(actualMpg, Is.EqualTo(expectedMpg));
    }

    [Test]
    public void MpgNegativeMilesPath()
    {
        var actualMpg = GetMilesPerGallon(miles: -100.0, gallons: 5.0);
        
        Assert.That(actualMpg, Is.Null);
        
        var miles = actualMpg?.Miles; // ?. null-conditional operator
        Assert.That(miles, Is.Null);
    }
}
