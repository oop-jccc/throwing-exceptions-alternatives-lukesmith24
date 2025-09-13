using throw_exception_alternative.models;
using static throw_exception_alternative.MainController;

namespace throw_exception_alternative;

public class Tests
{
    [Test]
    public void MpgHappyPath()
    {
        var expectedMpGResult = new Result<MilesPerGallon>
        {
            Value = new MilesPerGallon { Miles = 100.0, Gallons = 5.0, Mpg = 20.0 }
        };

        var actualMpgResult = GetMilesPerGallon(miles: 100.0, gallons: 5.0);

        Assert.That(actualMpgResult, Is.EqualTo(expectedMpGResult));
    }

    [Test]
    public void MpgNegativeMilesPath()
    {
        var expectedMpGResult = new Result<MilesPerGallon>
        {
            ErrorMessage = "Miles and gallons must be >= 0"
        };

        var actualMpgResult = GetMilesPerGallon(miles: -100.0, gallons: 5.0);

        Assert.That(actualMpgResult, Is.EqualTo(expectedMpGResult));
    }
}
