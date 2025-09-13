namespace throw_exception_alternative;

public static class ExceptionHandlingService
{
    public static string HandleException(Exception ex)
    {
        string message;
        if (ex.GetType() == typeof(NullReferenceException))
        {
            message = ex.Message;
        }
        else if (ex.GetType() == typeof(ArgumentException))
        {
            message = ex.Message;
        }
        else if (ex.GetType() == typeof(DivideByZeroException))
        {
            message = ex.Message;
        }
        else
        {
            throw ex;
        }

        return message;
    }
}
