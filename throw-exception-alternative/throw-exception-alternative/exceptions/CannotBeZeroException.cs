namespace throw_exception_alternative.exceptions;

public class CannotBeZeroException : ArgumentOutOfRangeException
{
    public CannotBeZeroException(string parameter): base(parameter, "value cannot be 0")
    {
        // empty
    }
}
