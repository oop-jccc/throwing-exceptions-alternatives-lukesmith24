using throw_exception_alternative.models;

namespace throw_exception_alternative;

public static class MainController
{
    public static Result<MilesPerGallon> GetMilesPerGallon(double miles, double gallons)
    {
        if (gallons == 0)
        {
            return new Result<MilesPerGallon>
            {
                Value = null,
                ErrorMessage = "Gallons must != 0"
            };
        }

        if (miles < 0 || gallons < 0)
        {
            return new Result<MilesPerGallon>
            {
                Value = null,
                ErrorMessage = "Miles and gallons must be >= 0"
            };
        }

        return new Result<MilesPerGallon>
        {
            Value = new MilesPerGallon
            {
                Miles = miles,
                Gallons = gallons,
                Mpg = miles / gallons
            }
        };
    }
}
