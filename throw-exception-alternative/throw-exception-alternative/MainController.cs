using throw_exception_alternative.exceptions;
using throw_exception_alternative.models;

namespace throw_exception_alternative;

public static class MainController
{
    public static MilesPerGallon GetMilesPerGallon(double miles, double gallons)
    {
        return new MilesPerGallon
        {
            Miles = miles,
            Gallons = gallons,
            Mpg = miles / gallons
        };
    }
}
