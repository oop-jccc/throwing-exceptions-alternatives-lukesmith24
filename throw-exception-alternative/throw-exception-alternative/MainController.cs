using throw_exception_alternative.models;

namespace throw_exception_alternative;

public static class MainController
{
    public static MilesPerGallon? GetMilesPerGallon(double miles, double gallons)
    {
        if (gallons == 0)
        {
            //log error gallons must != 0"
            return null;
        }

        if (miles < 0 || gallons < 0)
        {
            //log error miles and gallons must be >= 0"
            return null;
        }

        return new MilesPerGallon
        {
            Miles = miles,
            Gallons = gallons,
            Mpg = miles / gallons
        };
    }
}
