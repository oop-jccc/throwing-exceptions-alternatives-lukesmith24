namespace throw_exception_alternative.exceptions;

public class NegativeNumberException : Exception
{
    public NegativeNumberException()
        : base("Illegal operation for a negative number")
    {
        // empty body                                      
    }

    public NegativeNumberException(string messageValue)
        : base(messageValue)
    {
        // empty body                                     
    }

    // constructor for customizing the exception's error
    // message and specifying the InnerException object 
    public NegativeNumberException(string messageValue, Exception inner)
        : base(messageValue, inner)
    {
        // empty body                                    
    }
}
