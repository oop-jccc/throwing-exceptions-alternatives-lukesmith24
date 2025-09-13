using throw_exception_alternative.models;
using static throw_exception_alternative.MainController;

namespace throw_exception_alternative;

public class Tests
{
    private static (double miles, double gallons, Result<MilesPerGallon> expectedResult)[] _testCases =
    {
        (miles: 100.0, gallons: 5, new Result<MilesPerGallon> { Value = new MilesPerGallon { Miles = 100.0, Gallons = 5, Mpg = 20.0 } }),
        (miles: -100.0, gallons: 5, new Result<MilesPerGallon> { ErrorMessage = "Miles and gallons must be >= 0" }),
        (miles: 100.0, gallons: 0, new Result<MilesPerGallon> { ErrorMessage = "Miles cannot be 0" }),
    };

    [TestCaseSource(nameof(_testCases))]
    public void MpgTests((double miles, double gallons, Result<MilesPerGallon> expectedResult) testCase)
    {
        var actualMpgResult = GetMilesPerGallon(testCase.miles, testCase.gallons);

        Assert.That(actualMpgResult, Is.EqualTo(testCase.expectedResult));
    }
}
