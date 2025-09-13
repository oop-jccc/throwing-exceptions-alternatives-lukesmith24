namespace throw_exception_alternative;

public record Result<T>
{
    public T? Value { get; init; }
    public string? ErrorMessage { get; set; }
};
