using throw_exception_alternative.exceptions;
using throw_exception_alternative.models;

namespace throw_exception_alternative;

public static class MainController
{
    public static MilesPerGallon GetMilesPerGallon(double miles, double gallons)
    {
        if (gallons == 0)
        {
            throw new CannotBeZeroException("gallons be != 0");
        }

        if (miles < 0 || gallons < 0)
        {
            throw new NegativeNumberException("miles and gallons must be >= 0");
        }

        return new MilesPerGallon
        {
            Miles = miles,
            Gallons = gallons,
            Mpg = miles / gallons
        };
    }
}
